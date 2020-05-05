#!/bin/sh

set -e
set -u

script_name="$(basename "$0")"
script_dir="$(cd `dirname "$0"` && pwd)"

. "${script_dir}/../conf/${script_name}.cfg"

usage() {
	if [ "${1--}" != "-" ]; then
		echo $(basename "$0"): "$@" 1>&2
		echo
	fi

	echo "usage: $(basename "$0") <options>"
	echo "options:"
	echo "  -j <file> install Java from tar.gz file"
	echo "  -w <file> install Weblogic from jar file"
	echo "  -h        print this help and exit"
	echo "  --        end of options"
	echo "info:"
	echo "  tested on Linux"

	if [ "${1-}" = "-" ]; then
		return 0
	fi
	exit 64
}

parse_options() {
	if [ $# = 0 ]; then
		usage "no arguments provided"
	fi
	OPTIND=1
	while getopts ":hj:w:" opt; do
		case $opt in
			\? ) usage "illegal option -- ${OPTARG}"; ;;
			: ) usage "option requires an argument -- ${OPTARG}"; ;;
			h ) usage -; exit 0; ;;
			j ) java_install="${OPTARG}"; ;;
			w ) weblogic_install="${OPTARG}"; ;;
		esac
	done
	shift $(($OPTIND - 1))
	if [ $# != 0 ]; then
		usage "unrecognized option --" "$@"
	fi
}

main() {
	# os_kernel="$(uname -s)"
	# if [ "$os_kernel" != "Linux" ]; then
	# 	usage "${os_kernel} not supported"
	# fi
	parse_options ${1+"$@"}

	if [ ! -f "${java_install-}" ]; then
		usage "java instalation file not exist"
	fi
	java_install="$(cd `dirname "$java_install"` && pwd)/$(basename "$java_install")"
	# echo "java_install=${java_install}"

	if [ ! -f "${weblogic_install-}" ]; then
		usage "weblogic instalation file not exist"
	fi
	weblogic_install="$(cd `dirname "$weblogic_install"` && pwd)/$(basename "$weblogic_install")"
	# echo "weblogic_install=${weblogic_install}"

	# echo "wl_system_user=${wl_system_user}"
	# echo "wl_system_uid=${wl_system_uid}"
	# echo "wl_system_group=${wl_system_group}"
	# echo "wl_system_gid=${wl_system_gid}"

	if [ ! -d "${wl_java_dir}/jdk" ]; then
		mkdir -p "${wl_java_dir}/jdk"
	fi
	cd "${wl_java_dir}/jdk"
	tar --strip-components 1 -zxf "${java_install}"

	echo "$(sed "s|^inventory_loc=.*|inventory_loc=${wl_working_dir}/oraInventory|" "${script_dir}/../conf/oraInst.loc")" > "${script_dir}/../conf/oraInst.loc"
	echo "$(sed "s|^inst_group=.*|inst_group=${wl_system_group}|" "${script_dir}/../conf/oraInst.loc")" > "${script_dir}/../conf/oraInst.loc"
	echo "$(sed "s|^ORACLE_HOME=.*|ORACLE_HOME=${wl_oracle_home}|" "${script_dir}/../conf/wls_install.rsp")" > "${script_dir}/../conf/wls_install.rsp"
	"${wl_java_dir}/jdk/bin/java" -jar "${weblogic_install}" -silent -responseFile "${script_dir}/../conf/wls_install.rsp" -invPtrLoc "${script_dir}/../conf/oraInst.loc"

	# echo "wl_working_dir=${wl_working_dir}"
	# echo "wl_java_dir=${wl_java_dir}"
	# echo "wl_oracle_home=${wl_oracle_home}"
}

main ${1+"$@"}
