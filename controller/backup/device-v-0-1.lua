--i_code 默认与model重名***********************************
local i_code="device"
local Base = require("controller.base")
local iotservice = require "model.iotservice"
local l_model=iotservice[i_code]
local Home = Base:extend()
local json=require("cjson")
local method= ngx.req.get_method() or "GET"
--请求方法列表
local req_funclist={}
--密钥
local ek=""
--访问权限码
local token=""
--限制查询条数
local return_limit=10000
--创建条件---------------------------------
local post_list={dt_name="",dt_code="",dt_val_max="",dt_val_table=""}
--查询条件----------------------------------限制不超过10000条
local get_list={id="",dt_code="",dt_name="",dt_val_max="",dt_val_table=""}
-------------------------------------------
function Home:index()
    local data=ngx.req.get_body_data()
	print("\n","req.body:",data,"\n")
	local data_table=json_decode(data) or {}
	local jump= req_funclist[method]
	if jump then jump(data_table) end
	ngx.say(ngx.today())
end

function req_funclist.GET(t)
print("\r","------------get did------------------------------------------------------------------------------------------------","\n")

local list={}
local cnt=0
if t.count then cnt=l_model:where_and(t.where or {{"id","=",""}}):count() return ngx.say('{'..(cnt or 0)..'}') end
if (not t.where) then list = l_model:columns(t.columns or 'id'):orderby((t.orderby or 'id'),(t.sort or "desc")):all(t.limit or 0)   end
if t.where then list = l_model:columns(t.columns or 'id'):where_and(t.where or {{"id","=",""}}):orderby((t.orderby or 'id'),(t.sort or "desc")):all(t.limit or 0) end -- 可以多个where
ngx.say(json_encode(list))
print("\r","--------------------------------------------------------------------------------------------------------------------","\n")

end

function req_funclist.POST(t)
print("\r","------------post did------------------------------------------------------------------------------------------------","\n")
local insertId = l_model:create(t)
self:json({insertId,'insert success'})
print("\r","--------------------------------------------------------------------------------------------------------------------","\n")
end

function req_funclist.DELETE(t)
print("\r","------------delete did------------------------------------------------------------------------------------------------","\n")
 
local affectrows = l_model:where((t[1] or "id"),(t[2] or "="),t[3]):delete()

print("\r","--------------------------------------------------------------------------------------------------------------------","\n")


end

function req_funclist.PUT(t)
print("\r","------------put did------------------------------------------------------------------------------------------------","\n")

local affect_rows = l_model:sl(t or {})
print("\r","--------------------------------------------------------------------------------------------------------------------","\n")

end

function Home:CrEk()
ngx.say("cr_ek")
end

function Home:CrToken()
ngx.say("crtoken")
end

--根据seed生成16位长度的一个随机密钥
function AUTOCREK(inputseed)
	local function rand(M,m,seed)
	--不能更改
	local A = 99821323291;
	--公钥
	local B = 43123423543;
	--不能更改
	local N = 99796078051;
	local seed=tonumber(seed) or 65535
	local m=tonumber(m) or 1
	local M=tonumber(M) or m
	local R=math.floor((((A*seed+B)%N))%M)+1
	if R<m then R=m+R end 
	if R>M then R=M end
	--math.floor(r*b + s)
	return R
	end

	--生成随机密钥
	local seed=tonumber(inputseed) or 65535
	local ekstr=""
	for i=1,16 do
	seed=seed+1
	ekstr=ekstr..string.char(rand(122,48,seed))
	end
	return ekstr
end

function json_decode( str )
	local function _json_decode(str)
	  return json.decode(str)
	end
    local ok, t = pcall(_json_decode, str)
    if not ok then
      return nil
    end

    return t
end

function json_encode( tab )
	local function _json_encode(tab)
	  return json.encode(tab)
	end
    local ok, t = pcall(_json_encode, tab)
    if not ok then
      return nil
    end

    return t
end


return Home