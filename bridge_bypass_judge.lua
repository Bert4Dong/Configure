require "fslog"
require "sqlclass"
require "ixcommon"

--bridge_bypass_judge.lua
local curFileTag="bridge_bypass_judge.lua::"

local sql = assert(sqlclass:new())

local b_conflag = sql:connect()
if not b_conflag then
   LogWarn(curFileTag .. "Connect to database: pbxdb3 failed.")
   return
end

local callerId = session:getVariable("caller_id_number")
local calleeId = session:getVariable("dialed_extension")

if callerId == nil then
   LogError(curFileTag .. "caller is nil")
   return 1
end

if calleeId == nil then
   LogError(curFileTag .. "callee is nil")
   return 1
end

LogInfo(curFileTag .. " callerId = " .. callerId .. " calleeId = " .. calleeId)

local caller_query = string.format("select user_agent from sip_registrations where sip_user = '%s'", callerId)

b_exeflag = sql:execute(caller_query)
if not b_exeflag then
   LogWarn("bridge_bypass_judge.lua:: execute sql:: " .. caller_query .. " failed.")
   sql:close()
   return 1
end

result = sql:fetch()
if result ==nil then
   LogWarn("bridge_bypass_judge.lua:: No found user_agent for " .. callerId)
   sql:close()
   return 1
end

local caller_user_agent = result.user_agent


local callee_query = string.format("select user_agent from sip_registrations where sip_user = '%s'", calleeId)

b_exeflag = sql:execute(callee_query)
if not b_exeflag then
   LogWarn("bridge_bypass_judge.lua:: execute sql:: " .. callee_query .. " failed.")
   sql:close()
   return 1
end

result = sql:fetch()
if result ==nil then
   LogWarn("bridge_bypass_judge.lua:: No found user_agent for " .. calleeId)
   sql:close()
   return 1
end

local callee_user_agent = result.user_agent

LogInfo(curFileTag .. "caller_user_agent = " .. caller_user_agent .. " callee_user_agent = " .. callee_user_agent)

local sub_string = "polycom"
local is_bypass_media = "false"

if (string.find(string.lower(caller_user_agent), sub_string) and string.find(string.lower(callee_user_agent), sub_string)) then
   is_bypass_media = "true"
end

LogInfo(curFileTag .. "is_bypass_media = " .. is_bypass_media)

session:execute("set", "bypass_media=" .. is_bypass_media)

session:execute("bridge","{ignore_early_media=true}${vs_leg_timeout}user/${dialed_extension1}@${domain_name}${vs_simultaneously}${vs_sequentially}")

