--content= "200100000001||瓦斯超限||20||贵黄7标-甲多隧道-左洞掌子面||2022-06-07 14:12",

local json=require("modules.json")

local _M={
}
 
function _M.send_sms(phone,content)
local content=table.concat(content,"||")
local sms_tab={

		apikey= "N555421727",
        secret= "5554257807ceb94f",
        content= tostring(content) ,
        mobile= tostring(phone) ,
        sign_id= 129939,
        template_id=123079

}
local smsjson=json.encode(sms_tab)
ngx.req.read_body()
                --local args, err = ngx.req.get_uri_args()
                local res = ngx.location.capture('/outapi',
                    {
					header=nil,
					   --lua_need_request_body="on",
                        method = ngx.HTTP_POST,
						body = smsjson,
						ctx = {
					    target_uri = "https://api.4321.sh/sms/template",
					}
                    }
                )
		
print("receive sms server info :",json.encode(res))
end 
 
return _M