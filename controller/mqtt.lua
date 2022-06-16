local Base = require("controller.base")
local Home = Base:extend()
local CMD = require("modules.register-device")
local json=require("modules.json")


function Home:index()
local function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end
local data = ngx.req.get_body_data() or ""
	-- print("\n","receved data:","------------------------------------------------------------------------------------------------------------------------------")
	-- print("data:",data)
	-- print("\n","-----------------------------------------------------------------------------")
	if not (string.find(data,"{pt=1") or string.find(data,[[\"pt\":\"js\"]])) then   return nil end
	local t_tab=json.decode(data)
	if not  t_tab.payload  then return end
	local payload=t_tab.payload
	local topic=t_tab.topic or ""
	local d_tab={}
	if string.find(payload,"}{") then 
		payload=string.gsub(payload,"}{","}split_str_220606{") 
		d_tab=split(payload,"split_str_220606")
		else
		d_tab={payload}
	end
	
	-- print("payload:",payload)
	  
	-- print("d_tab:",json.encode(d_tab))
	if not d_tab[1] then return ngx.log(ngx.ERR,"wrong string: ",data,"                  ") end
	local e_tab={}
	
	for k,v in pairs(d_tab) do
	
	
		if string.find(v,"{pt=1") then 
		print("table find")
		 e_tab={}
			if pcall(function () e_tab=loadstring("return "..v)() end)
				then e_tab.topic=topic
				else e_tab={} ; print("wrong table string")
			end
			local tmp=CMD[e_tab.cmd]
			print("\n","table_cmd:",e_tab.cmd,",did","------------------------------------------------------------------------------------------------------------------------------")
			if tmp then tmp(e_tab) end
			 
			print("\n","-----------------------------------------------------------------------------")
		end 
		
		if string.find(v,[["pt":"js"]]) then
		print("v:",tostring(v))
		 e_tab={}
 			if pcall(function () e_tab=json.decode(v) end)
					then e_tab.topic=topic
					else e_tab={} ; print("wrong json string")
				end
			local tmp=CMD[e_tab.cmd]
			print("\n","json_cmd:",e_tab.cmd,",did","------------------------------------------------------------------------------------------------------------------------------")
			if tmp then tmp(e_tab) end
		 
			print("\n","-----------------------------------------------------------------------------")
		end
	end
end

return Home



