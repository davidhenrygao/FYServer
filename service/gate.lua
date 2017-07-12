local skynet = require "skynet"
local socket = require "skynet.socket"
local log = require "log"

local CMD = {}
local data = {}

local function accept_cb(fd, ip)
    log("gate accept connection[%d] from ip[%s]", fd, ip)
end

function CMD.start(conf)
    assert(conf and type(conf) == "table")
    assert(data.fd == nil, "gate already start")
    local ip = skynet.getenv("ip") or conf.ip or "127.0.0.1"
    local port = skynet.getenv("port") or conf.port or 10000
    data.fd = socket.listen(ip, port)
    data.ip = ip
    data.port = port
    socket.start(data.fd, accept_cb)
    log("gate start: listen ip[%s]:port[%d]", ip, port)
end

skynet.start( function ()
    skynet.dispatch("lua", function (_, _, cmd, ...)
        local func = CMD[cmd]
	if func then
	    skynet.ret(skynet.pack(func(...)))
	else
	    log("Unknown gate Command : [%s]", cmd)
	    skynet.response()(false)
	end
    end)
end)
