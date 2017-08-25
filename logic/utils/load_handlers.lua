local skynet = require "skynet"
local log = require "log"
local lfs = require "lfs"
local path_mgr = require "logic.utils.path_mgr"

local slash = "/"
local point = "."
local logic = "logic"
local root = skynet.getenv("root") .. logic .. slash

local handlers = 1

local function load_handlers(paths)
    local path
    local file
    local cmd
    local handler
    local handlers = nil
    for _,p in ipairs(paths) do
        path = root .. p
	local attrs, err = lfs.attributes(path)
	repeat
	    if not attrs then
		log("In path[%s], lfs attributes function error: %s.", 
		    path, err)
		break
	    end
	    if attrs.mode == "file" and path_mgr.suffix(p) == "lua" then
	        file = logic .. point .. path_mgr.prefix(p)
		cmd, handler = require(file)
		handlers[cmd] = handler
	    end
	    if attrs.mode == "directory" then
		for f in lfs.dir(path) do
		    local new_path = path .. "/" .. f
		    attrs, err = lfs.attributes(new_path)
		    repeat
			if not attrs then
			    log("In path[%s], lfs attributes function error: %s.", 
				new_path, err)
			    break
			end
			if attrs.mode == "file" and path_mgr.suffix(f) == "lua" then
			    file = logic .. point .. p .. point .. path_mgr.prefix(f)
			    local cmd, handler = require(loadfile)
			    handlers[cmd] = handler
			end
		    until true
		end
	    end
	until true
    end

    return handlers
end

return load_handlers
