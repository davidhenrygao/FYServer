local skynet = "skynet"
local retcode = "logic.retcode"
local cmd = "proto.cmd"

local dbservice = skynet.queryservice("db")
local function execute_f(req, resp_f)
    local account = assert(req.args.account)
    local passwd = assert(req.args.passwd)
    local ret, playerinfo = skynet.call(
	dbservice, "lua", "register", account, passwd)
    if ret~= retcode.SUCCESS then
        local _, account_info = skynet.call(
	    dbservice, "lua", "query_account_info", account)
	if account_info.passwd ~= passwd then
	    resp_f(retcode.WRONG_PASSWORD)
	    return
	end
	playerinfo = account_info.player_info
    end
    local agent = skynet.newservice("agent")
    skynet.call(agent, "lua", "start", playerinfo)
    skynet.call(req.source, "lua", "change_dest", agent)
    resp_f(retcode.SUCCESS, playerinfo)
end

return cmd.LOGIN, execute_f
