local _M={}
local sendsms=require("modules.sendsms").send_sms
local iotservice = require "model.iotservice"
local json=require("modules.json")
local crek=require("modules.autocrek")
local device_type=iotservice.device_type
local device=iotservice.device
local device_val=iotservice.device_val
local device_data=iotservice.device_data
local warning_log=iotservice.warning_log
local sms_log=iotservice.sms_log
local servtoken='Sdgs220425100201'
local dvc_ek=""
local w_list={
w0="消防信号",
w1="人工报警",
w2="求救信号",
w3="应急信号",
w4="断电请求",
w5="防空信号",
w6="水灾信号",
w7="解除警报",
w8="高处撤离",
w9="低处撤离",
w10="有害气体",
w11="瓦斯超标",
w12="温度达标",
w13="粉尘达标",
w14="粉尘超标",
w15="温度超标",
w16="环境合格",

}

--将预警写入数据库
local function write_warning_sql(t)
local data={} 
	data.dvc_code=t.dvcid or "00000000"
	data.dt_code=t.t or "0000"
	data.wl_code=t.cmd
	data.wl_data=tostring(t.n1) or '0'
	data.wl_timestamp=ngx.time()
	data.wl_name=w_list[t.cmd] or "0"
	local device_list=device:newsql():columns({'dvc_addr'}):where_and({{'dvc_code','=',tostring(t.dvcid)}}):all()
	if device_list then data.dvc_addr=(device_list[1].dvc_addr or "0") end
	local insertId2 = warning_log:newsql():create(data)
	 
end

local function warning_sms(t)
local data={}
local device_list=device:newsql():columns({'warning_group_json','dvc_addr','dvc_code','dvc_name'}):where_and({{'dvc_code','=',tostring(t.dvcid)}}):all()
if not device_list[1] then print("device has not set warning list") return end
local send_list=json.decode(device_list[1].warning_group_json)
if not send_list then print("warning_group_json string wrong") end
for k,v in pairs(send_list) do 
data.sl_code=t.dvcid..t.cmd..v..(string.sub(tostring(ngx.time()),1,-5))
data.sl_content=device_list[1].dvc_addr..":"..device_list[1].dvc_name..'-'..device_list[1].dvc_code.."-"..w_list[t.cmd]
data.sl_phone=v
data.sl_sendname=k
data.sl_timestamp=ngx.time()
local content={t.dvcid,w_list[t.cmd],tostring(t.n1),device_list[1].dvc_addr,tostring(ngx.localtime())}

if pcall(function ()
local insertId2 = sms_log:newsql():create(data)
end
)
then sendsms(v,content)
else print("sms not send")
end

end




end



function _M.r(t)
print("\n","t","-------------------------------------------------------------------------------")
print("t:",json.encode(t))
if t.servtoken ~= servtoken then print("worng servtoken:" ,t.servtoken) return   end
local device_type_list=device_type:newsql():where_and({{'dt_code','=',t.t}}):columns({'id','dt_code','dt_name','dt_val_max','dt_val_table'}):all()
print("device_type_list:",json.encode(device_type_list[1]))
if not device_type_list[1].dt_code then print("device_type not exist:",t.t) return  end
local cnt=0
cnt=device:newsql():where_and({{"dvc_code","=",t.dvcid}}):count()
print("cnt:",cnt)
--如果查不到数据，则新增
if cnt<1 then 
	local data={}
	local ektab={"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"}
	if tonumber(t.seed)~=0 then
	ektab=crek.AUTOCREK(t.seed)
	end
	data.dvc_ek=table.concat(ektab)
	data.dvc_ek_seed=t.seed
	data.dvc_code=tostring(t.dvcid)
	data.dt_code=tostring(t.t)
	data.dt_val_max=device_type_list[1].dt_val_max
	data.dvc_name=device_type_list[1].dt_name
	data.dvc_ek_dy_code=t.dcode or "0000000000"
	data.dvc_ek_dy_token=""
	data.dvc_topic=t.topic
	for str in string.gmatch(t.dcode, ".") do 
        data.dvc_ek_dy_token= data.dvc_ek_dy_token..(ektab[(tonumber(str,16))] or "0")
    end
	data.dt_val_table=device_type_list[1].dt_val_table
	data.dvc_status=1
	data.dvc_reg_json=json.encode(t)
	--自动创建设备
	local insertId = device:newsql():create(data)
    --自动创建设备测值
	--print("val_table_str",device_type_list[1].dt_val_table)
	local val_table=loadstring("return "..device_type_list[1].dt_val_table)()
	--print("val_table:",json.encode(val_table))
	for k,v in pairs(val_table) do
		local dv_data_tab={}
		dv_data_tab.dv_code=t.dvcid..tostring(k)
		dv_data_tab.dv_name=v
		dv_data_tab.dvc_code=t.dvcid
		dv_data_tab.dv_key=tostring(k)
		dv_data_tab.dv_ek=table.concat(ektab)
		local insertId2 = device_val:newsql():create(dv_data_tab)
	end

	
