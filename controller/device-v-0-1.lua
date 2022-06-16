--i_code 默认与model重名***********************************
local i_code="device"
--创建条件---------------------------------
local post_list={dt_name="",dt_code="",dt_val_max="",dt_val_table=""}
--查询条件默认为空----------------------------------限制不超过10000条
local get_list={id="",dt_code="",dt_name="",dt_val_max="",dt_val_table=""}
local Base = require("controller.base")
local iotservice = require "model.iotservice"
 local device_val=iotservice.device_val
 local join_user_usergroup=iotservice.join_user_usergroup
 local l_model=iotservice[i_code]
local Home = Base:extend()
local json=require("modules.json")
local loginstatus=require("modules.userloginstatus")
local adminloginstatus=require("modules.adminloginstatus")
--请求方法列表
local req_funclist={}
--密钥
local ek=""
--访问权限码
local token=""
--限制查询条数
local return_limit=1000


-------------------------------------------
 

function Home:warninggroup()
 
	local method= ngx.req.get_method() or "GET"
	if method ~= "POST" then return end
    local data=ngx.req.get_body_data()
	print("\n","req.body:",data,"\n")
	local data_table=json.decode(data) or {}
	if not data_table.ek then ngx.say([[{"error":"need ek"}]]) return end
	if not data_table.data 	then ngx.say([[{"error":"need data"}]]) return end
	local device_list=l_model:newsql():columns({'dvc_ek'}):where_and({{'dvc_code','=',tostring(data_table.dvc_code)}}):all()
	if not device_list[1] then ngx.say([[{"error":"device not exsit"}]]) return end
	if device_list[1].dvc_ek~=data_table.ek then ngx.say([[{"error":"ek wrong"}]]) return end
 	local writesql={}
	writesql.warning_group_json=json.encode(data_table.data)
	if pcall(function()local affect_rows = l_model:newsql():where_and({{"dvc_code","=",data_table.dvc_code}}):update(writesql) end)
	then self:json("update success")
	else ngx.say([[{"error":"update wrong"}]])
	end
end

function Home:offlinewarning()
 
	local method= ngx.req.get_method() or "GET"
	if method ~= "POST" then return end
    local data=ngx.req.get_body_data()
	print("\n","req.body:",data,"\n")
	local data_table=json.decode(data) or {}
	if not data_table.ek then ngx.say([[{"error":"need ek"}]]) return end
	if not data_table.data 	then ngx.say([[{"error":"need data"}]]) return end
	local device_list=l_model:newsql():columns({'dvc_ek'}):where_and({{'dvc_code','=',tostring(data_table.dvc_code)}}):all()
	if not device_list[1] then ngx.say([[{"error":"device not exsit"}]]) return end
	if device_list[1].dvc_ek~=data_table.ek then ngx.say([[{"error":"ek wrong"}]]) return end
 	local writesql={}
	writesql.off_line_warning_group=json.encode(data_table.data)
	writesql.is_off_line_warning_sms=1
	if pcall(function()local affect_rows = l_model:newsql():where_and({{"dvc_code","=",data_table.dvc_code}}):update(writesql) end)
	then self:json("update success")
	else ngx.say([[{"error":"update wrong"}]])
	end
end

function Home:dvcaddr()
 
local method= ngx.req.get_method() or "GET"
print("\r","------------dvcaddr post did------------------------------------------------------------------------------------------------","\n")
if method ~= "POST" then print("method must be POST") return  end
    local data=ngx.req.get_body_data()
	print("\n","req.body:",data,"\n")
	local data_table=json.decode(data) or {}
	if not data_table.ek then ngx.say([[{"error":"need ek"}]]) return end
	local device_list=l_model:newsql():columns({'dvc_ek'}):where_and({{'dvc_code','=',tostring(data_table.dvc_code)}}):all()
	if not device_list[1] then ngx.say([[{"error":"device not exsit"}]]) return end
	if device_list[1].dvc_ek~=data_table.ek then ngx.say([[{"error":"ek wrong"}]]) return end
