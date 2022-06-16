--i_code 默认与model重名***********************************
local i_code="device_val"
--创建条件---------------------------------
local post_list={dt_name="",dt_code="",dt_val_max="",dt_val_table=""}
--查询条件默认为空----------------------------------限制不超过10000条
local get_list={id="",dt_code="",dt_name="",dt_val_max="",dt_val_table=""}
local Base = require("controller.base")
local iotservice = require "model.iotservice"
local device=iotservice.device
local device_data=iotservice.device_data
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


-------------------------------------------
 

function Home:get(t)
print("\r","------------get did------------------------------------------------------------------------------------------------","\n")
if ngx.req.get_method() ~= "POST" then  return end
local t=json.decode(ngx.req.get_body_data()) or {}
--local auth=loginstatus.read_status(t.ek)
--if not auth then return ngx.say([[{"error":"need ek"} ]]) end
local list={}
local cnt=0
if not t.limit then cnt=l_model:newsql():where_and(t.where or {{"id",">","0"}}):count() end
print("cnt:",cnt)
if cnt>return_limit then  ngx.say([[{"error":"return lists bigger than "}]],return_limit) return end
if t.count then  return cnt end
if (not t.where) then list = l_model:newsql():columns(t.columns or '*'):orderby((t.orderby or 'id'),(t.sort or "desc")):all(t.limit or 0)   end
if t.where then list = l_model:newsql():columns(t.columns or '*'):where_and(t.where or {{"id","=","0"}}):orderby((t.orderby or 'id'),(t.sort or "desc")):all(t.limit or 0) end -- 可以多个where
print("\r","--------------------------------------------------------------------------------------------------------------------","\n")
return self:json(list)
end

 
 

return Home