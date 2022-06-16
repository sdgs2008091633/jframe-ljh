local iotservice = require "model.iotservice"
local login_status_model = iotservice.login_info
local _M={}
--过期时间1天
local refused_time=86400
function _M.write_status(t)
local data={}
data.login_timestamp=ngx.time()
data.login_key=t[1]
data.login_token=t[2]
local insertId = login_status_model:create(data)
return insertId
end


function _M.read_status(ek)
--if not t then ngx.say([[{"err":"need ek"}]])  return false end
local list=login_status_model:newsql():where_and({{'login_timestamp','>',(ngx.time()-86400)},{'login_timestamp','<',ngx.time()},{'login_token','=',ek}}):columns({'login_key','login_token','login_timestamp'}):orderby("login_timestamp"):all()
if not list[1] then return false end
if list[1].login_token ~= ek then return false end
if (ngx.time() - list[1].login_timestamp) > refused_time then print([[{"login out of time"}]]) return  false end
return list[1].login_key
end

return _M