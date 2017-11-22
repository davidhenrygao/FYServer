local skynet = require "skynet"
local log = require "log"

local CMD = {}

local function normal_call(receiver)
	log("normal call begin.")
	local ret = skynet.call(receiver, "lua", "normal", "fuck you!")
	log("normal call return: %s", ret)
end

local function failed_call(receiver)
	log("failed call begin.")
	local ret = skynet.call(receiver, "lua", "failed", "fuck you, failed!")
	log("failed call return: %s", ret)
end

local function error_call(receiver)
	log("error call begin.")
	local ret = skynet.call(receiver, "lua", "error", "fuck you error!")
	log("error call return: %s", ret)
end

local function state_co()
	log("state_co func begin.")
	log("state_co sleep 10s.")
	skynet.sleep(1000)
	local hang_co_info = {}
	local ret = skynet.task(hang_co_info)
	log("skynet.task ret: %d.", ret)
	for s,traceback in pairs(hang_co_info) do
		log("co session(%d) traceback: %s", s, traceback)
	end
	log("state_co func end.")
end

function CMD.start(receiver)
	log("caller start...")
	skynet.fork(normal_call, receiver)
	skynet.fork(failed_call, receiver)
	skynet.fork(error_call, receiver)
	skynet.fork(state_co)
	log("caller end...")
end

skynet.start( function ()
    skynet.dispatch("lua", function (_, _, cmd, ...)
        local func = CMD[cmd]
	if func then
	    skynet.ret(skynet.pack(func(...)))
	else
	    log("Unknown caller Command : [%s]", cmd)
	    skynet.response()(false)
	end
    end)
end)
