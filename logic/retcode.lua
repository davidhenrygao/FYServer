local retcode = {}

-- 0-999 are reserved for system use.
retcode.SUCCESS = 0
retcode.INTERNAL = 1
retcode.UNKNOWN_CMD = 2
retcode.PROTO_UNSERIALIZATION_FAILED = 3

-- 1000-9999 are used for login

-- 10000-19999 are used for agent

return retcode
