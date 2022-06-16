--i_code 默认与model重名***********************************
local i_code="device_data"
--创建条件---------------------------------
local post_list={dt_name="",dt_code="",dt_val_max="",dt_val_table=""}
--查询条件默认为空----------------------------------限制不超过10000条
local get_list={id="",dt_code="",dt_name="",dt_val_max="",dt_val_table=""}
local Base = require("controller.base")
local iotservice = require "model.iotservice"
local device=iotservice.device
local device_val=iotservice.device_val
local l_model=iotservice[i_code]
local Home = Base:extend()
local json=require("modules.json")
local loginstatus=require("modules.userloginstatus")
--请求方法列表
local req_funclist={}
--密钥
local ek=""
--访问权限码
local token=""
--限制查询条数
local return_limit=10000




function Home:get()
if ngx.req.get_method() ~= "POST" then  return end
local t=json.decode(ngx.req.get_body_data()) or {}
--local auth=loginstatus.read_status(t.ek)
--if not auth then return ngx.say([[{"error":"need ek"} ]]) end
	local list={}
	print("\r","------------get did------------------------------------------------------------------------------------------------","\n")
	if not t.ek then ngx.say([[{"error":"need dv_ek"}]]) return  end
	if not t.where then ngx.say([[{"error":"need where params"}]]) return  end
		if (t.where[1][1]=="dv_code") or (t.where[1][1]=="dvc_code")  then
		else ngx.say([[{"error":"query must be dv_code or dvc_code"}]]) return 
	end
	
	--通过dvcod查询ek
	if (t.where[1][1]=="dv_code") then
	local list_device_val = device_val:newsql():columns("dvc_code"):where_and({{t.where[1][1],"=",t.where[1][3]}}):all()  
	if not list_device_val[1] then ngx.say([[{"error":"device not exist"}]]) return end
	local list_device =device:newsql():columns("dvc_ek"):where_and({{"dvc_code","=",list_device_val[1].dvc_code}}):all()
	if t.ek~= list_device[1].dvc_ek then  ngx.say([[{"error":"ek wrong"}]]) return end
	end
	--通过dvccode查询ek
	if (t.where[1][1]=="dvc_code") then
	local list_device = device:newsql():columns("dvc_ek"):where_and({{"dvc_code","=",t.where[1][3]}}):all()  
	if not list_device[1] then ngx.say([[{"error":"device not exist"}]]) return end
	if t.ek~= list_device[1].dvc_ek then  ngx.say([[{"error":"ek wrong"}]]) return end
	end


	local cnt=0
	if not t.limit then cnt=l_model:newsql():where_and(t.where or {{"id",">","0"}}):count() end
	--print("cnt:",cnt)
	if cnt>return_limit then   ngx.say([[{"error":"return lists too much "}]]) return end
	if t.limit then if t.limit>return_limit then ngx.say([[{"error":"return lists too much"}]] ) return end end
	if t.count then return cnt end
	if (not t.where) then list = l_model:newsql():columns(t.columns or '*'):orderby((t.orderby or 'id'),(t.sort or "desc")):all(t.limit or 0)   end
	if t.where then list = l_model:newsql():columns(t.columns or '*'):where_and(t.where or {{"id","=","0"}}):orderby((t.orderby or 'id'),(t.sort or "desc")):all(t.limit or 0) end 
	print("\r","--------------------------------------------------------------------------------------------------------------------","\n")
	return self:json(list)
end

 
 
 

return Home