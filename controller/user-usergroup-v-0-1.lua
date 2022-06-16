--i_code 默认与model重名***********************************
local i_code="join_user_usergroup"
local Base = require("controller.base")
local iotservice = require "model.iotservice"
local l_model=iotservice[i_code]
local all_usergroup=iotservice.all_usergroup
local all_user=iotservice.all_user
local Home = Base:extend()
local json=require("modules.json")
local loginstatus=require("modules.adminloginstatus")
--请求方法列表
local req_funclist={}
--密钥
local ek=""
--访问权限码
local token=""
--限制查询条数
local return_limit=1000
--创建条件---------------------------------
local post_list={u_id="",ug_id=""}
--查询条件----------------------------------限制不超过10000条
local get_list={id="",dt_code="",dt_name="",dt_val_max="",dt_val_table=""}
-------------------------------------------


function Home:get()
print("\r","------------get did------------------------------------------------------------------------------------------------","\n")
if ngx.req.get_method() ~= "POST" then  return end
local t=json.decode(ngx.req.get_body_data()) or {}
local auth=loginstatus.read_status(t.ek)
if not auth then return ngx.say([[{"error":"need ek"} ]]) end
local list={}
local cnt=0
if not t.limit then cnt=l_model:newsql():where_and(t.where or {{"id",">","0"}}):count() end
if cnt>return_limit then  ngx.say([[{"error":"return lists too much "}]],return_limit) return end
if t.count then   return cnt end
if (not t.where) then list = l_model:newsql():columns(t.columns or '*'):orderby((t.orderby or 'id'),(t.sort or "desc")):all(t.limit or 0)   end
if t.where then list = l_model:newsql():columns(t.columns or '*'):where_and(t.where or {{"id",">","0"}}):orderby((t.orderby or 'id'),(t.sort or "desc")):all(t.limit or 0) end -- 可以多个where

print("\r","--------------------------------------------------------------------------------------------------------------------","\n")
return self:json(list)
end

function Home:post()
print("\r","------------post did------------------------------------------------------------------------------------------------","\n")
if ngx.req.get_method() ~= "POST" then  return end
local t=json.decode(ngx.req.get_body_data()) or {}
local auth=loginstatus.read_status(t.ek)
if not auth then return ngx.say([[{"error":"need ek"} ]]) end
for k,v in pairs(post_list) do
if not t[k] then ngx.say([[{"error":"params not enough"}]]) return end
post_list[k]=t[k]
end
local user_list=all_user:newsql():where_and({{"id","=",t.u_id}}):all()  
if not (user_list[1] ) then  ngx.say([[{"error":"user not exist"}]]) return end
local usergroup_list=all_usergroup:newsql():where_and({{"id","=",t.ug_id}}):all()  
if not (  usergroup_list[1]) then  ngx.say([[{"error":"usergroup not exist"}]]) return end
post_list.u_name=user_list[1].u_name
post_list.u_phone=user_list[1].u_phone
post_list.u_wxid=user_list[1].u_wxid
post_list.ug_name=usergroup_list[1].ug_name
post_list.ug_code=usergroup_list[1].ug_code
post_list.join_sql=t.u_id..t.ug_id
post_list.u_wxid=t.wxid
local insertId = l_model:newsql():create(post_list)

print("\r","--------------------------------------------------------------------------------------------------------------------","\n")
return self:json(insertId)
end

function Home:delete(t)
print("\r","------------delete did------------------------------------------------------------------------------------------------","\n")
if ngx.req.get_method() ~= "POST" then  return end
local t=json.decode(ngx.req.get_body_data()) or {}
local auth=loginstatus.read_status(t.ek)
if not auth then return ngx.say([[{"error":"need ek"} ]]) end
local affectrows = l_model:newsql():where_and({{"id","=",t.id}}):delete()

print("\r","--------------------------------------------------------------------------------------------------------------------","\n")
return self:json("delete success")

end
 


return Home