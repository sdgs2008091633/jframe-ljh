local json=require("cjson")
local _M={}

function _M.decode( str )
local function _json_decode(str)
  return json.decode(str)
end
    local ok, t = pcall(_json_decode, str)
    if not ok then
      return nil
    end

    return t
end

function _M.encode( tab )
	local function _json_encode(tab)
	  return json.encode(tab)
	end
    local ok, t = pcall(_json_encode, tab)
    if not ok then
      return nil
    end

    return t
end


return _M