local skynet = require "skynet"

skynet.start(function()
	skynet.error("FYServer start")
	--skynet.uniqueservice("protoloader")
	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end
	skynet.newservice("debug_console",8000)
	--skynet.newservice("simpledb")
	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = 8888,
		maxclient = 2048,
		nodelay = true,
	})
	skynet.error("Watchdog listen on", 8888)
	skynet.exit()
end)
