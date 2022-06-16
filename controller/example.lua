--数据库操作----------------------------------------------------------------
--------------------------------------------------------------------------------
--添加 
local data = {
    name = "test",
    pwd = 123
}
local insertId = userModel:create(data)
--------------------------------------------------------------------------------
-- 删除

-- 根据主键删除

local affect_rows = userModel:delete(2)
-- 根据where条件删除

local affect_rows = userModel:where("name","=",3):delete()
--------------------------------------------------------------------------------
-- 修改

-- 根据主键修改

local affect_rows = userModel:update(data,2)

local data = {
    suid = "1", -- data里面存在主键，根据主键更新
    name = "hello 我的测试",
}
local affect_rows = userModel:update(data)
-- 根据where条件修改

local affect_rows = userModel:where("name","=",3):update(data)
--------------------------------------------------------------------------------
-- 查找

-- 查找一条记录

local info = userModel:where("name","=",3):get() --根据where条件查找
local info = userModel:get(1) --根据主键查找
local info = userModel:columns('suid,name'):get(1) --查找指定字段,查找字段是字符串
local info = userModel:columns({'suid','name'}):get(1) --查找指定字段,查找字段是table
-- 查找多条记录

local list = userModel:where("name","=",3):all() --根据where条件查找
local list = userModel:columns('suid,name'):all() --查找指定字段,查找字段是字符串
local list = userModel:columns({'suid','name'}):all() --查找指定字段,查找字段是table
--------------------------------------------------------------------------------
-- 其它方法说明

-- 查找数据条数

local count = userModel:where("name","=","json"):count()
-- 排序

local list = userModel:where("name","=",3):orderby("id"):all()

local list = userModel:where("name","=",3):orderby("name","asc"):orderby("id","desc"):all() --多个排序
-- 查找指定字段(不使用指定字段，则是查找所有字段)

local list = userModel:columns('suid,name'):all() --columns里面可以是字符串，也可以是table结构
-- 根据where条件查找

local list = userModel:columns('suid,rname'):where("suid","<","30"):orderby("suid"):all()

local list = userModel:columns('suid,rname'):where("suid","<","30"):where("rname","like","test%"):orderby("suid"):all() -- 可以多个where
--------------------------------------------------------------------------------
-- 自定义执行的sql

-- 关联查询
local sql = "select su.*,c.logincount from sls_p_user su join c_user c on su.suid=c.suid where su.suid=2"
local result = userModel:query(sql)

-- 动态参数查询
local sql = "select * from sls_p_user where suid=? and username=?"
local result = userModel:query(sql,{1,"json"})
--------------------------------------------------------------------------------
--其他操作
--跳转url------------------------------------------------
function Home:test() 
	self.response:redirect("http://www.baidu.com")
end
--数据封装到json response
function Home:responsejson()
 self:json({data=self.redis:lrange('list',0,-1)},"获取成功")
end



-- Base.lua封装的基类提供了单表增删改查的方法

-- create(data)添加记录
-- delete(id)删除记录
-- update(data,id)修改记录
-- get()、all()过滤记录
-- where()过滤条件方法
-- columns()设置查找哪些列的方法
-- orderby()设置排序的方法
-- count()查找数据总条数的方法
-- 同时Base.lua也提供了一个方法用于自定义执行sql的方法，方便复杂查询

-- query()

--String sql="select age from user where name=′"+xxx+"′"

local Base = require("controller.base")
local good = require "model.good"
local test =require("mqtt")
local Home = Base:extend()

function Home:index()
     
	self:json({"hello"})
	ngx.log(ngx.ERR,"test")
	self:json({ngx.req.getbody()})
	ngx.log(ngx.ERR,ngx.req.getbody())
end

function Home:test() 
	self.response:redirect("http://www.baidu.com")
end

function Home:cacheGet()
	self.redis:set("hello","this 是我们")
	self:json({data=self.redis:get('hello')})
end

function Home:cacheMget()
	self.redis:mset("hello11","this 是我们","dd","哈哈哈")
	self:json({data=self.redis:mget('hello11')})
end

function Home:cacheHget()
	self.redis:hmset("H","A","AAAAA","B","BBBBB")
	self:json({data=self.redis:hgetall('H')})
end

function Home:cachelist()
	self.redis:lpush("list","A","AAAAA","B","BBBBB")
	self:json({data=self.redis:lrange('list',0,-1)},"获取成功")
end

function Home:show() 
    self:json({data={controller=self.controller,action=self.action,get=self.request.query}})
end

function Home:list()
    self.redis:set("test","测试")
    self:json({data=self.redis:get("test")})
end

function Home:err()
	self:error(2,"获取数据失败")
end


function Home:get_good()
    self:json(good:get(11666))
end

function Home:get1()
    self:json(good:where('sno','=','020300366'):get())
end

function Home:getx()
    self:json(good:where('sno','=','020300366'):columns('lgid,name,std,sno'):get())
end

function Home:getxx()
    self:json(good:where('lgid','=','1'):columns({'lgid','name'}):get())
end

function Home:all()
    self:json(good:where('sno','=','020300366'):all())
end

function Home:allx()
    self:json(good:where('sno','=','020300366'):columns('lgid,name,std,sno'):all())
end

function Home:allxx()
    self:json(good:where('sno','=','020300366'):columns({'lgid','name'}):all())
end

function Home:count()
    self:json(good:where('sno','!=','020300366'):count())
end

function Home:orderby()
    self:json(good:orderby('name','asc'):orderby('lgid'):all())
end

function Home:update()
	local data = {
		name = "hello 2222",
	}
	local ret = good:where("lgid","=","7"):update(data)
	self:json(ret)
end

function Home:update1()
	local data = {
		name = "hello 测试",
	}
	local ret = good:update(data,2)
	self:json(ret)
end

function Home:update2()
	local data = {
		lgid = "1",
		name = "hello 我的测试",
	}
	local ret = good:update(data)
	self:json(ret)
end

function Home:create()
	local data = {
		name = "hello world",
		
	}
	local ret = good:create(data)
	self:json(ret)
end

function Home:del()
	local ret = good:delete(2)
	self:json(ret)
end

function Home:del1()
	local ret = good:where("name","=","hello world"):delete()
	self:json(ret)
end

function Home:del1()
	local ret = good:query("update lgt_good set name = 'hello' where lgid=? and name=?",{1,'hello'})
	self:json(ret)
end
return Home
