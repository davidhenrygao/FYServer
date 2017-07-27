local skynet = require "skynet"
local socket = require "skynet.socket"
local log = require "log"

-- constant
local STATE = {
    INIT = 1,
    LOGIN = 2,
    DISCONNECT = 3,
}
local TIMEOUT = {
    INIT = 30,
    LOGIN = 30,
}

local CMD = {}
local data = {}

local function main_loop()
end

local function init_state_selfcheck()
    local interval = skynet.time() - data.time
    if interval > TIMEOUT.INIT then
	log("fd[%d] connection init timeout[%d].", data.fd, interval)
        skynet.call(data.gate, "lua", "close_conn", {
	    conn = skynet.self(),
	})
	socket.close(data.fd)
	skynet.exit()
    end
end

local function login_state_selfcheck()
    -- TODO
end

function CMD.start(conf)
    assert(conf and conf.fd and conf.dest, 
	"connection start function's arguments error")
    data.fd = conf.fd
    data.dest = conf.dest
    data.state = STATE.INIT
    data.time = skynet.time()

    socket.start(data.fd)
    skynet.fork(main_loop)
end

function CMD.selfcheck()
    if data.state == STATE.INIT then
        init_state_selfcheck()
    end
    if data.state == STATE.LOGIN then
        login_state_selfcheck()
    end
end

skynet.start( function ()
    skynet.dispatch("lua", function (session, _, cmd, ...)
        local func = CMD[cmd]
	if func then
	    skynet.ret(skynet.pack(func(...)))
	else
	    log("Unknown connection Command : [%s]", cmd)
	    skynet.response()(false)
	end
    end)
end)
