import os

readTemplateForUpdate(os.environ['WL_HOME']+'/common/templates/wls/wls.jar')
cd('/Security/base_domain/User/weblogic')
cmo.setPassword(os.environ['wl_weblogic_pass'])
cd('/')
set('ProductionModeEnabled',True)
writeDomain(os.environ['wl_domain_home'])
closeTemplate()
exit()
