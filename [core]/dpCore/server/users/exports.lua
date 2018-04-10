function isPlayerLoggedIn(...)
	return Users.isPlayerLoggedIn(...)
end

function userExists(email)
	local users = Users.getByEmail(email, {"email"})
	return type(users) == "table" and #users > 0
end

function getUserAccount(email)
	local users = Users.getByEmail(email, {})
	if type(users) ~= "table" or #users == 0 then
		return false
	end
	return users[1]
end

function updateUserAccount(email, fields)
	return Users.update(email, fields)
end

function getUserPlayer(email)
	return Users.getPlayerByEmail(email)
end

function givePlayerMoney(player, money)
	if not isElement(player) then
		return false
	end
	if type(money) ~= "number" then
		return false
	end
	money = math.floor(money)
	local currentMoney = player:getData("money")
	if type(currentMoney) ~= "number" then
		return false
	end
	player:setData("money", math.max(0, currentMoney + money))
	return true
end

function givePlayerXP(player, xp)
	if not isElement(player) then
		return false
	end
	if type(xp) ~= "number" then
		return false
	end
	xp = math.floor(xp)
	local currentXP = player:getData("xp")
	if type(currentXP) ~= "number" then
		return false
	end
	player:setData("xp", math.max(0, currentXP + xp))
	return true
end

function banPlayer(...)
	return Bans.banPlayer(...)
end

function mutePlayer(...)
	return Bans.mutePlayer(...)
end

function unmutePlayer(...)
	return Bans.unmutePlayer(...)
end

function isPlayerMuted(...)
	return Bans.isPlayerMuted(...)
end

function isSerialBanned(...)
	return Bans.isSerialBanned(...)
end

function isUserBanned(...)
	return Bans.isUserBanned(...)
end