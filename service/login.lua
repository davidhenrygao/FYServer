local skynet = require "skynet"
local log = require "log"
local proto = require "protocol"

local CMD = {}

function CMD.dispatch(source, msg)
    
end

skynet.start( function ()
    skynet.dispatch("lua", function (session, source, cmd, ...)
        local func = CMD[cmd]
	if func then
	    skynet.ret(skynet.pack(func(...)))
	else
	    log("Unknown connection Command : [%s]", cmd)
	    skynet.response()(false)
	end
    end)
end)
