local skynet = require "skynet"
local socket = require "skynet.socket"
local log = require "log"

local CMD = {}
local data = {}
local dest

function CMD.start(conf)
    assert(conf and conf.fd)
    dest = skynet.queryservice("login")
    data.fd = conf.fd
end

skynet.start( function ()
    skynet.dispatch("lua", function (_, _, cmd, ...)
        local func = CMD[cmd]
	if func then
	    skynet.ret(skynet.pack(func(...)))
	else
	    log("Unknown connection Command : [%s]", cmd)
	    skynet.response()(false)
	end
    end)
end)
