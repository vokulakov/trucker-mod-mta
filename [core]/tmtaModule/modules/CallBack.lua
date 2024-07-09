function executeCallback(callback, ...)
	if type(callback) ~= "function" then
		return false
	end
	local success, err = pcall(callback, ...)
	if not success then
		outputDebugString("Error in callback: " .. tostring(err))
		return false
	end
	return true
end

addEvent("dbCallback", false)
addEventHandler("dbCallback", resourceRoot, 
	function(queryResult, callbackFunctionName, callbackArguments)
		if _G[callbackFunctionName] then
			return executeCallback(_G[callbackFunctionName], queryResult, callbackArguments)
		end
		triggerEvent(callbackFunctionName, sourceResourceRoot, queryResult, callbackArguments)
	end
)

addEvent("executeCallback", false)
addEventHandler("executeCallback", resourceRoot, 
	function(callbackFunctionName)
		return executeCallback(_G[callbackFunctionName])
	end
)