#!/bin/sh

script_name="$(basename "$0")"
script_dir="$(cd `dirname "$0"` && pwd)"

. "${script_dir}/../conf/${script_name}.cfg"
