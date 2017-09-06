local retcode = require "logic.retcode"
local cmd = require "proto.cmd"

local function execute_f(req, resp_f)
    local servertime = os.time()
    resp_f(retcode.SUCCESS, {servertime = servertime})
end

return cmd.HEARTBEAT, execute_f
