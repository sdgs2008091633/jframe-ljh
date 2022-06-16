local is_start=0

local iotservice = require "model.iotservice"
local device=iotservice.device
local delay = 6
local handler
local json=require("modules.json")
local sendsms=require("modules.sendsms").send_sms
local warning_log=iotservice.warning_log
local sms_log=iotservice.sms_log

handler = function ()
	
	print("off line warning sms pushing----------------------------------------------------------------------------")
	local device_list=device:newsql():columns({'dvc_pulse_timestamp','off_line_warning_group','dvc_addr','dvc_code','dvc_name'}):where_and({{'is_off_line_warning_sms','=','1'}}):all()
	for k,v in pairs(device_list) do
		if ngx.time()-v.dvc_pulse_timestamp>900 then 
			local send_list=json.decode(v.off_line_warning_group)
			if not send_list then print("off_line_warning_group string wrong") end
			local data={}
			for i,j in pairs(send_list) do 
				data.sl_code=v.dvc_code..j..(string.sub(tostring(ngx.time()),1,-5))
				data.sl_content=v.dvc_addr..":"..v.dvc_code.."-设备离线"
				data.sl_phone=j
				data.sl_sendname=i
				data.sl_timestamp=ngx.time()
				local content={v.dvc_name..'-'..v.dvc_code,"设备离线","0",v.dvc_addr,tostring(ngx.localtime())}

				if pcall(function ()
					print("send sms timer---------------------------------------------------------------------")
					local insertId2 = sms_log:newsql():create(data)
					end
					)
					--then sendsms(j,content)
					then print(j,":sms send----------------------------------------------------------")
					else print("sms not send--------------------------------------------------------------------")
				end

			end
		
		end
	end
end

if is_start>0 then print("off line sms started") end
local ok, err = ngx.timer.every(delay, handler)
is_start=1
if not ok then
ngx.log(ngx.ERR, "off line warning sms push failed: ", err)
return
end