local skynet = require "skynet"
local log = require "log"
local retcode = require "logic.retcode"

local CMD = {}

local account_info = {}
local player_info = {}

local id_counter = 1

function CMD.register(account, passwd)
    if account_info[account] ~= nil then
        return retcode.ACCOUNT_ALREADY_EXIST
    end
    account_info[account] = {
	passwd = passwd,
	player_info = {
	    id = id_counter,
	    name = "player" .. tostring(os.time()),
	},
    }
    player_info[id_counter] = account_info[account].player_info
    id_counter = id_counter + 1
    return retcode.SUCCESS, account_info[account].player_info
end

function CMD.query_account_info(account)
    if account_info[account] == nil then
        return retcode.ACCOUNT_NOT_EXIST
    end
    return retcode.SUCCESS, account_info[account]
end

function CMD.changename(id, name)
    if player_info[id] == nil then
        return retcode.PLAYER_ID_NOT_EXIT
    end
    player_info[id].name = name
    return retcode.SUCCESS
end

skynet.start( function ()
    skynet.dispatch("lua", function (session, source, cmd, ...)
        local func = CMD[cmd]
	if func then
	    if session == 0 then
	        func(...)
	    else
		skynet.ret(skynet.pack(func(...)))
	    end
	else
	    log("Unknown db Command : [%s]", cmd)
	    skynet.response()(false)
	end
    end)
end)
