-- Result event:
-- dpCore.registerResponse
function register(email, password, ...)
	if type(email) ~= "string" or type(password) ~= "string" then
		return false
	end	
	local success, errorType = checkEmail(email)
	if not success then
		return false, errorType
	end
	success, errorType = checkPassword(password)
	if not success then
		return false, errorType
	end	
	if AccountsConfig.HASH_PASSWORDS_CLIENTSIDE then
		password = sha256(password)
	end
	triggerServerEvent("dpCore.registerRequest", resourceRoot, email, password, ...)
	return true
end

-- Result event:
-- dpCore.passwordChangeResponse
function changePassword(password)
	if type(password) ~= "string" then
		return false, "bad_password"
	end
	success, errorType = checkPassword(password)
	if not success then
		return false, errorType
	end
	if AccountsConfig.HASH_PASSWORDS_CLIENTSIDE then
		password = sha256(password)
	end	
	triggerServerEvent("dpCore.passwordChangeRequest", resourceRoot, password)
	return true
end

-- Result event:
-- dpCore.loginResponse
function login(email, password)
	if type(email) ~= "string" or type(password) ~= "string" then
		return false
	end
	if AccountsConfig.HASH_PASSWORDS_CLIENTSIDE then
		password = sha256(password)
	end
	triggerServerEvent("dpCore.loginRequest", resourceRoot, email, password)
	return true
end

-- Result event:
-- dpCore.loginResponse
function logout()
	triggerServerEvent("dpCore.logoutRequest", resourceRoot)
	return true
end