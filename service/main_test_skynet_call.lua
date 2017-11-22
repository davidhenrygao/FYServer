local skynet = require "skynet"
require "skynet.manager"

skynet.start(function()
	skynet.error("Skynet call test start")
	if not skynet.getenv "daemon" then
		skynet.newservice("console")
	end
	skynet.newservice("debug_console",8000)

	local caller = skynet.newservice("caller")
	local receiver = skynet.newservice("receiver")
	skynet.call(caller, "lua", "start", receiver)

	skynet.exit()
end)
