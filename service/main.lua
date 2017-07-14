local skynet = require "skynet"

skynet.start(function()
	skynet.error("FYServer start")
	--skynet.uniqueservice("protoloader")
	if not skynet.getenv "daemon" then
		skynet.newservice("console")
	end
	skynet.newservice("debug_console",8000)
	--skynet.newservice("simpledb")
	skynet.uniqueservice("login")
	local gate = skynet.newservice("gate")
	skynet.call(gate, "lua", "start", {})
	skynet.exit()
end)
