local Base = (require "model.base"):extend()
local iotservice={}
--设置区域*****************************************
iotservice.admin_user = Base("admin_user")
iotservice.all_user = Base("all_user")
iotservice.device = Base("device")
iotservice.device_type = Base("device_type")
iotservice.device_val = Base("device_val")
iotservice.device_data = Base("device_data")
iotservice.login_info = Base("login_info")
iotservice.warning_log = Base("warning_log")
iotservice.sms_log=Base("sms_log")
---------------------------------------------------
return iotservice
