local _M={}

function _M.AUTOCREK(inputseed)
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
local ektab={}
for i=1,16 do
seed=seed+1
ektab[i]='"'..string.char(rand(122,48,seed))..'"'

end
return ektab
end


return _M