local data={
dvc_addr=data_table.dvc_addr
}

if pcall(function()local affect_rows = l_model:newsql():where_and({{"dvc_code","=",data_table.dvc_code}}):update(data)  end)
then self:json("update success")
else ngx.say([[{"error":"update false"}]])
end
print("\r","--------------------------------------------------------------------------------------------------------------------","\n")
return 
	
	
end

function Home:owenergroup()
 
local method= ngx.req.get_method() or "GET"
print("\r","------------dvcaddr post did------------------------------------------------------------------------------------------------","\n")
if method ~= "POST" then print("method must be POST") return  end
    local data=ngx.req.get_body_data()
	print("\n","req.body:",data,"\n")
	local data_table=json.decode(data) or {}
	if not data_table.ek then ngx.say([[{"error":"need ek"}]]) return end
	local device_list=l_model:newsql():columns({'dvc_ek'}):where_and({{'dvc_code','=',tostring(data_table.dvc_code)}}):all()
	if not device_list[1] then ngx.say([[{"error":"device not exsit"}]]) return end
	if device_list[1].dvc_ek~=data_table.ek then ngx.say([[{"error":"ek wrong"}]]) return end
local data={
owener_group_code=data_table.owener_group_code
}

if pcall(function()local affect_rows = l_model:newsql():where_and({{"dvc_code","=",data_table.dvc_code}}):update(data)  end)
then self:json("update success")
else ngx.say([[{"error":"update false"}]])
end
print("\r","--------------------------------------------------------------------------------------------------------------------","\n")
return 
	
	
end


function Home:dvcmaintain()
 
local method= ngx.req.get_method() or "GET"
print("\r","------------dvcaddr post did------------------------------------------------------------------------------------------------","\n")
if method ~= "POST" then print("method must be POST") return  end
    local data=ngx.req.get_body_data()
	print("\n","req.body:",data,"\n")
	local data_table=json.decode(data) or {}
	if not data_table.ek then ngx.say([[{"error":"need ek"}]]) return end
	local device_list=l_model:newsql():columns({'dvc_ek'}):where_and({{'dvc_code','=',tostring(data_table.dvc_code)}}):all()
	if not device_list[1] then ngx.say([[{"error":"device not exsit"}]]) return end
	if device_list[1].dvc_ek~=data_table.ek then ngx.say([[{"error":"ek wrong"}]]) return end
local data={
dvc_maintain=data_table.dvc_maintain
}

if pcall(function()local affect_rows = l_model:newsql():where_and({{"dvc_code","=",data_table.dvc_code}}):update(data)  end)
then self:json("update success")
else ngx.say([[{"error":"update false"}]])
end
print("\r","--------------------------------------------------------------------------------------------------------------------","\n")
return 
	
	
end

function Home:valueshift()

 local method= ngx.req.get_method() or "GET"
	if method ~= "POST" then return end
    local data=ngx.req.get_body_data()
	print("\n","req.body:",data,"\n")
	local data_table=json.decode(data) or {}
	if not data_table.ek then ngx.say([[{"error":"need ek"}]]) return end
	if not data_table.data 	then ngx.say([[{"error":"need data"}]]) return end
	local device_list=l_model:newsql():columns({'dvc_ek'}):where_and({{'dvc_code','=',tostring(data_table.dvc_code)}}):all()
	if not device_list[1] then ngx.say([[{"error":"device not exsit"}]]) return end
	if device_list[1].dvc_ek~=data_table.ek then ngx.say([[{"error":"ek wrong"}]]) return end
 	local writesql={}
	writesql.dvc_value_shift=json.encode(data_table.data)
	if pcall(function()local affect_rows = l_model:newsql():where_and({{"dvc_code","=",data_table.dvc_code}}):update(writesql) end)
	then self:json("update success")
	else ngx.say([[{"error":"update wrong"}]])
	end
	
	
end

function Home:get()

print("\r","------------get did------------------------------------------------------------------------------------------------","\n")

