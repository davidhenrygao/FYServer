PLAT = linux
SKYNET_PATH = skynet
CSERVICE_PATH = cservice

# lua-cjson
LUA_CJSON_SRC_DIR = 3rd/lua-cjson
CSERVICE_PATH = cservice
LUA_CJSON := cjson.so

all: $(CSERVICE_PATH)/$(LUA_CJSON) $(SKYNET_PATH)/skynet

$(CSERVICE_PATH)/$(LUA_CJSON): $(LUA_CJSON_SRC_DIR)/Makefile
	cd $(LUA_CJSON_SRC_DIR) && $(MAKE)
	cp $(LUA_CJSON_SRC_DIR)/$(LUA_CJSON) $@

$(SKYNET_PATH)/skynet: $(SKYNET_PATH)/Makefile
	cd $(SKYNET_PATH) && $(MAKE)

.PHONY: all clean cleanall

clean:
	cd $(LUA_CJSON_SRC_DIR) && $(MAKE) clean
	cd $(SKYNET_PATH) && $(MAKE) clean

cleanall:
	cd $(LUA_CJSON_SRC_DIR) && $(MAKE) clean
	rm -rf $(CSERVICE_PATH)/*
	cd $(SKYNET_PATH) && $(MAKE) cleanall
