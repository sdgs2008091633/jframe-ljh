local Base = require("controller.base")
local iotservice = require "model.iotservice"
local all_user=iotservice.all_user
local Home = Base:extend()
local json=require("modules.json")
local aucrek=require("modules.autocrek").AUTOCREK
--登陆验证
local loginstatus=require("modules.userloginstatus")
--请求方法列表
local req_funclist={}

function Home:index()
local method= ngx.req.get_method() or "GET"

    local data=ngx.req.get_body_data()
	print("\n","req.body:",data,"\n")
	local t=json.decode(data) or {}

		print("\r","------------user login post did------------------------------------------------------------------------------------------------","\n")
	if not t.u_phone then  ngx.say([[{"error":"login need phone or name"}]]) return end
	if not t.u_pass then ngx.say([[{"error":"login need phone"}]]) return end
	local list={}
	local cnt=0
	list = all_user:newsql():columns({"u_name","u_phone","u_ek","u_pass","u_login_timestamp"}):where_and({{"u_phone","=",t.u_phone}}):all() -- 可以多个where
	if ngx.time()-(list[1].u_login_timestamp or 0) <3 then  ngx.say([[{"error":"login frequency too fast"}]]) return end
	if t.u_pass ~= list[1].u_pass then  ngx.say([[{"error":"wrong params"}]]) return end
	local data={}
	data.u_ek=string.gsub(table.concat(aucrek(ngx.time())),'"',"")
	data.u_login_timestamp=ngx.time()
	local affect_rows = all_user:newsql():where_and({{"u_phone","=",list[1].u_phone}}):update(data)
	list[1].u_pass=""
	list[1].u_ek=data.u_ek
	ngx.say(json.encode(list[1]))
	local writestatus={list[1].u_phone,list[1].u_ek}
	return loginstatus.write_status(writestatus)
	--print(loginstatus.read_status(writestatus))
end
 

return Home
