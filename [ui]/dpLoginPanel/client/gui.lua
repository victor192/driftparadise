isAuthInProgress = false
local UI = exports.dpUI
local HIDE_CHAT = false
local screenWidth, screenHeight = exports.dpUI:getScreenSize()

local realSceenWidth, realScreenHeight = guiGetScreenSize()
local backgroundScale = realScreenHeight / 720
local backgroundWidth, backgroundHeight = 1280 * backgroundScale, 720 * backgroundScale
local backgroundTexturesFiles = {"1.jpg", "2.jpg", "3.jpg"}
local backgroundTextures = {}
local backgroundTextureIndex = 1
local backgroundTransitionAnim = {start = false, progress = 0, lastTick = getTickCount()}
local backgroundTransitionPeriod = 9000
local animationProgress = 0
local ANIMATION_SPEED = 0.01
local loginPanel = {}
local registerPanel = {}

local USERNAME_REGEXP = "^[A-Za-z0-9_]$"
local KEY_REGEXP = "^[A-Za-z0-9_]$"

local languageButtonsList = {
	{ name = "en", language = "english" },
	{ name = "ru", language = "russian" },
	{ name = "ua", language = "ukrainian" },
	{ name = "pt", language = "portuguese" },
}

local function draw()
	animationProgress = math.min(1, animationProgress + ANIMATION_SPEED)
	dxDrawImage(0, 0, backgroundWidth, backgroundHeight, backgroundTextures[backgroundTextureIndex], 0, 0, 0, tocolor(255, 255, 255, 255 * animationProgress))
	local currentCount = getTickCount()
	if backgroundTransitionAnim.start then
		backgroundTransitionAnim.progress = math.min(1, backgroundTransitionAnim.progress + ANIMATION_SPEED)
		dxDrawImage(0, 0, backgroundWidth, backgroundHeight, backgroundTextures[backgroundTransitionAnim.textureIndex], 0, 0, 0, tocolor(255, 255, 255, 255 * backgroundTransitionAnim.progress))
		if backgroundTransitionAnim.progress == 1 then
			backgroundTextureIndex = backgroundTransitionAnim.textureIndex
			backgroundTransitionAnim.progress = 0
			backgroundTransitionAnim.start = false
		end
	end
	if (currentCount - backgroundTransitionAnim.lastTick) > backgroundTransitionPeriod and not backgroundTransitionAnim.start then
		backgroundTransitionAnim.textureIndex = math.max(1, (backgroundTextureIndex + 1) % (#backgroundTextures + 1))
		backgroundTransitionAnim.lastTick = currentCount
		backgroundTransitionAnim.start = true
	end
	dxDrawText("Drift Paradise 2.0", 3, screenHeight - 14, 3, screenHeight - 14, tocolor(255, 255, 255, 100 * animationProgress))
	if not root:getData("dbConnected") then
		dxDrawText("The server is currently not available.\nСервер на данный момент недоступен.",
			0,
			0,
			screenWidth,
			screenHeight * 0.5, tocolor(212, 0, 40, 220 * animationProgress), 2, "default", "center", "center"
		)

		local buttonSize = Vector2(200, 40)
		local buttonPos = Vector2(screenWidth - buttonSize.x, screenHeight - buttonSize.y) / 2
		local buttonAlpha = 200
		local buttonColor = tocolor(212, 0, 40, buttonAlpha)
		local mousePos = Vector2(getCursorPosition())
		mousePos.x = mousePos.x * screenWidth
		mousePos.y = mousePos.y * screenHeight
		if 	mousePos.x >= buttonPos.x and mousePos.x <= buttonPos.x + buttonSize.x and
			mousePos.y >= buttonPos.y and mousePos.y <= buttonPos.y + buttonSize.y
		then
			buttonAlpha = 255
			buttonColor = tocolor(222, 10, 50, buttonAlpha)

			if getKeyState("mouse1") then
				triggerServerEvent("dpCore.selfKick", root)
				setVisible(false)
			end
		end
		dxDrawRectangle(buttonPos, buttonSize, buttonColor)
		dxDrawText("Disconnect", buttonPos, buttonPos + buttonSize, tocolor(255, 255, 255, buttonAlpha), 1.7, "default", "center", "center")
	end
end

function gotoLoginPanel(username, password)
	UI:setVisible(loginPanel.panel, true)
	UI:setVisible(registerPanel.panel, false)
	if username and password then
		UI:setText(loginPanel.username, username)
		UI:setText(loginPanel.password, password)
	end
end

function clearRegisterForm()
	UI:setText(registerPanel.username, "")
	UI:setText(registerPanel.password, "")
	UI:setText(registerPanel.passwordConfirm, "")
end

function loadBackgroundTextures()
	for i, fileName in ipairs(backgroundTexturesFiles) do
		table.insert(backgroundTextures, DxTexture("assets/background/" .. fileName, "dxt5"))
	end
end

function unloadBackgroundTextures()
	for texture in pairs(backgroundTextures) do
		if isElement(texture) then
			destroyElement(texture)
		end
	end
end

function setVisible(visible)
	visible = not not visible
	if HIDE_CHAT then
		exports.dpChat:setVisible(not visible)
	end
	exports.dpHUD:setVisible(false)

	UI:setVisible(loginPanel.panel, visible)
	UI:setVisible(registerPanel.panel, false)

	if visible then
		if not root:getData("dbConnected") then
			UI:setVisible(loginPanel.panel, false)
			exports.dpUI:showMessageBox(
				exports.dpLang:getString("login_panel_server_error"),
				exports.dpLang:getString("login_panel_server_not_available")
			)
		end

		addEventHandler("onClientRender", root, draw)
		animationProgress = 0
		local fields = Autologin.load()
		if fields then
			UI:setText(loginPanel.username, fields.username)
			UI:setText(loginPanel.password, fields.password)
		end
		loadBackgroundTextures()
	else
		unloadBackgroundTextures()
		removeEventHandler("onClientRender", root, draw)
	end
	showCursor(visible)
end

local function createLoginPanel()
	local logoTexture = exports.dpAssets:createTexture("logo.png", "dxt5")
	local textureWidth, textureHeight = dxGetMaterialSize(logoTexture)
	local logoWidth = 415
	local logoHeight = textureHeight * 415 / textureWidth

	local panelWidth = 550
	local panelHeight = 260
	local panel = UI:createDpPanel({
		x = (screenWidth - panelWidth) / 2,
		y = (screenHeight - panelHeight + logoHeight) / 2,
		width = panelWidth, height = panelHeight,
		type = "dark"
	})
	UI:addChild(panel)

	local logoImage = UI:createImage({
		x = (panelWidth - logoWidth) / 2,
		y = -logoHeight - 25,
		width = logoWidth,
		height = logoHeight,
		texture = logoTexture
	})
	UI:addChild(panel, logoImage)

	local startGameButton = UI:createDpButton({
		x = 0, y = 0,
		width = panelWidth / 2,
		height = 55,
		type = "default_dark",
		locale = "login_panel_start_game_button"
	})
	UI:addChild(panel, startGameButton)

	local registerButton = UI:createDpButton({
		x = panelWidth / 2, y = 0,
		width = panelWidth / 2,
		height = 55,
		type = "primary",
		locale = "login_panel_register_button_toggle"
	})
	UI:addChild(panel, registerButton)

	local usernameInput = UI:createDpInput({
		x = 50,
		y = 90,
		width = 450,
		height = 50,
		type = "dark",
		locale = "login_panel_username_label"
	})
	UI:addChild(panel, usernameInput)

	local passwordInput = UI:createDpInput({
		x = 50,
		y = 160,
		width = 450,
		height = 50,
		type = "dark",
		placeholder = "Пароль",
		masked = true,
		locale = "login_panel_password_label"
	})
	UI:addChild(panel, passwordInput)

	UI:setVisible(panel, false)
	loginPanel.registerButton = registerButton
	loginPanel.startGameButton = startGameButton
	loginPanel.password = passwordInput
	loginPanel.username = usernameInput
	loginPanel.panel = panel
end

local function createRegisterPanel()
	local panelWidth = 550
	local panelHeight = 385

	local logoTexture = exports.dpAssets:createTexture("logo.png")
	local textureWidth, textureHeight = dxGetMaterialSize(logoTexture)
	local logoScale = 1
	local logoWidth = 415 * logoScale
	local logoHeight = textureHeight * 415 / textureWidth * logoScale

	local totalPanelHeight = panelHeight - logoHeight + 25

	local panel = UI:createDpPanel({
		x = (screenWidth - panelWidth) / 2,
		y = screenHeight / 2 - totalPanelHeight / 2,
		width = panelWidth, height = panelHeight,
		type = "dark"
	})
	UI:addChild(panel)

	local logoImage = UI:createImage({
		x = (panelWidth - logoWidth) / 2,
		y = -logoHeight - 25,
		width = logoWidth,
		height = logoHeight,
		texture = logoTexture
	})
	UI:addChild(panel, logoImage)

	local languageLabelWidth = 118
	local languageLabel = UI:createDpLabel({
		x = 50,
		y = 40,
		width = languageLabelWidth,
		wordBreak = false,
		clip = true,
		height = 50,
		alignX = "left",
		alignY = "top",
		locale = "login_panel_language"
	})
	UI:addChild(panel, languageLabel)

	-- Кнопки языков
	local langX = 50 + languageLabelWidth + 7
	for i, languageButton in ipairs(languageButtonsList) do
		local button = UI:createDpImageButton({
			x = langX, y = 40,
			width = 27, height = 27,
			texture = exports.dpAssets:createTexture("buttons/" .. tostring(languageButton.name) .. ".png")
		})
		UI:addChild(panel, button)
		languageButton.button = button
		langX = langX + 27 + 5
	end

	local circleTexture = exports.dpAssets:createTexture("buttons/circle.png", "argb", false, "clamp")
	local colorPurple = UI:createDpImageButton({
		x = panelWidth - 50 - 27,
		y = 40,
		width = 27, height = 27,
		color = tocolor(150, 0, 255),
		texture = circleTexture
	})
	UI:addChild(panel, colorPurple)

	local colorBlue = UI:createDpImageButton({
		x = panelWidth - 50 - 27 - 7 - 27,
		y = 40,
		width = 27, height = 27,
		color = tocolor(16, 160, 207),
		texture = circleTexture
	})
	UI:addChild(panel, colorBlue)

	local colorRed = UI:createDpImageButton({
		x = panelWidth - 50 - 27 - 7 - 27 - 7 - 27,
		y = 40,
		width = 27, height = 27,
		color = tocolor(212, 0, 40),
		texture = circleTexture
	})
	UI:addChild(panel, colorRed)

	local colorLabelWidth = 50
	local colorLabel = UI:createDpLabel({
		x = panelWidth - colorLabelWidth - 30 - (37 * 3) - 10,
		y = 40,
		width = colorLabelWidth,
		wordBreak = false,
		clip = true,
		height = 50,
		alignX = "right",
		alignY = "top",
		locale = "login_panel_color"
	})
	UI:addChild(panel, colorLabel)

	local y = 30
	-- local betaKeyInput = UI:createDpInput({
	-- 	x = 50,
	-- 	y = y,
	-- 	width = 450,
	-- 	height = 50,
	-- 	type = "dark",
	-- 	locale = "login_panel_beta_key_label"
	-- })
	-- UI:addChild(panel, betaKeyInput)

	y = y + 70
	local usernameInput = UI:createDpInput({
		x = 50,
		y = y,
		width = 450,
		height = 50,
		type = "dark",
		locale = "login_panel_username_label"
	})
	UI:addChild(panel, usernameInput)

	y = y + 70
	local passwordInput = UI:createDpInput({
		x = 50,
		y = y,
		width = 450,
		height = 50,
		type = "dark",
		masked = true,
		locale = "login_panel_password_label"
	})
	UI:addChild(panel, passwordInput)

	y = y + 70
	local passwordConfirmInput = UI:createDpInput({
		x = 50,
		y = y,
		width = 450,
		height = 50,
		type = "dark",
		masked = true,
		locale = "login_panel_password_confirm_label"
	})
	UI:addChild(panel, passwordConfirmInput)

	local backButton = UI:createDpButton({
		x = 0,
		y = panelHeight - 55,
		width = panelWidth / 2,
		height = 55,
		type = "default_dark",
		text = "Назад",
		locale = "login_panel_back"
	})
	UI:addChild(panel, backButton)

	local registerButton = UI:createDpButton({
		x = panelWidth / 2,
		y = panelHeight - 55,
		width = panelWidth / 2,
		height = 55,
		type = "primary",
		text = "Зарегистрироваться",
		locale = "login_panel_register_button"
	})
	UI:addChild(panel, registerButton)

	UI:setVisible(panel, false)
	registerPanel.panel = panel
	registerPanel.registerButton = registerButton
	registerPanel.backButton = backButton
	registerPanel.password = passwordInput
	registerPanel.passwordConfirm = passwordConfirmInput
	registerPanel.username = usernameInput
	registerPanel.betaKey = betaKeyInput

	registerPanel.colorButtons = {
		red = colorRed,
		purple = colorPurple,
		blue = colorBlue
	}
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	createLoginPanel()
	createRegisterPanel()

	if not localPlayer:getData("username") then
		fadeCamera(false, 0)
		setVisible(true)
		exports.dpLoadingScreen:hideGame()
	end
end)

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function(widget)
	-- Переключение языка
	for i, languageButton in ipairs(languageButtonsList) do
		if languageButton.button and languageButton.button == widget then
			exports.dpSounds:playSound("ui_change.wav")
			exports.dpLang:setLanguage(languageButton.language)
		end
	end
	-- Переключение панелей
	if widget == loginPanel.registerButton then
		UI:setVisible(loginPanel.panel, false)
		UI:setVisible(registerPanel.panel, true)
		exports.dpSounds:playSound("ui_select.wav")
	elseif widget == registerPanel.backButton then
		UI:setVisible(loginPanel.panel, true)
		UI:setVisible(registerPanel.panel, false)
		exports.dpSounds:playSound("ui_back.wav")
	-- Кнопка входа
	elseif widget == loginPanel.startGameButton and not isAuthInProgress then
		exports.dpSounds:playSound("ui_select.wav")
		isAuthInProgress = true
		startGameClick(UI:getText(loginPanel.username), UI:getText(loginPanel.password))
	-- Кнопка регистрации
	elseif widget == registerPanel.registerButton and not isAuthInProgress then
		exports.dpSounds:playSound("ui_select.wav")
		isAuthInProgress = true
		registerClick(
			UI:getText(registerPanel.username),
			UI:getText(registerPanel.password),
			UI:getText(registerPanel.passwordConfirm)
			--UI:getText(registerPanel.betaKey)
		)
	elseif widget == registerPanel.colorButtons.red then
		exports.dpSounds:playSound("ui_change.wav")
		exports.dpConfig:setProperty("ui.theme", "red")
	elseif widget == registerPanel.colorButtons.purple then
		exports.dpSounds:playSound("ui_change.wav")
		exports.dpConfig:setProperty("ui.theme", "purple")
	elseif widget == registerPanel.colorButtons.blue then
		exports.dpSounds:playSound("ui_change.wav")
		exports.dpConfig:setProperty("ui.theme", "blue")
	end
end)

addEvent("dpUI.inputEnter", false)
addEventHandler("dpUI.inputEnter", resourceRoot, function(widget)
	if widget == loginPanel.username or widget == loginPanel.password then
		startGameClick(UI:getText(loginPanel.username), UI:getText(loginPanel.password))
	elseif widget == registerPanel.username or widget == registerPanel.password then
		registerClick(UI:getText(registerPanel.username), UI:getText(registerPanel.password))
	end
end)
