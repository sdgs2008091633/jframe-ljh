local Base = require("controller.base")
local iotservice = require "model.iotservice"
local Home = Base:extend()
local json=require("modules.json")
local aucrek=require("modules.autocrek").AUTOCREK
local loginstatus=require("modules.adminloginstatus")
local admin_user=iotservice.admin_user
--请求方法列表
local req_funclist={}

function Home:index()
local method= ngx.req.get_method() or "GET"

    local data=ngx.req.get_body_data()
	print("\n","req.body:",data,"\n")
	local data_table=json.decode(data) or {}
	--if not loginstatus.read_status(data_table.ek) then return  end
 
	if not data_table.au_code then ngx.say([[{"error":"need params"}]]) return end
	if not data_table.au_pass then ngx.say([[{"error":"need params"}]]) return end
	print("\r","------------adminlogin post did------------------------------------------------------------------------------------------------","\n")
	local list={}
	local cnt=0
	list = admin_user:newsql():columns({"au_name","au_code","au_phone","au_ek","au_pass","au_login_timestamp"}):where_and({{"au_code","=",tostring(data_table.au_code)}}):all() -- 可以多个where
	if not list[1] then  ngx.say([[{"error":"no params"}]]) return end
	print("list:",json.encode(list[1]))
	print("t.au_pass",data_table.au_pass)
	if ngx.time()- list[1].au_login_timestamp  <3 then  ngx.say([[{"error":"login frequency too fast"}]]) return end
	if data_table.au_pass ~= list[1].au_pass then  ngx.say([[{"error":"wrong params"}]]) return end
	local data={}

	data.au_ek=string.gsub(table.concat(aucrek(ngx.time())),'"',"")
	
	data.au_login_timestamp=ngx.time()
	local affect_rows = admin_user:newsql():where_and({{"au_code","=",list[1].au_code}}):update(data)
	list[1].au_pass=""
	list[1].au_ek=data.au_ek
	local writestatus={list[1].au_code,list[1].au_ek}
	loginstatus.write_status(writestatus)
	self:json({list[1].au_ek},"login success")
end

 

return Home
