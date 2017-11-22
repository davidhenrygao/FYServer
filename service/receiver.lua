local skynet = require "skynet"
local log = require "log"

local CMD = {}

function CMD.normal(msg)
	log("In receiver normal func: receive msg(%s).", msg)
	log("normal func end.")
end

function CMD.failed(msg)
	log("In receiver failed func: receive msg(%s).", msg)
	local test
	test.msg = msg
	log("failed func end.")
end

function CMD.error(msg)
	log("In receiver error func: receive msg(%s).", msg)
	assert(msg and type(msg) == "table", "arg is not table")
	log("error func end.")
end

skynet.start( function ()
    skynet.dispatch("lua", function (_, _, cmd, ...)
        local func = CMD[cmd]
	if func then
	    skynet.ret(skynet.pack(func(...)))
	else
	    log("Unknown receiver Command : [%s]", cmd)
	    skynet.response()(false)
	end
    end)
end)