end
--如果存在则修改
if cnt>0 then
	local data={}
	local ektab={"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"}
	if tonumber(t.seed) ~= 0 then
	ektab=crek.AUTOCREK(t.seed)
	end
	data.dvc_ek_seed=t.seed
	data.dvc_ek=table.concat(ektab)
	data.dvc_ek_dy_code=t.dcode or "0000000000"
	data.dvc_ek_dy_token=""
	for str in string.gmatch(t.dcode, ".") do 
        data.dvc_ek_dy_token= data.dvc_ek_dy_token..(ektab[(tonumber(str,16))] or "0")
    end
	data.dvc_topic=t.topic
	data.dvc_status=1
	data.dvc_reg_json=json.encode(t)
	local affect_rows = device:newsql():where_and({{"dvc_code","=",t.dvcid}}):update(data)
   
	print('device reg update')
end
 
end



function _M.u(t)

local data={}
for k,v in pairs(t) do
	if string.sub(k,1,1)=="n" and (tonumber(string.sub(k,2,2)) or 0)<9 then 
		data.dvc_code=t.dvcid or ""
		data.dv_code=t.dvcid..tostring(k)
		data.dd_val=tostring(v)
		data.dd_timestamp=ngx.time()
		local insertId2 = device_data:newsql():create(data)
	end
end

	if pcall(
	function ()
		local data={}
		data.dvc_last_val_json=json.encode(t)
		data.dvc_last_val_timestamp=ngx.time() or 0
		local affect_rows = device:newsql():where_and({{"dvc_code","=",t.dvcid}}):update(data)
	end
	)
	then print("last_val_json updated")
	else print("last_val_json update error")
	end

end

function _M.pulse(t)

local data={}
data.dvc_pulse_timestamp=ngx.time()
local affect_rows = device:newsql():where_and({{"dvc_code","=",t.dvcid}}):update(data)
end

function _M.w0(t)
write_warning_sql(t)
warning_sms(t)	
end

function _M.w1(t)

write_warning_sql(t)

end

function _M.w2(t)
write_warning_sql(t)

end

function _M.w3(t)
write_warning_sql(t)
end

function _M.w4(t)
write_warning_sql(t)
end

function _M.w5(t)
write_warning_sql(t)
end

function _M.w6(t)
write_warning_sql(t)
end

function _M.w7(t)
write_warning_sql(t)
end

function _M.w8(t)
write_warning_sql(t)
end

function _M.w9(t)
write_warning_sql(t)
end

function _M.w10(t)
write_warning_sql(t)
warning_sms(t)
end

function _M.w11(t)
write_warning_sql(t)
warning_sms(t)
end
	
function _M.w12(t)
write_warning_sql(t)
end

function _M.w13(t)
write_warning_sql(t)
end


function _M.w14(t)
write_warning_sql(t)
end
return _M