local skynet = require "skynet"
local log = require "log"
local proto = require "protocol"
local response = require "response"
local handle = require "logic.login"
local retcode = require "logic.retcode"

local CMD = {}

function CMD.dispatch(source, sess, msg)
    local resp = response(source, sess)
    local cmd, args = proto.unserialize(msg)
    if not cmd then
        log("protocol unserialization error, json msg: %s", msg)
	resp(retcode.PROTO_UNSERIALIZATION_FAILED)
	return
    end
    local f = handle[cmd]
    if not f then
        log("Unknown login service's command : [%d]", cmd)
	resp(retcode.UNKNOWN_CMD)
	return
    end
    f(args, resp)
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
