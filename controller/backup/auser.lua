-- local Base = require("controller.base")

-- local Home = Base:extend()

-- local admin_user = require('model.admin_user')

-- function Home:index()
    -- self:json({
        -- data={
            -- name = iotservice.admin_user:columns('au_name'):get(1)
        -- }
    -- })
	 -- local args = ngx.req.get_uri_args()

-- end

local Base = require("controller.base")
local good = require "model.good"

local Home = Base:extend()

function Home:index()
	self:json({"hello"})
end

return Home