if ngx.req.get_method() ~= "POST" then  return end
local t=json.decode(ngx.req.get_body_data()) or {}
--local auth=adminloginstatus.read_status(t.ek)
--if not auth then return ngx.say([[{"error":"need ek"} ]]) end
local list={}
local cnt=0
if not t.limit then cnt=l_model:newsql():where_and(t.where or {{"id",">","0"}}):count() end
print("cnt:",cnt)
if cnt>return_limit then  ngx.say([[{"error":"return lists bigger than "}]],return_limit) return end
if t.count then  return cnt end
if (not t.where) then list = l_model:newsql():columns(t.columns or '*'):orderby((t.orderby or 'id'),(t.sort or "desc")):all(t.limit or 0)   end
if t.where then list = l_model:newsql():columns(t.columns or '*'):where_and(t.where or {{"id","=","0"}}):orderby((t.orderby or 'id'),(t.sort or "desc")):all(t.limit or 0) end -- 可以多个where
for k,v in pairs(list) do 
list[k].is_off_line="no"
list[k].time_out=ngx.time() -(tonumber(v.dvc_pulse_timestamp) or 0)
if list[k].time_out  >900 then 
list[k].is_off_line="yes" 

end
end
print("\r","--------------------------------------------------------------------------------------------------------------------","\n")
return self:json(list)
end

function Home:pget()

print("\r","------------device get did------------------------------------------------------------------------------------------------","\n")

if ngx.req.get_method() ~= "POST" then  return end
local t=json.decode(ngx.req.get_body_data()) or {}
if not t.ek then ngx.say([[{"error":"need ek"}]]) return end
local auth=loginstatus.read_status(t.ek)
if not auth then return ngx.say([[{"error":"ek wrong"} ]]) end
local list={}
local cnt=0
local groupcode_list=join_user_usergroup:newsql():columns('ug_code'):where_and({{'u_phone','=',auth}}):all() 
if not groupcode_list[1] then  ngx.say([[{"error":"no permit "}]]) return end
local orwhere={}
for k,v in pairs(groupcode_list) do
orwhere[k]={"owener_group_code","=",v.ug_code}
end
if not t.limit then cnt=l_model:newsql():where_or(orwhere):count() end
print("device-cnt:",cnt)
if cnt>return_limit then  ngx.say([[{"error":"return lists bigger than "}]],return_limit) return end
if t.count then  return cnt end
list = l_model:newsql():columns(t.columns or '*'):where_or(orwhere):orderby((t.orderby or 'id'),(t.sort or "desc")):all(t.limit or 0)   
--if t.where then list = l_model:newsql():columns(t.columns or '*'):where_and(t.where or {{"id","=","0"}}):orderby((t.orderby or 'id'),(t.sort or "desc")):all(t.limit or 0) end -- 可以多个where
for k,v in pairs(list) do 
list[k].is_off_line="no"
list[k].time_out=ngx.time() -(tonumber(v.dvc_pulse_timestamp) or 0)
if list[k].time_out  >900 then 
list[k].is_off_line="yes" 

end
end
print("\r","--------------------------------------------------------------------------------------------------------------------","\n")
return self:json(list)
end
-- function Home:delete(t)
-- print("\r","------------delete did------------------------------------------------------------------------------------------------","\n")
-- if ngx.req.get_method() ~= "POST" then  return end
-- local t=json.decode(ngx.req.get_body_data()) or {}
-- --local auth=loginstatus.read_status(t.ek)
-- --if not auth then return ngx.say([[{"error":"need ek"} ]]) end
-- if t[1]~= "dvc_code" then return ngx.say([[{"error":"delete columns must be dvc_code"}]]) end
-- local affectrows = l_model:newsql():where_and({{(t[1]),(t[2] or "="),t[3]}}):delete()
-- local affectrows2 = device_val:newsql():where_and({{(t[1]),(t[2] or"="),t[3]}}):delete()

-- print("\r","--------------------------------------------------------------------------------------------------------------------","\n")
-- return self:json("delete success")

-- end
 
return Home