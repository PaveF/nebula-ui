-- Nebula UI Library v2.0.0
-- Drawing-based menu framework for Matcha.
-- loadstring(readfile("nebula_ui.lua"))()  ->  global 'Nebula'

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Nebula = {}
Nebula.Version = "2.0.0"
Nebula.Loaded = false
Nebula.Unloaded = false
Nebula.Options = {}
Nebula.Themes = {}

local win = nil
local conn = nil
local unloadCallbacks = {}
local minimizedCallbacks = {}
local maximizedCallbacks = {}
local themeChangedCallbacks = {}

local themeName = "Aurora"
local translucent = false
local loaded = false
local unloaded = false
local currentDialog = nil

local FOLDER = "Nebula"
local autoloadName = nil
local ignoreIndexes = nil

local Themes = {}

local function C3(r, g, b) return Color3.fromRGB(r, g, b) end

-- ============================================================
-- Themes
-- ============================================================

Themes.Aurora = {
	name = "Aurora",
	accent = C3(140, 110, 255),
	accent2 = C3(255, 90, 200),
	accent3 = C3(70, 210, 255),
	text = C3(250, 250, 255),
	textDim = C3(168, 168, 200),
	textFaint = C3(118, 118, 148),
	bg = C3(12, 11, 19),
	bgAlt = C3(16, 15, 25),
	title = C3(18, 16, 28),
	content = C3(12, 11, 19),
	contentAlt = C3(16, 15, 25),
	tab = C3(15, 14, 24),
	tabHover = C3(24, 22, 38),
	tabActive = C3(28, 24, 48),
	tabActiveAccent = C3(140, 110, 255),
	element = C3(21, 19, 33),
	elementHover = C3(29, 27, 45),
	elementPress = C3(16, 14, 26),
	field = C3(17, 15, 27),
	fieldHover = C3(24, 22, 38),
	border = C3(40, 37, 58),
	borderSoft = C3(33, 30, 48),
	toggleOff = C3(55, 52, 76),
	toggleOn = C3(140, 110, 255),
	sliderTrack = C3(38, 35, 56),
	sliderFill = C3(140, 110, 255),
	sliderGlow = C3(140, 110, 255),
	scroll = C3(60, 57, 82),
	scrollHover = C3(84, 80, 112),
	success = C3(95, 225, 150),
	warning = C3(250, 195, 85),
	danger = C3(250, 100, 110),
	dialogOverlay = C3(5, 4, 9),
	accentBar = C3(140, 110, 255),
	titleBarText = C3(255, 255, 255),
	titleBarSub = C3(150, 148, 175),
	shadow = C3(0, 0, 0),
	activeRing = C3(170, 145, 255),
	checkmark = C3(255, 255, 255),
	swatchBorder = C3(255, 255, 255),
}

Themes.Midnight = {
	name = "Midnight",
	accent = C3(90, 200, 255),
	accent2 = C3(100, 130, 255),
	accent3 = C3(80, 230, 255),
	text = C3(245, 250, 255),
	textDim = C3(158, 172, 192),
	textFaint = C3(90, 106, 126),
	bg = C3(7, 11, 20),
	bgAlt = C3(10, 16, 28),
	title = C3(11, 17, 29),
	content = C3(7, 11, 20),
	contentAlt = C3(10, 16, 28),
	tab = C3(9, 15, 26),
	tabHover = C3(15, 23, 38),
	tabActive = C3(14, 38, 60),
	tabActiveAccent = C3(90, 200, 255),
	element = C3(14, 22, 36),
	elementHover = C3(20, 31, 48),
	elementPress = C3(11, 17, 28),
	field = C3(10, 16, 27),
	fieldHover = C3(16, 24, 38),
	border = C3(29, 44, 62),
	borderSoft = C3(22, 35, 50),
	toggleOff = C3(42, 58, 78),
	toggleOn = C3(90, 200, 255),
	sliderTrack = C3(29, 44, 62),
	sliderFill = C3(90, 200, 255),
	sliderGlow = C3(90, 200, 255),
	scroll = C3(46, 66, 88),
	scrollHover = C3(68, 94, 122),
	success = C3(90, 215, 160),
	warning = C3(252, 190, 80),
	danger = C3(240, 105, 118),
	dialogOverlay = C3(4, 6, 10),
	accentBar = C3(90, 200, 255),
	titleBarText = C3(255, 255, 255),
	titleBarSub = C3(135, 152, 172),
	shadow = C3(0, 0, 0),
	activeRing = C3(120, 215, 255),
	checkmark = C3(255, 255, 255),
	swatchBorder = C3(255, 255, 255),
}

Themes.Storm = {
	name = "Storm",
	accent = C3(0, 240, 170),
	accent2 = C3(0, 190, 255),
	accent3 = C3(120, 255, 200),
	text = C3(246, 252, 250),
	textDim = C3(148, 172, 164),
	textFaint = C3(85, 108, 100),
	bg = C3(7, 15, 13),
	bgAlt = C3(10, 20, 18),
	title = C3(11, 21, 18),
	content = C3(7, 15, 13),
	contentAlt = C3(10, 20, 18),
	tab = C3(9, 18, 16),
	tabHover = C3(17, 29, 25),
	tabActive = C3(12, 58, 46),
	tabActiveAccent = C3(0, 240, 170),
	element = C3(16, 27, 24),
	elementHover = C3(23, 36, 32),
	elementPress = C3(12, 20, 18),
	field = C3(11, 19, 17),
	fieldHover = C3(18, 29, 26),
	border = C3(34, 50, 44),
	borderSoft = C3(27, 40, 36),
	toggleOff = C3(46, 64, 58),
	toggleOn = C3(0, 240, 170),
	sliderTrack = C3(32, 48, 42),
	sliderFill = C3(0, 240, 170),
	sliderGlow = C3(0, 240, 170),
	scroll = C3(50, 70, 62),
	scrollHover = C3(72, 100, 88),
	success = C3(90, 225, 155),
	warning = C3(250, 215, 85),
	danger = C3(245, 110, 118),
	dialogOverlay = C3(4, 8, 6),
	accentBar = C3(0, 240, 170),
	titleBarText = C3(255, 255, 255),
	titleBarSub = C3(125, 150, 142),
	shadow = C3(0, 0, 0),
	activeRing = C3(60, 255, 195),
	checkmark = C3(10, 25, 20),
	swatchBorder = C3(255, 255, 255),
}

Themes.Ember = {
	name = "Ember",
	accent = C3(255, 140, 70),
	accent2 = C3(255, 80, 120),
	accent3 = C3(255, 200, 90),
	text = C3(252, 248, 244),
	textDim = C3(180, 166, 160),
	textFaint = C3(110, 100, 95),
	bg = C3(18, 13, 12),
	bgAlt = C3(22, 16, 15),
	title = C3(26, 19, 17),
	content = C3(18, 13, 12),
	contentAlt = C3(22, 16, 15),
	tab = C3(20, 15, 14),
	tabHover = C3(31, 22, 19),
	tabActive = C3(56, 28, 18),
	tabActiveAccent = C3(255, 140, 70),
	element = C3(28, 20, 18),
	elementHover = C3(38, 27, 24),
	elementPress = C3(22, 15, 14),
	field = C3(23, 16, 15),
	fieldHover = C3(32, 23, 20),
	border = C3(50, 38, 34),
	borderSoft = C3(42, 32, 29),
	toggleOff = C3(70, 52, 47),
	toggleOn = C3(255, 150, 80),
	sliderTrack = C3(52, 40, 36),
	sliderFill = C3(255, 150, 80),
	sliderGlow = C3(255, 150, 80),
	scroll = C3(78, 58, 52),
	scrollHover = C3(106, 80, 72),
	success = C3(120, 215, 130),
	warning = C3(250, 205, 80),
	danger = C3(250, 95, 105),
	dialogOverlay = C3(9, 6, 5),
	accentBar = C3(255, 150, 80),
	titleBarText = C3(255, 255, 255),
	titleBarSub = C3(160, 145, 138),
	shadow = C3(0, 0, 0),
	activeRing = C3(255, 170, 110),
	checkmark = C3(255, 255, 255),
	swatchBorder = C3(255, 255, 255),
}

Themes.Cloud = {
	name = "Cloud",
	accent = C3(110, 100, 255),
	accent2 = C3(60, 150, 255),
	accent3 = C3(180, 100, 255),
	text = C3(34, 34, 46),
	textDim = C3(118, 118, 140),
	textFaint = C3(160, 160, 180),
	bg = C3(244, 244, 250),
	bgAlt = C3(238, 238, 246),
	title = C3(236, 236, 244),
	content = C3(244, 244, 250),
	contentAlt = C3(238, 238, 246),
	tab = C3(238, 238, 246),
	tabHover = C3(228, 228, 240),
	tabActive = C3(226, 222, 255),
	tabActiveAccent = C3(110, 100, 255),
	element = C3(255, 255, 255),
	elementHover = C3(247, 247, 253),
	elementPress = C3(234, 234, 244),
	field = C3(234, 234, 244),
	fieldHover = C3(226, 226, 238),
	border = C3(222, 222, 236),
	borderSoft = C3(230, 230, 242),
	toggleOff = C3(200, 200, 218),
	toggleOn = C3(110, 100, 255),
	sliderTrack = C3(214, 214, 230),
	sliderFill = C3(110, 100, 255),
	sliderGlow = C3(110, 100, 255),
	scroll = C3(195, 195, 214),
	scrollHover = C3(168, 168, 192),
	success = C3(60, 180, 110),
	warning = C3(220, 165, 40),
	danger = C3(228, 82, 94),
	dialogOverlay = C3(20, 20, 40),
	accentBar = C3(110, 100, 255),
	titleBarText = C3(255, 255, 255),
	titleBarSub = C3(148, 140, 200),
	shadow = C3(120, 110, 170),
	activeRing = C3(110, 100, 255),
	checkmark = C3(255, 255, 255),
	swatchBorder = C3(255, 255, 255),
}

for name in pairs(Themes) do
	table.insert(Nebula.Themes, name)
end
table.sort(Nebula.Themes)

local function theme()
	return Themes[themeName]
end

local state = {
	viewW = 1920,
	viewH = 1080,
	MouseX = 0,
	MouseY = 0,
	Lmb = false,
	Rmb = false,
	Click = false,
	Release = false,
	keysDown = {},
	keysPrev = {},
	typedChars = {},
	fullPoll = false,
	focusedInput = nil,
	focusedEdit = nil,
	listeningKeybind = nil,
}

local VK = {
	["A"] = 0x41, ["B"] = 0x42, ["C"] = 0x43, ["D"] = 0x44, ["E"] = 0x45,
	["F"] = 0x46, ["G"] = 0x47, ["H"] = 0x48, ["I"] = 0x49, ["J"] = 0x4A,
	["K"] = 0x4B, ["L"] = 0x4C, ["M"] = 0x4D, ["N"] = 0x4E, ["O"] = 0x4F,
	["P"] = 0x50, ["Q"] = 0x51, ["R"] = 0x52, ["S"] = 0x53, ["T"] = 0x54,
	["U"] = 0x55, ["V"] = 0x56, ["W"] = 0x57, ["X"] = 0x58, ["Y"] = 0x59,
	["Z"] = 0x5A,
	["0"] = 0x30, ["1"] = 0x31, ["2"] = 0x32, ["3"] = 0x33, ["4"] = 0x34,
	["5"] = 0x35, ["6"] = 0x36, ["7"] = 0x37, ["8"] = 0x38, ["9"] = 0x39,
	F1 = 0x70, F2 = 0x71, F3 = 0x72, F4 = 0x73, F5 = 0x74, F6 = 0x75,
	F7 = 0x76, F8 = 0x77, F9 = 0x78, F10 = 0x79, F11 = 0x7A, F12 = 0x7B,
	Enter = 0x0D, Backspace = 0x08, Tab = 0x09, Space = 0x20,
	Escape = 0x1B, Delete = 0x2E, Home = 0x24, ["End"] = 0x23,
	PageUp = 0x21, PageDown = 0x22,
	Left = 0x25, Up = 0x26, Right = 0x27, Down = 0x28,
	Shift = 0x10, Control = 0x11, Alt = 0x12,
	LeftShift = 0xA0, RightShift = 0xA1,
	LeftControl = 0xA2, RightControl = 0xA3,
	LeftAlt = 0xA4, RightAlt = 0xA5,
	Comma = 0xBC, Period = 0xBE, Slash = 0xBF, Semicolon = 0xBA,
	Quote = 0xDE, Backslash = 0xDC, Backtick = 0xC0,
	LBracket = 0xDB, RBracket = 0xDD, Minus = 0xBD, Equal = 0xBB,
	Mouse4 = 0x05, Mouse5 = 0x06,
}

local VK_BY_NAME = {}
for name, code in pairs(VK) do
	VK_BY_NAME[code] = name
end

local function vkFromName(name)
	return VK[name]
end

local SHIFTED = {
	[0x30] = ")", [0x31] = "!", [0x32] = "@", [0x33] = "#", [0x34] = "$",
	[0x35] = "%", [0x36] = "^", [0x37] = "&", [0x38] = "*", [0x39] = "(",
	[0xBD] = "_", [0xBB] = "+", [0xBA] = ":", [0xDE] = '"',
	[0xBC] = "<", [0xBE] = ">", [0xBF] = "?", [0xDB] = "{",
	[0xDD] = "}", [0xDC] = "|", [0xC0] = "~",
}

local BASE_POLL = {
	0x0D, 0x08, 0x09, 0x1B, 0x2E, 0x24, 0x23, 0x21, 0x22,
	0x25, 0x26, 0x27, 0x28, 0x10, 0x11, 0x05, 0x06,
}

local ALPHA_POLL = {}
for i = 0x30, 0x39 do table.insert(ALPHA_POLL, i) end
for i = 0x41, 0x5A do table.insert(ALPHA_POLL, i) end
for i = 0x70, 0x7B do table.insert(ALPHA_POLL, i) end
table.insert(ALPHA_POLL, 0xBC)
table.insert(ALPHA_POLL, 0xBE)
table.insert(ALPHA_POLL, 0xBF)
table.insert(ALPHA_POLL, 0xBA)
table.insert(ALPHA_POLL, 0xDE)
table.insert(ALPHA_POLL, 0xDC)
table.insert(ALPHA_POLL, 0xC0)
table.insert(ALPHA_POLL, 0xDB)
table.insert(ALPHA_POLL, 0xDD)
table.insert(ALPHA_POLL, 0xBD)
table.insert(ALPHA_POLL, 0xBB)

local boundVks = {}

local function isShiftDown()
	return iskeypressed(0x10) or iskeypressed(0xA0) or iskeypressed(0xA1)
end

local function vkChar(code)
	if code >= 0x41 and code <= 0x5A then
		local c = string.char(code)
		return isShiftDown() and c or string.lower(c)
	end
	if not isShiftDown() and code >= 0x30 and code <= 0x39 then
		return string.char(code)
	end
	return SHIFTED[code]
end

local function readInput()
	local ok1, mx, ok2, my
	ok1, mx = pcall(function() return Mouse.X end)
	ok2, my = pcall(function() return Mouse.Y end)
	if ok1 and ok2 then
		state.MouseX = mx
		state.MouseY = my
	end

	state.keysPrev = state.keysDown
	local lmb = ismouse1pressed()
	local rmb = ismouse2pressed()
	state.Click = lmb and not state.Lmb
	state.Release = not lmb and state.Lmb
	state.Lmb = lmb
	state.Rmb = rmb

	local poll = {}
	for _, c in ipairs(BASE_POLL) do poll[c] = true end
	if state.fullPoll then
		for _, c in ipairs(ALPHA_POLL) do poll[c] = true end
	end
	for code in pairs(boundVks) do poll[code] = true end

	local down = {}
	local typed = {}
	for code in pairs(poll) do
		local ok, v = pcall(iskeypressed, code)
		if ok and v then
			down[code] = true
			if not state.keysPrev[code] then
				local ch = vkChar(code)
				if ch then table.insert(typed, ch) end
			end
		end
	end
	state.keysDown = down
	state.typedChars = typed
end

local function keyJustPressed(code)
	return state.keysDown[code] == true and state.keysPrev[code] == nil
end

local function keyDown(code)
	return state.keysDown[code] == true
end

local function clampN(v, lo, hi)
	return math.max(lo, math.min(hi, v))
end

local function lerpN(a, b, t)
	t = clampN(t, 0, 1)
	return a + (b - a) * t
end

local function ease(v, target, dt, speed)
	return lerpN(v, target, 1 - math.pow(2, -dt * speed))
end

local function easeOutBack(t)
	t = clampN(t, 0, 1)
	local c1 = 1.70158
	local c3 = c1 + 1
	return 1 + c3 * math.pow(t - 1, 3) + c1 * math.pow(t - 1, 2)
end

local function hit(mx, my, x, y, w, h)
	return mx >= x and mx <= x + w and my >= y and my <= y + h
end

local function safeCallback(fn, ...)
	if type(fn) == "function" then
		local ok, err = pcall(fn, ...)
		if not ok then
			Nebula:Notify({ Title = "Callback error", Content = tostring(err), Duration = 5 })
		end
	end
end

local function intRound(v)
	return math.floor(v + 0.5)
end

local function colorLerp(a, b, t)
	t = clampN(t, 0, 1)
	return Color3.fromRGB(
		intRound(lerpN(a.R * 255, b.R * 255, t)),
		intRound(lerpN(a.G * 255, b.G * 255, t)),
		intRound(lerpN(a.B * 255, b.B * 255, t))
	)
end

local function fmtNum(v, rounding)
	rounding = rounding or 0
	local m = 10 ^ rounding
	return tostring(math.floor((v or 0) * m + 0.5) / m)
end

local function hexFromColor(c, alpha)
	local function hx(n)
		return string.format("%02x", clampN(intRound((n or 0) * 255), 0, 255))
	end
	if alpha and alpha > 0 then
		return "#" .. hx(c.R) .. hx(c.G) .. hx(c.B) .. hx(alpha)
	end
	return "#" .. hx(c.R) .. hx(c.G) .. hx(c.B)
end

local function colorFromHex(hexStr)
	hexStr = (hexStr or ""):gsub("#", ""):gsub("0x", "")
	if #hexStr ~= 6 and #hexStr ~= 8 then return nil end
	local function gb(i)
		return tonumber(hexStr:sub(i, i + 1), 16) or 0
	end
	local color = Color3.fromRGB(gb(1), gb(3), gb(5))
	local alpha = #hexStr == 8 and gb(7) / 255 or nil
	return color, alpha
end

-- ============================================================
-- Drawing factories
-- ============================================================

local function newSquare()
	local d = Drawing.new("Square")
	d.Filled = true
	d.Thickness = 1
	d.Color = Color3.new(1, 1, 1)
	d.Transparency = 0
	d.Visible = false
	d.Corner = 0
	d.ZIndex = 1
	return d
end

local function newCircle()
	local d = Drawing.new("Circle")
	d.Filled = true
	d.Color = Color3.new(1, 1, 1)
	d.Transparency = 0
	d.Visible = false
	d.ZIndex = 1
	d.NumSides = 36
	return d
end

local function newLine()
	local d = Drawing.new("Line")
	d.Thickness = 1
	d.Color = Color3.new(1, 1, 1)
	d.Transparency = 0
	d.Visible = false
	d.ZIndex = 1
	return d
end

local function newText(font)
	local d = Drawing.new("Text")
	d.Text = ""
	d.Size = 13
	d.Color = Color3.new(1, 1, 1)
	d.Transparency = 0
	d.Center = false
	d.Outline = true
	d.Visible = false
	d.ZIndex = 1
	d.Font = font or 0
	return d
end

local TEXT_FONT_BODY = 0
local TEXT_FONT_TITLE = 11

local measuredCache = {}
local function textW(s, size)
	size = size or 12
	local key = size .. "|" .. (s or "")
	if measuredCache[key] ~= nil then
		return measuredCache[key]
	end
	local t = newText(0)
	t.Text = s or ""
	t.Size = size
	local w = t.TextBounds.X
	t:Remove()
	measuredCache[key] = w
	if measuredCache[cacheCount] == nil then measuredCache.cacheCount = 0 end
	measuredCache.cacheCount = measuredCache.cacheCount + 1
	if measuredCache.cacheCount > 400 then
		local cleared = 0
		for k in pairs(measuredCache) do
			if k ~= "cacheCount" then
				measuredCache[k] = nil
				cleared = cleared + 1
				if cleared > 250 then break end
			end
		end
		measuredCache.cacheCount = 0
	end
	return w
end

local function setRect(d, x, y, w, h)
	d.Position = Vector2.new(x, y)
	d.Size = Vector2.new(w, h)
end

local function setText(d, text, x, y, size, color, center, visible)
	if d.Text ~= (text or "") then d.Text = text or "" end
	if d.Size ~= size then d.Size = size end
	d.Color = color or Color3.new(1, 1, 1)
	if d.Center ~= center then d.Center = center end
	d.Position = Vector2.new(x, y)
	d.Visible = visible
end

local function setGradientText(dA, dB, text, x, y, size, colA, colB, center, visible)
	text = text or ""
	if text == "" then
		dA.Visible = false
		dB.Visible = false
		return
	end
	local total = textW(text, size)
	local cx = x
	if center then cx = x - total / 2 end
	local split = math.max(math.floor(#text * 0.55), 1)
	local partA = text:sub(1, split)
	local partB = text:sub(split + 1)
	setText(dA, partA, cx, y, size, colA, false, visible)
	if #partB > 0 then
		setText(dB, partB, cx + textW(partA, size), y, size, colB, false, visible)
	else
		dB.Visible = false
	end
end

local function visibleT(base)
	if not translucent then return 0 end
	if base == nil then return 0.02 end
	return base
end

-- element registry for outside-click handling on popups
local allPopups = {}

local function registerOption(handle)
	if handle.Id then
		Nebula.Options[handle.Id] = handle
	end
end

local function removeOption(handle)
	if handle.Id then
		Nebula.Options[handle.Id] = nil
	end
end

local function serializeValue(handle)
	local t = handle.Type
	if t == "Toggle" then return handle.Value
	elseif t == "Slider" then return handle.Value
	elseif t == "Input" then return handle.Value
	elseif t == "Dropdown" then
		if handle.Multi then
			local list = {}
			for k in pairs(handle.Value) do table.insert(list, k) end
			return list
		end
		return handle.Value
	elseif t == "Colorpicker" then
		return { R = handle.Value.R, G = handle.Value.G, B = handle.Value.B, A = handle.alpha or 0 }
	elseif t == "Keybind" then
		return { Key = handle.Value, Mode = handle.mode }
	end
	return nil
end

local function applyValue(handle, v)
	if v == nil then return end
	local t = handle.Type
	if t == "Toggle" then
		handle:SetValue(v == true)
	elseif t == "Slider" then
		handle:SetValue(v)
	elseif t == "Input" then
		handle:SetValue(tostring(v))
	elseif t == "Dropdown" then
		handle:SetValue(v)
	elseif t == "Colorpicker" and type(v) == "table" then
		local c = Color3.fromRGB(
			(v.R and v.R * 255) or 255,
			(v.G and v.G * 255) or 255,
			(v.B and v.B * 255) or 255
		)
		handle:SetValueRGB(c, v.A or 0)
	elseif t == "Keybind" and type(v) == "table" then
		handle:SetValue(v.Key, v.Mode)
	end
end

local BaseHandle = {}
BaseHandle.__index = BaseHandle

function BaseHandle:Get()
	return self.Value
end

function BaseHandle:SetValue(v) end

function BaseHandle:OnChanged(fn)
	self._changed = self._changed or {}
	table.insert(self._changed, fn)
	if fn then safeCallback(fn, self.Value) end
end

function BaseHandle:_emit(...)
	if not self._changed then return end
	for _, fn in ipairs(self._changed) do
		safeCallback(fn, ...)
	end
end

function BaseHandle:SetTitle(text)
	self.Title = text
	if self._setTitleText then self._setTitleText(text) end
end

function BaseHandle:SetDescription(text)
	self.Description = text
	if self._setDescriptionText then self._setDescriptionText(text) end
end

function BaseHandle:Destroy()
	if self._destroyed then return end
	self._destroyed = true
	if self._hideAll then self:_hideAll() end
	if self._destroyDrawings then self:_destroyDrawings() end
	removeOption(self)
	if self._ownerTab and self._ownerTab._removeNode then
		self._ownerTab:_removeNode(self)
	end
end

local TITLE_H = 44
local ACCENT_H = 3
local CONTENT_PAD_X = 14
local ELEMENT_GAP = 6
local SCROLLBAR_W = 4
local CORNER_WIN = 14
local CORNER_EL = 8
local CORNER_SM = 5

local chrome = {}

local function layoutTab(tab)
	local y = 0
	for _, node in ipairs(tab.nodes) do
		if node.kind == "section" then
			local sec = node.section
			if sec.isRoot then
				sec.h = 0
				sec.y = 0
			else
				sec.h = 32
				y = y + 18
				sec.y = y
				y = y + sec.h
			end
		else
			local el = node.element
			local h = el.Height or 36
			if el.HeightFn then h = el:HeightFn() end
			el.y = y
			el.h = h
			y = y + h + ELEMENT_GAP
		end
	end
	tab.contentH = y
end

local function addNode(tab, element)
	local node = { kind = "element", element = element }
	table.insert(tab.nodes, node)
	element._node = node
	layoutTab(tab)
end

local function removeNode(tab, element)
	if element._node then
		local idx = nil
		for i, n in ipairs(tab.nodes) do
			if n == element._node then
				idx = i
				break
			end
		end
		if idx then table.remove(tab.nodes, idx) end
		element._node = nil
		layoutTab(tab)
	end
end

-- shared: hover-accent slide bar used by buttons and rows

-- ============================================================
-- Button
-- ============================================================

local function createButton(tab, config)
	config = config or {}
	local el = setmetatable({
		Type = "Button",
		Id = config.Id or config.Flag,
		Title = config.Title,
		Description = config.Description,
		Style = config.Style or "ghost",
		Callback = config.Callback,
		_ownerTab = tab,
		Height = config.Description and 48 or 38,
		_hoverT = 0,
		_pressT = 0,
		_visible = false,
		Value = nil,
	}, BaseHandle)

	el._bg = newSquare()
	el._glow = newSquare()
	el._bar = newSquare()
	el._title = newText(TEXT_FONT_BODY)
	el._desc = newText(TEXT_FONT_BODY)
	el._arrow = newText(TEXT_FONT_BODY)

	function el:_hideAll()
		el._bg.Visible = false
		el._glow.Visible = false
		el._bar.Visible = false
		el._title.Visible = false
		el._desc.Visible = false
		el._arrow.Visible = false
	end

	function el:_destroyDrawings()
		el._bg:Remove()
		el._glow:Remove()
		el._bar:Remove()
		el._title:Remove()
		el._desc:Remove()
		el._arrow:Remove()
	end

	function el:_update(dt, cx, cy, cw, ch, scroll)
		local th = theme()
		if not el._visible then return end
		local y = cy + el.y - scroll
		if y + el.h < cy or y > cy + ch then
			el:_hideAll()
			return
		end
		local hov = hit(state.MouseX, state.MouseY, cx, y, cw, el.h)
		local press = hov and state.Lmb
		el._hoverT = ease(el._hoverT, hov and 1 or 0, dt, 16)
		el._pressT = ease(el._pressT, press and 1 or 0, dt, 20)

		local accent = el.Style == "accent"
		local base
		if accent then
			base = colorLerp(th.accent, th.accent2, 0.15)
			base = Color3.fromRGB(
				clampN(intRound(base.R * 255 - el._pressT * 20), 0, 255),
				clampN(intRound(base.G * 255 - el._pressT * 20), 0, 255),
				clampN(intRound(base.B * 255 - el._pressT * 20), 0, 255)
			)
		else
			base = colorLerp(th.element, th.elementHover, el._hoverT)
			base = Color3.fromRGB(
				clampN(intRound(base.R * 255 - el._pressT * 14), 0, 255),
				clampN(intRound(base.G * 255 - el._pressT * 14), 0, 255),
				clampN(intRound(base.B * 255 - el._pressT * 14), 0, 255)
			)
		end

		-- solid ring: accent buttons keep a hover halo, ghost buttons get an always-visible border
		local glowA = el._hoverT * 0.25
		if accent then
			el._glow.Color = th.accent
			el._glow.Transparency = visibleT(glowA + 0.3)
			el._glow.Visible = hov or el._hoverT > 0.01
		else
			el._glow.Color = hov and th.accent or th.borderSoft
			el._glow.Transparency = visibleT(0)
			el._glow.Visible = true
		end
		el._glow.Corner = CORNER_EL + 2
		el._glow.Outline = true
		el._glow.Filled = false
		el._glow.Thickness = 1
		setRect(el._glow, cx - 1, y - 1, cw + 2, el.h + 2)

		el._bg.Color = base
		el._bg.Corner = CORNER_EL
		el._bg.Transparency = visibleT(0)
		el._bg.Outline = accent
		el._bg.Thickness = accent and 1 or 0
		setRect(el._bg, cx, y, cw, el.h)

		-- left accent slide bar on hover
		if not accent then
			local barW = 3 + el._hoverT * 3
			el._bar.Color = colorLerp(th.accent, th.accent2, el._hoverT)
			el._bar.Corner = 2
			setRect(el._bar, cx, y, barW, el.h)
			el._bar.Visible = el._hoverT > 0.01
		else
			el._bar.Visible = false
		end

		local titleColor = accent and th.titleBarText or th.text
		setText(el._title, el.Title or "Button", cx + 14 + el._hoverT * 2, y + (el.Description and 6 or 12), 13, titleColor, false, true)
		if el.Description then
			setText(el._desc, el.Description, cx + 14 + el._hoverT * 2, y + 25, 11, th.textDim, false, true)
		end
		setText(el._arrow, ">", cx + cw - 16, y + (el.Description and 15 or 12), 12, accent and th.titleBarText or th.textFaint, true, true)
		if not hov then el._arrow.Transparency = 1 end
		el._arrow.Visible = false

		if state.Click and hov then
			safeCallback(el.Callback)
		end
	end

	addNode(tab, el)
	el._visible = true
	return el
end

-- ============================================================
-- Toggle
-- ============================================================

local function createToggle(tab, config)
	config = config or {}
	local el = setmetatable({
		Type = "Toggle",
		Id = config.Id or config.Flag,
		Title = config.Title,
		Description = config.Description,
		Callback = config.Callback,
		_ownerTab = tab,
		_visible = false,
		_hoverT = 0,
		_knobAnim = 0,
		_glowPulse = 0,
		Value = config.Default == true,
	}, BaseHandle)

	el.HeightFn = function()
		return el.Description and 48 or 38
	end

	local kbConfig = config.Keybind
	if kbConfig then
		if type(kbConfig) == "table" then
			el.Keybind = kbConfig.Default or "F1"
			el._bindMode = kbConfig.Mode or "Toggle"
		else
			el.Keybind = kbConfig
			el._bindMode = "Toggle"
		end
		local vk = vkFromName(el.Keybind)
		if vk then boundVks[vk] = true end
	end
	el._knobAnim = el.Value and 1 or 0

	el._bg = newSquare()
	el._leftBar = newSquare()
	el._title = newText(TEXT_FONT_BODY)
	el._desc = newText(TEXT_FONT_BODY)
	el._keyHint = newText(TEXT_FONT_BODY)
	el._track = newSquare()
	el._trackFill = newSquare()
	el._knob = newCircle()
	el._knobRing = newCircle()

	function el:SetValue(v, fire)
		v = v == true
		if v ~= el.Value then
			el.Value = v
			el._knobAnim = v and 1 or 0
			if fire ~= false then
				safeCallback(el.Callback, v)
				el:_emit(v)
			end
		end
	end

	function el:_hideAll()
		el._bg.Visible = false
		el._leftBar.Visible = false
		el._title.Visible = false
		el._desc.Visible = false
		el._keyHint.Visible = false
		el._track.Visible = false
		el._trackFill.Visible = false
		el._knob.Visible = false
		el._knobRing.Visible = false
	end

	function el:_destroyDrawings()
		el._bg:Remove()
		el._leftBar:Remove()
		el._title:Remove()
		el._desc:Remove()
		el._keyHint:Remove()
		el._track:Remove()
		el._trackFill:Remove()
		el._knob:Remove()
		el._knobRing:Remove()
	end

	function el:_update(dt, cx, cy, cw, ch, scroll)
		local th = theme()
		if not el._visible then return end
		local y = cy + el.y - scroll
		local h = el.h
		if y + h < cy or y > cy + ch then
			el:_hideAll()
			return
		end
		local hov = hit(state.MouseX, state.MouseY, cx, y, cw, h)
		el._hoverT = ease(el._hoverT, hov and 1 or 0, dt, 14)
		el._knobAnim = ease(el._knobAnim, el.Value and 1 or 0, dt, 16)
		local on = el.Value

		local base = colorLerp(th.element, th.elementHover, el._hoverT)
		el._bg.Color = base
		el._bg.Corner = CORNER_EL
		el._bg.Outline = hov
		el._bg.Thickness = hov and 1 or 0
		setRect(el._bg, cx, y, cw, h)

		-- left accent state bar
		local barW = math.max(3, 4 * el._knobAnim)
		el._leftBar.Color = on and colorLerp(th.accent, th.accent2, 0.2) or th.border
		el._leftBar.Corner = 2
		setRect(el._leftBar, cx, y + 4, barW * math.max(el._knobAnim, hov and 0.5 or 0), h - 8)
		el._leftBar.Visible = el._knobAnim > 0.02 or hov

		setText(el._title, el.Title or "", cx + 20, y + (el.Description and 6 or 11), 13, on and th.text or th.text, false, true)
		if el.Description then
			setText(el._desc, el.Description, cx + 20, y + 24, 11, th.textDim, false, true)
		end

		if el.Keybind then
			setText(el._keyHint, "[" .. tostring(el.Keybind) .. "]", cx + 20 + textW(el.Description and (el.Description .. "  ") or "", 0) + (el.Description and textW(el.Title or "", 13) + textW(el.Description, 11) + 8 or textW(el.Title or "", 13)) + 8, y + (el.Description and 6 or 11), 11, th.textFaint, false, true)
		else
			el._keyHint.Visible = false
		end

		-- toggle switch
		local tx = cx + cw - 50
		local trackW = 38
		local trackH = 20
		local ty = y + (h - trackH) / 2
		local radius = trackH / 2
		local centerX = tx + radius
		local anim = easeOutBack(el._knobAnim)

		-- glow halo when on
		local glowA = on and (0.30 + 0.10 * math.sin(tick() * 4) * 0 + 0.0) or 0
		el._trackFill.Color = colorLerp(th.toggleOff, th.accent, el._knobAnim)
		el._trackFill.Corner = radius
		el._trackFill.Outline = on and el._knobAnim > 0.5
		el._trackFill.Thickness = 1
		setRect(el._trackFill, tx, ty, trackW, trackH)
		el._trackFill.Visible = true

		-- subtle inner shadow strip
		el._track.Color = th.shadow
		el._track.Transparency = 0.55
		setRect(el._track, tx, ty + trackH * 0.55, trackW, trackH * 0.4)
		el._track.Corner = radius
		el._track.Visible = true

		local knobR = 7
		local kx = tx + radius + (trackW - trackH) * anim
		el._knobRing.Color = th.swatchBorder
		el._knobRing.Radius = knobR + 3
		el._knobRing.Outline = true
		el._knobRing.Filled = false
		el._knobRing.Thickness = on and 1 or 0
		el._knobRing.Position = Vector2.new(kx, ty + radius)
		el._knobRing.Visible = on and el._knobAnim > 0.5

		el._knob.Position = Vector2.new(kx, ty + radius)
		el._knob.Radius = knobR
		el._knob.Color = on and Color3.new(1, 1, 1) or th.scrollHover
		el._knob.Visible = true

		if state.Click and hov then
			el:SetValue(not el.Value, true)
		end
	end

	addNode(tab, el)
	el._visible = true
	registerOption(el)
	return el
end

-- ============================================================
-- Slider
-- ============================================================

local function createSlider(tab, config)
	config = config or {}
	local el = setmetatable({
		Type = "Slider",
		Id = config.Id or config.Flag,
		Title = config.Title,
		Callback = config.Callback,
		_ownerTab = tab,
		_visible = false,
		_hoverT = 0,
		Height = 48,
		Min = config.Min or 0,
		Max = config.Max or 100,
		Rounding = config.Rounding or 0,
		Suffix = config.Suffix or "",
		_dragging = false,
		_editValue = false,
		_editBuf = "",
	}, BaseHandle)

	el.Value = config.Default
	if el.Value == nil then el.Value = el.Min end

	el._bg = newSquare()
	el._bar = newSquare()
	el._title = newText(TEXT_FONT_BODY)
	el._track = newSquare()
	el._trackBorder = newSquare()
	el._fill = newSquare()
	el._fillGlow = newSquare()
	el._knob = newCircle()
	el._knobRing = newCircle()
	el._value = newText(TEXT_FONT_TITLE)
	el._editBg = newSquare()
	el._editText = newText(TEXT_FONT_BODY)

	local function snap(v)
		local m = 10 ^ el.Rounding
		return math.floor(clampN(v, el.Min, el.Max) * m + 0.5) / m
	end

	function el:SetValue(v, fire)
		v = snap(tonumber(v) or el.Min)
		if v ~= el.Value then
			local old = el.Value
			el.Value = v
			if fire ~= false then
				safeCallback(el.Callback, v, old)
				el:_emit(v, old)
			end
		end
	end

	function el:_hideAll()
		el._bg.Visible = false
		el._bar.Visible = false
		el._title.Visible = false
		el._track.Visible = false
		el._trackBorder.Visible = false
		el._fill.Visible = false
		el._fillGlow.Visible = false
		el._knob.Visible = false
		el._knobRing.Visible = false
		el._value.Visible = false
		el._editBg.Visible = false
		el._editText.Visible = false
	end

	function el:_destroyDrawings()
		el._bg:Remove()
		el._bar:Remove()
		el._title:Remove()
		el._track:Remove()
		el._trackBorder:Remove()
		el._fill:Remove()
		el._fillGlow:Remove()
		el._knob:Remove()
		el._knobRing:Remove()
		el._value:Remove()
		el._editBg:Remove()
		el._editText:Remove()
	end

	function el:_update(dt, cx, cy, cw, ch, scroll)
		local th = theme()
		if not el._visible then return end
		local y = cy + el.y - scroll
		if y + el.h < cy or y > cy + ch then
			el:_hideAll()
			return
		end
		local hov = hit(state.MouseX, state.MouseY, cx, y, cw, el.h)
		el._hoverT = ease(el._hoverT, hov and 1 or 0, dt, 14)

		local base = colorLerp(th.element, th.elementHover, el._hoverT)
		el._bg.Color = base
		el._bg.Corner = CORNER_EL
		el._bg.Outline = hov or el._dragging
		el._bg.Thickness = (hov or el._dragging) and 1 or 0
		el._bg.Color = base
		setRect(el._bg, cx, y, cw, el.h)

		el._bar.Color = colorLerp(th.accent, th.accent2, 0.2)
		el._bar.Corner = 2
		setRect(el._bar, cx, y + 3, 3, el.h - 6)
		el._bar.Visible = true

		setText(el._title, el.Title or "", cx + 14, y + 6, 13, th.text, false, true)

		local trackX = cx + 14
		local trackW = math.max(cw - 28 - 84, 40)
		local trackY = y + 28
		local trackH = 6
		local range = el.Max - el.Min
		local frac = range > 0 and (el.Value - el.Min) / range or 0
		frac = clampN(frac, 0, 1)

		el._trackBorder.Color = th.border
		el._trackBorder.Corner = trackH / 2
		el._trackBorder.Outline = true
		el._trackBorder.Thickness = 1
		el._trackBorder.Filled = true
		setRect(el._trackBorder, trackX - 1, trackY - 1, trackW + 2, trackH + 2)
		el._trackBorder.Visible = true

		el._track.Color = th.sliderTrack
		el._track.Corner = trackH / 2
		setRect(el._track, trackX, trackY, trackW, trackH)
		el._track.Visible = true

		local fillW = math.max(frac * trackW, 2)
		local fillColor = colorLerp(th.accent, th.accent2, frac * 0.5)
		el._fill.Color = fillColor
		el._fill.Corner = trackH / 2
		setRect(el._fill, trackX, trackY, fillW, trackH)
		el._fill.Visible = true

		-- glow under the filled portion
		local ga = 0.35 + el._hoverT * 0.15
		el._fillGlow.Color = fillColor
		el._fillGlow.Transparency = visibleT(ga)
		el._fillGlow.Corner = 2
		setRect(el._fillGlow, trackX, trackY + trackH + 1, fillW, 2)
		el._fillGlow.Visible = fillW > 2

		local playing = el._dragging or hov
		local knobX = trackX + frac * trackW
		el._knobRing.Color = fillColor
		el._knobRing.Radius = playing and 9 or 7
		el._knobRing.Outline = true
		el._knobRing.Filled = false
		el._knobRing.Thickness = 1
		el._knobRing.Position = Vector2.new(knobX, trackY + trackH / 2)
		el._knobRing.Visible = playing

		el._knob.Position = Vector2.new(knobX, trackY + trackH / 2)
		el._knob.Radius = 5
		el._knob.Color = Color3.new(1, 1, 1)
		el._knob.Visible = true

		local vt = fmtNum(el.Value, el.Rounding) .. el.Suffix
		if el._editValue then
			el._editBg.Color = th.fieldHover
			el._editBg.Corner = CORNER_SM
			el._editBg.Outline = true
			el._editBg.Thickness = 1
			setRect(el._editBg, cx + cw - 78, y + 5, 64, 20)
			el._editText.Color = th.text
			setText(el._editText, el._editBuf, cx + cw - 78 + 6, y + 7, 12, th.text, false, true)
		else
			setText(el._value, vt, cx + cw - 16 - textW(vt, 13), y + 7, 13, th.text, false, true)
		end

		local onTrack = hit(state.MouseX, state.MouseY, trackX, trackY - 8, trackW, trackH + 16)
		local onValue = not el._editValue and hit(state.MouseX, state.MouseY, cx + cw - 82, y + 3, 68, 24)

		if state.Click and onValue then
			el._editValue = true
			el._editBuf = fmtNum(el.Value, el.Rounding)
			state.fullPoll = true
			state.focusedEdit = el
		elseif state.Click and hov and not onTrack then
			if el._editValue then
				el._editValue = false
				el._endEdit()
			end
		end
		if el._editValue then
			if keyJustPressed(0x0D) then
				local n = tonumber(el._editBuf)
				if n then el:SetValue(n, true) end
				el._editValue = false
				el._endEdit()
			elseif keyJustPressed(0x1B) then
				el._editValue = false
				el._endEdit()
			else
				for _, ch in ipairs(state.typedChars) do
					if ch == "-" or ch == "." or (ch >= "0" and ch <= "9") then
						el._editBuf = el._editBuf .. ch
					end
				end
				if keyJustPressed(0x08) then
					el._editBuf = el._editBuf:sub(1, -2)
				end
			end
		end

		if el._dragging or (state.Click and onTrack) then
			el._dragging = true
			local mxLocal = clampN(state.MouseX - trackX, 0, trackW)
			el:SetValue(el.Min + (mxLocal / trackW) * range, true)
		end
		if not state.Lmb then el._dragging = false end
	end

	function el:_endEdit()
		state.fullPoll = false
		state.focusedEdit = nil
	end

	addNode(tab, el)
	el._visible = true
	registerOption(el)
	return el
end

-- ============================================================
-- Dropdown
-- ============================================================

local DROPDOWN_POOL = 8

local function createDropdown(tab, config)
	config = config or {}
	local el = setmetatable({
		Type = "Dropdown",
		Id = config.Id or config.Flag,
		Title = config.Title,
		Description = config.Description,
		Callback = config.Callback,
		_ownerTab = tab,
		_visible = false,
		_hoverT = 0,
		Height = 38,
		Options = config.Options or config.Values or { "None" },
		Multi = config.Multi == true,
		AllowNull = config.AllowNull == true,
		Searchable = config.Searchable == true,
		Displayer = config.Displayer or tostring,
		MaxItems = config.MaxItems or 6,
		_open = false,
		_search = "",
		_selScroll = 0,
		_dragScroll = false,
		_justOpened = false,
	}, BaseHandle)

	if el.Multi then
		local set = {}
		local d = config.Default
		if type(d) == "table" then
			for _, o in ipairs(d) do set[o] = true end
		elseif d ~= nil then
			set[d] = true
		end
		el.Value = set
	else
		local d = config.Default
		if type(d) == "number" and el.Options[d] then
			el.Value = el.Options[d]
		elseif d ~= nil then
			el.Value = d
		else
			el.Value = el.Options[1] or nil
		end
	end

	el._bg = newSquare()
	el._bar = newSquare()
	el._title = newText(TEXT_FONT_BODY)
	el._valueText = newText(TEXT_FONT_TITLE)
	el._chevron = newText(TEXT_FONT_BODY)

	el._popupShadow = newSquare()
	el._popupBg = newSquare()
	el._popupBorder = newSquare()
	el._popupScroll = newSquare()
	el._popupScrollThumb = newSquare()
	el._searchBg = newSquare()
	el._searchText = newText(TEXT_FONT_BODY)
	el._pool = {}
	for i = 1, DROPDOWN_POOL do
		el._pool[i] = {
			bg = newSquare(),
			text = newText(TEXT_FONT_BODY),
			check = newText(TEXT_FONT_BODY),
		}
	end

	local function displaySet(set)
		local parts = {}
		for k in pairs(set) do table.insert(parts, el.Displayer(k)) end
		table.sort(parts)
		return table.concat(parts, ", ")
	end

	local function displayVal()
		if el.Multi then
			local n = 0
			for _ in pairs(el.Value) do n = n + 1 end
			if n == 0 then return "None" end
			return displaySet(el.Value)
		end
		if el.Value == nil then return "None" end
		return el.Displayer(el.Value)
	end

	function el:SetValues(list)
		el.Options = list or { "None" }
		if not el.Multi then
			el.Value = el.Options[1] or nil
			safeCallback(el.Callback, el.Value)
			el:_emit(el.Value)
		end
	end

	function el:SetValue(v, fire)
		if el.Multi then
			local nextSet = {}
			if type(v) == "table" then
				for k in pairs(v) do nextSet[k] = true end
			end
			local changed = false
			for k in pairs(nextSet) do
				if not el.Value[k] then changed = true end
			end
			for k in pairs(el.Value) do
				if not nextSet[k] then changed = true end
			end
			el.Value = nextSet
			if changed and fire ~= false then
				safeCallback(el.Callback, el.Value)
				el:_emit(el.Value)
			end
			return
		end
		if v ~= el.Value then
			el.Value = v
			if fire ~= false then
				safeCallback(el.Callback, v)
				el:_emit(v)
			end
		end
	end

	function el:_hideAll()
		el._bg.Visible = false
		el._bar.Visible = false
		el._title.Visible = false
		el._valueText.Visible = false
		el._chevron.Visible = false
		el:_closePopup()
	end

	function el:_closePopup()
		el._popupShadow.Visible = false
		el._popupBg.Visible = false
		el._popupBorder.Visible = false
		el._popupScroll.Visible = false
		el._popupScrollThumb.Visible = false
		el._searchBg.Visible = false
		el._searchText.Visible = false
		for _, p in ipairs(el._pool) do
			p.bg.Visible = false
			p.text.Visible = false
			p.check.Visible = false
		end
		if allPopups[el] then
			allPopups[el] = nil
			state.fullPoll = false
		end
		el._open = false
	end

	function el:_destroyDrawings()
		el:_closePopup()
		el._bg:Remove()
		el._bar:Remove()
		el._title:Remove()
		el._valueText:Remove()
		el._chevron:Remove()
		el._popupShadow:Remove()
		el._popupBg:Remove()
		el._popupBorder:Remove()
		el._popupScroll:Remove()
		el._popupScrollThumb:Remove()
		el._searchBg:Remove()
		el._searchText:Remove()
		for _, p in ipairs(el._pool) do
			p.bg:Remove()
			p.text:Remove()
			p.check:Remove()
		end
	end

	local function filteredOptions()
		if not el.Searchable or el._search == "" then
			return el.Options
		end
		local s = el._search:lower()
		local out = {}
		for _, o in ipairs(el.Options) do
			if tostring(o):lower():find(s, 1, true) then
				out[#out + 1] = o
			end
		end
		return out
	end

	function el:_outerClick()
		if el._open and not el._justOpened then
			local p = el._popupBg
			if not hit(state.MouseX, state.MouseY, p.Position.X, p.Position.Y, p.Size.X, p.Size.Y) then
				el:_closePopup()
			end
		end
	end

	function el:_update(dt, cx, cy, cw, ch, scroll)
		local th = theme()
		if not el._visible then return end
		local y = cy + el.y - scroll
		if y + el.h < cy or y > cy + ch then
			el:_hideAll()
			return
		end
		local hov = hit(state.MouseX, state.MouseY, cx, y, cw, el.h)
		el._hoverT = ease(el._hoverT, (hov or el._open) and 1 or 0, dt, 14)

		local base = colorLerp(th.element, th.elementHover, el._hoverT)
		el._bg.Color = base
		el._bg.Corner = CORNER_EL
		el._bg.Outline = hov or el._open
		el._bg.Thickness = (hov or el._open) and 1 or 0
		setRect(el._bg, cx, y, cw, el.h)

		el._bar.Color = el._open and colorLerp(th.accent, th.accent2, 0.2) or (el._hoverT > 0.01 and th.accent or th.border)
		el._bar.Corner = 2
		setRect(el._bar, cx, y + 4, 3, el.h - 8)
		el._bar.Visible = true

		setText(el._title, el.Title or "", cx + 14, y + (el.Description and 5 or 12), 13, th.text, false, true)
		if el.Description then
			setText(el._descText or (function()
				el._descText = newText(TEXT_FONT_BODY)
				return el._descText
			end)(), el.Description, cx + 14, y + 24, 11, th.textDim, false, true)
		end
		local dv = displayVal()
		local dvw = math.min(textW(dv, 12), cw - 100)
		setText(el._valueText, dv, cx + cw - 12 - dvw, y + 12, 12, el.Value == nil or (el.Multi and next(el.Value) == nil) and th.textFaint or th.text, false, true)

		-- chevron draw: two short lines
		local chevX = cx + cw - 18
		local chevY = y + (el.h - 4) / 2
		setText(el._chevron, el._open and "/\\" or "\\/", chevX, y + 12, 11, el._open and th.accent or th.textFaint, true, true)

		if state.Click and hov then
			if el._open then
				el:_closePopup()
			else
				el._open = true
				el._search = ""
				el._selScroll = 0
				el._justOpened = true
				allPopups[el] = true
				if el.Searchable then state.fullPoll = true end
			end
		end
		if el._justOpened and not state.Click then
			el._justOpened = false
		end

		if el._open then
			local opts = filteredOptions()
			local itemH = 28
			local visible = math.min(#opts, el.MaxItems)
			local pw = math.min(cw, 270)
			local ph = (el.Searchable and 28 or 0) + visible * itemH + 8
			local px = cx
			local py = y + el.h + 4
			local popAnim = clampN(el._justOpened and 1 or 1, 0, 1)
			if py + ph > state.viewH then
				py = y - ph - 4
			end
			if py < 0 then py = y + el.h + 4 end

			el._popupShadow.Color = th.shadow
			el._popupShadow.Transparency = 0.45
			el._popupShadow.Corner = 10
			setRect(el._popupShadow, px + 3, py + 3, pw, ph)
			el._popupShadow.Visible = true

			el._popupBg.Color = th.tab
			el._popupBg.Corner = 10
			setRect(el._popupBg, px, py, pw, ph)
			el._popupBg.Visible = true

			el._popupBorder.Color = colorLerp(th.border, th.activeRing, el._hoverT)
			el._popupBorder.Transparency = visibleT(0)
			el._popupBorder.Corner = 10
			el._popupBorder.Outline = true
			el._popupBorder.Filled = false
			el._popupBorder.Thickness = 1
			setRect(el._popupBorder, px, py, pw, ph)
			el._popupBorder.Visible = true

			el._popupBg.Transparency = visibleT(0)

			local iy = py + 4
			if el.Searchable then
				el._searchBg.Color = th.field
				el._searchBg.Corner = CORNER_SM
				el._searchBg.Outline = true
				el._searchBg.Thickness = 1
				setRect(el._searchBg, px + 6, iy, pw - 12, 20)
				el._searchBg.Visible = true
				local place = el._search == "" and (config.SearchPlaceholder or "Search...") or el._search
				setText(el._searchText, place, px + 12, iy + 3, 11, el._search == "" and th.textFaint or th.text, false, true)
				iy = iy + 28
			end

			local listH = visible * itemH
			local totalH = #opts * itemH
			local maxScroll = math.max(0, totalH - listH)
			el._selScroll = clampN(el._selScroll, 0, maxScroll)
			local scrollOff = math.floor(el._selScroll / itemH)

			for i = 1, DROPDOWN_POOL do
				local slot = el._pool[i]
				local idx = scrollOff + i
				local o = opts[idx]
				if o ~= nil then
					local yyReal = iy + (idx - 1 - scrollOff) * itemH
					local selected = el.Multi and el.Value[o] == true or el.Value == o
					local ohov = hit(state.MouseX, state.MouseY, px + 3, yyReal, pw - 6, itemH)
					if ohov or selected then
						slot.bg.Transparency = visibleT(0)
						slot.bg.Color = selected and colorLerp(
							Color3.fromRGB(
								intRound(th.accent.R * 255 * 0.30 + th.tab.R * 255 * 0.70),
								intRound(th.accent.G * 255 * 0.30 + th.tab.G * 255 * 0.70),
								intRound(th.accent.B * 255 * 0.30 + th.tab.B * 255 * 0.70)
							),
							th.tabHover,
							ohov and 1 or 0
						) or th.tabHover
						slot.bg.Outline = selected and not ohov
						slot.bg.Thickness = 1
					else
						slot.bg.Transparency = 1
						slot.bg.Color = th.tab
						slot.bg.Outline = false
					end
					slot.bg.Corner = CORNER_SM
					setRect(slot.bg, px + 3, yyReal, pw - 6, itemH - 3)
					slot.bg.Visible = ohov or selected
					setText(slot.text, el.Displayer(o), px + 12, yyReal + 6, 12, selected and th.accent or th.text, false, true)
					if selected then
						slot.bg.Outline = true
						setText(slot.check, "x", px + pw - 18, yyReal + 6, 12, th.checkmark, true, true)
					else
						slot.check.Visible = false
					end

					if state.Click and ohov then
						if el.Multi then
							local ns = {}
							for k in pairs(el.Value) do ns[k] = true end
							if ns[o] then ns[o] = nil else ns[o] = true end
							el.Value = ns
							safeCallback(el.Callback, el.Value)
							el:_emit(el.Value)
						else
							el.Value = o
							safeCallback(el.Callback, o)
							el:_emit(o)
							el:_closePopup()
						end
					end
				else
					slot.bg.Visible = false
					slot.text.Visible = false
					slot.check.Visible = false
				end
			end

			if maxScroll > 0 then
				local sx = px + pw - 9
				el._popupScroll.Color = th.elementPress
				el._popupScroll.Corner = 2
				setRect(el._popupScroll, sx, iy, 3, listH)
				el._popupScroll.Visible = true
				local thumbH = math.max(16, listH * (listH / totalH))
				local thumbY = iy + (el._selScroll / maxScroll) * (listH - thumbH)
				el._popupScrollThumb.Color = th.scroll
				el._popupScrollThumb.Corner = 2
				setRect(el._popupScrollThumb, sx, thumbY, 3, thumbH)
				el._popupScrollThumb.Visible = true

				if state.Click and hit(state.MouseX, state.MouseY, sx - 3, iy, 9, listH) then
					el._dragScroll = true
				end
				if el._dragScroll then
					local rel = clampN(state.MouseY - iy, 0, listH - thumbH)
					el._selScroll = (rel / math.max(listH - thumbH, 1)) * maxScroll
				end
			else
				el._popupScroll.Visible = false
				el._popupScrollThumb.Visible = false
			end

			if el.Searchable then
				for _, chf in ipairs(state.typedChars) do
					if chf ~= "" and not (chf:match("\n")) then
						el._search = el._search .. chf
						el._selScroll = 0
					end
				end
				if keyJustPressed(0x08) then
					el._search = el._search:sub(1, -2)
					el._selScroll = 0
				end
				if keyJustPressed(0x1B) then
					el:_closePopup()
				end
			end
		else
			el:_closePopup()
		end
	end

	addNode(tab, el)
	el._visible = true
	registerOption(el)
	return el
end

-- ============================================================
-- Colorpicker
-- ============================================================

local function hsvToRgb(h, s, v)
	if s <= 0 then return v, v, v end
	h = ((h % 360) / 60)
	local i = math.floor(h)
	local f = h - i
	local p = v * (1 - s)
	local q = v * (1 - s * f)
	local t = v * (1 - s * (1 - f))
	if i == 0 then return v, t, p
	elseif i == 1 then return q, v, p
	elseif i == 2 then return p, v, t
	elseif i == 3 then return p, q, v
	elseif i == 4 then return t, p, v
	else return v, p, q end
end

local function rgbToHsv(r, g, b)
	local mx = math.max(r, g, b)
	local mn = math.min(r, g, b)
	local d = mx - mn
	local h = 0
	if d > 0 then
		if mx == r then h = (g - b) / d
		elseif mx == g then h = 2 + (b - r) / d
		else h = 4 + (r - g) / d end
		h = h * 60
		if h < 0 then h = h + 360 end
	end
	local s = mx > 0 and d / mx or 0
	return h, s, mx
end

local function createColorpicker(tab, config)
	config = config or {}
	local el = setmetatable({
		Type = "Colorpicker",
		Id = config.Id or config.Flag,
		Title = config.Title,
		Callback = config.Callback,
		_ownerTab = tab,
		_visible = false,
		_hoverT = 0,
		Height = 38,
		Value = config.Default or Color3.new(1, 1, 1),
		alpha = config.Transparency,
		UpdateOnChange = config.UpdateOnChange == true,
		_open = false,
		_dragSV = false,
		_dragHue = false,
		_dragAlpha = false,
		_editHex = false,
		_hexBuf = nil,
	}, BaseHandle)

	el._hasAlpha = config.Transparency ~= nil
	el._h, el._s, el._v = rgbToHsv(el.Value.R, el.Value.G, el.Value.B)

	el._bg = newSquare()
	el._bar = newSquare()
	el._title = newText(TEXT_FONT_BODY)
	el._swatch = newSquare()
	el._swatchRing = newSquare()
	el._swatchFrame = newSquare()
	el._valueHex = newText(TEXT_FONT_BODY)

	el._popShadow = newSquare()
	el._popBg = newSquare()
	el._popBorder = newSquare()
	el._svGrid = {}
	for i = 1, 9 do
		el._svGrid[i] = {}
		for j = 1, 9 do
			el._svGrid[i][j] = newSquare()
		end
	end
	el._svCursor = newCircle()
	el._svCursorRing = newCircle()
	el._hueBar = {}
	for i = 1, 8 do
		el._hueBar[i] = newSquare()
	end
	el._hueCursor = newSquare()
	if el._hasAlpha then
		el._alphaBar = {}
		for i = 1, 8 do
			el._alphaBar[i] = newSquare()
		end
		el._alphaCursor = newSquare()
	end
	el._hexLab = newText(TEXT_FONT_BODY)
	el._hexBg = newSquare()
	el._hexText = newText(TEXT_FONT_BODY)
	el._doneBg = newSquare()
	el._doneText = newText(TEXT_FONT_BODY)
	el._cancelBg = newSquare()
	el._cancelText = newText(TEXT_FONT_BODY)

	local function emitNow(wasDragging)
		safeCallback(el.Callback, el.Value, el.alpha)
		el:_emit(el.Value, el.alpha)
	end

	function el:SetValueRGB(color, alpha)
		color = color or el.Value
		if alpha ~= nil then el.alpha = alpha end
		el.Value = color
		el._h, el._s, el._v = rgbToHsv(color.R, color.G, color.B)
		safeCallback(el.Callback, color, el.alpha)
		el:_emit(color, el.alpha)
	end

	function el:SetValue(color)
		el:SetValueRGB(color)
	end

	function el:_hideAll()
		el._bg.Visible = false
		el._bar.Visible = false
		el._title.Visible = false
		el._swatch.Visible = false
		el._swatchRing.Visible = false
		el._swatchFrame.Visible = false
		el._valueHex.Visible = false
		el:_closePopup()
	end

	function el:_closePopup()
		el._popShadow.Visible = false
		el._popBg.Visible = false
		el._popBorder.Visible = false
		el._svCursor.Visible = false
		el._svCursorRing.Visible = false
		el._hueCursor.Visible = false
		for _, row in ipairs(el._svGrid) do
			for _, d in ipairs(row) do d.Visible = false end
		end
		for _, d in ipairs(el._hueBar) do d.Visible = false end
		if el._hasAlpha then
			for _, d in ipairs(el._alphaBar) do d.Visible = false end
			el._alphaCursor.Visible = false
		end
		el._hexLab.Visible = false
		el._hexBg.Visible = false
		el._hexText.Visible = false
		el._doneBg.Visible = false
		el._doneText.Visible = false
		el._cancelBg.Visible = false
		el._cancelText.Visible = false
		if allPopups[el] then
			allPopups[el] = nil
			state.fullPoll = false
		end
		el._open = false
		el._editHex = false
		el._hexBuf = nil
		if state.focusedEdit == el then
			state.focusedEdit = nil
		end
	end

	function el:_destroyDrawings()
		el:_closePopup()
		el._bg:Remove()
		el._bar:Remove()
		el._title:Remove()
		el._swatch:Remove()
		el._swatchRing:Remove()
		el._swatchFrame:Remove()
		el._valueHex:Remove()
		el._popShadow:Remove()
		el._popBg:Remove()
		el._popBorder:Remove()
		el._svCursor:Remove()
		el._svCursorRing:Remove()
		el._hueCursor:Remove()
		for _, row in ipairs(el._svGrid) do
			for _, d in ipairs(row) do d:Remove() end
		end
		for _, d in ipairs(el._hueBar) do d:Remove() end
		if el._hasAlpha then
			for _, d in ipairs(el._alphaBar) do d:Remove() end
			el._alphaCursor:Remove()
		end
		el._hexLab:Remove()
		el._hexBg:Remove()
		el._hexText:Remove()
		el._doneBg:Remove()
		el._doneText:Remove()
		el._cancelBg:Remove()
		el._cancelText:Remove()
	end

	function el:_outerClick()
		if el._open and not el._justOpened then
			local p = el._popBg
			if not hit(state.MouseX, state.MouseY, p.Position.X, p.Position.Y, 236, 196) then
				el:_closePopup()
			end
		end
	end

	function el:_update(dt, cx, cy, cw, ch, scroll)
		local th = theme()
		if not el._visible then return end
		local y = cy + el.y - scroll
		if y + el.h < cy or y > cy + ch then
			el:_hideAll()
			return
		end
		local hov = hit(state.MouseX, state.MouseY, cx, y, cw, el.h)
		el._hoverT = ease(el._hoverT, (hov or el._open) and 1 or 0, dt, 14)

		local base = colorLerp(th.element, th.elementHover, el._hoverT)
		el._bg.Color = base
		el._bg.Corner = CORNER_EL
		el._bg.Outline = hov or el._open
		el._bg.Thickness = (hov or el._open) and 1 or 0
		setRect(el._bg, cx, y, cw, el.h)

		el._bar.Color = el._open and colorLerp(th.accent, th.accent2, 0.2) or (el._hoverT > 0.01 and th.accent or th.border)
		el._bar.Corner = 2
		setRect(el._bar, cx, y + 4, 3, el.h - 8)
		el._bar.Visible = true

		setText(el._title, el.Title or "", cx + 14, y + 12, 13, th.text, false, true)

		-- swatch with ring + checker frame
		local sx = cx + cw - 46
		local sy = y + (el.h - 20) / 2
		el._swatchFrame.Color = th.borderSoft
		el._swatchFrame.Corner = 5
		el._swatchFrame.Outline = true
		el._swatchFrame.Thickness = 1
		setRect(el._swatchFrame, sx - 3, sy - 3, 26, 26)
		el._swatchFrame.Visible = true

		el._swatch.Color = el.Value
		el._swatch.Corner = 4
		setRect(el._swatch, sx, sy, 20, 20)
		el._swatch.Transparency = el.alpha and clampN(el.alpha, 0, 0.9) or 0
		el._swatch.Visible = true

		el._swatchRing.Color = th.swatchBorder
		el._swatchRing.Corner = 4
		el._swatchRing.Outline = true
		el._swatchRing.Filled = false
		el._swatchRing.Thickness = (hov or el._open) and 1 or 0
		setRect(el._swatchRing, sx, sy, 20, 20)
		el._swatchRing.Visible = hov or el._open

		local hexFull = hexFromColor(el.Value, el.alpha and el.alpha > 0 and el.alpha or nil)
		setText(el._valueHex, hexFull, cx + cw - 74, y + 12, 12, th.text, false, true)

		if state.Click and hov then
			if el._open then
				el:_closePopup()
			else
				el._open = true
				el._justOpened = true
				el._editHex = false
				el._hexBuf = nil
				el._h, el._s, el._v = rgbToHsv(el.Value.R, el.Value.G, el.Value.B)
				allPopups[el] = true
				state.fullPoll = true
			end
		end
		if el._justOpened and not state.Click then
			el._justOpened = false
		end

		if el._open then
			local pw, ph = 236, 196
			local px = math.max(cx, 4)
			if px + pw > state.viewW then px = cx end
			local py = y + el.h + 4
			if py + ph > state.viewH then py = y - ph - 4 end
			if py < 0 then py = y + el.h + 4 end

			el._popShadow.Color = th.shadow
			el._popShadow.Transparency = 0.45
			el._popShadow.Corner = 12
			setRect(el._popShadow, px + 3, py + 3, pw, ph)
			el._popShadow.Visible = true

			el._popBg.Color = th.tab
			el._popBg.Corner = 12
			el._popBg.Transparency = visibleT(0)
			setRect(el._popBg, px, py, pw, ph)
			el._popBg.Visible = true

			el._popBorder.Color = colorLerp(th.border, th.activeRing, el._hoverT)
			el._popBorder.Corner = 12
			el._popBorder.Outline = true
			el._popBorder.Filled = false
			el._popBorder.Thickness = 1
			setRect(el._popBorder, px, py, pw, ph)
			el._popBorder.Visible = true

			local svX = px + 10
			local svY = py + 12
			local svSize = 104
			local cell = svSize / 9

			for i = 1, 9 do
				for j = 1, 9 do
					local sq = el._svGrid[i][j]
					local s = (i - 0.5) / 9
					local v = 1 - (j - 0.5) / 9
					local r, g, b = hsvToRgb(el._h, s, v)
					sq.Color = Color3.fromRGB(r * 255, g * 255, b * 255)
					setRect(sq, svX + (i - 1) * cell, svY + (j - 1) * cell, cell + 1, cell + 1)
					sq.Visible = true
				end
			end
			el._svCursor.Color = Color3.new(1, 1, 1)
			el._svCursor.Radius = 5
			el._svCursor.Outline = true
			el._svCursor.Position = Vector2.new(svX + el._s * svSize, svY + (1 - el._v) * svSize)
			el._svCursor.Visible = true

			local hx = px + 124
			local hy = py + 12
			local hw = 12
			local hh = svSize
			local hcell = hh / 8
			for i = 1, 8 do
				local hb = el._hueBar[i]
				local r, g, b = hsvToRgb((i - 0.5) / 8 * 360, 1, 1)
				hb.Color = Color3.fromRGB(r * 255, g * 255, b * 255)
				setRect(hb, hx, hy + (i - 1) * hcell, hw, hcell + 1)
				hb.Visible = true
			end
			el._hueCursor.Color = Color3.new(1, 1, 1)
			el._hueCursor.Corner = 2
			el._hueCursor.Outline = true
			el._hueCursor.Thickness = 1
			setRect(el._hueCursor, hx - 3, hy + (el._h / 360) * hh - 2, hw + 6, 3)
			el._hueCursor.Visible = true

			local ay = py + 12 + svSize + 14
			if el._hasAlpha then
				local ax = px + 10
				local acell = svSize / 8
				for i = 1, 8 do
					local ab = el._alphaBar[i]
					local base = el.Value
					local wh = (i - 0.5) / 8
					ab.Color = Color3.fromRGB(
						intRound(lerpN(base.R * 255, 0, 1 - wh)),
						intRound(lerpN(base.G * 255, 0, 1 - wh)),
						intRound(lerpN(base.B * 255, 0, 1 - wh))
					)
					setRect(ab, ax + (i - 1) * acell, ay, acell + 1, 9)
					ab.Visible = true
				end
				el._alphaCursor.Color = Color3.new(1, 1, 1)
				el._alphaCursor.Corner = 2
				el._alphaCursor.Outline = true
				el._alphaCursor.Thickness = 1
				setRect(el._alphaCursor, ax + clampN(el.alpha or 0, 0, 1) * svSize - 3, ay - 2, 6, 13)
				el._alphaCursor.Visible = true
				ay = ay + 22
			end

			setText(el._hexLab, "HEX", px + 10, ay + 1, 10, th.textFaint, false, true)
			el._hexBg.Color = th.field
			el._hexBg.Corner = CORNER_SM
			el._hexBg.Outline = el._editHex
			el._hexBg.Thickness = el._editHex and 1 or 0
			setRect(el._hexBg, px + 44, ay - 4, 122, 22)
			el._hexBg.Visible = true
			local hexStr = el._editHex and (el._hexBuf or "") or hexFromColor(el.Value, el.alpha and el.alpha > 0 and el.alpha or nil)
			setText(el._hexText, hexStr, px + 52, ay, 12, el._editHex and th.text or th.textDim, false, true)
			el._hexLab.Visible = true

			local by = py + ph - 28
			el._cancelBg.Color = th.elementPress
			el._cancelBg.Corner = CORNER_SM
			el._cancelBg.Outline = true
			el._cancelBg.Thickness = 1
			setRect(el._cancelBg, px + 10, by, (pw - 30) / 2, 20)
			el._cancelBg.Visible = true
			setText(el._cancelText, "Cancel", px + 10 + (pw - 30) / 4, by + 4, 11, th.textDim, true, true)
			el._doneBg.Color = colorLerp(th.accent, th.accent2, 0.15)
			el._doneBg.Corner = CORNER_SM
			setRect(el._doneBg, px + 10 + (pw - 30) / 2 + 10, by, (pw - 30) / 2, 20)
			el._doneBg.Visible = true
			setText(el._doneText, "Done", px + 10 + (pw - 30) / 2 + 10 + (pw - 30) / 4, by + 4, 11, th.titleBarText, true, true)

			local inSV = hit(state.MouseX, state.MouseY, svX, svY, svSize, svSize)
			local inHue = hit(state.MouseX, state.MouseY, hx, hy, hw, hh)
			local inAlpha = el._hasAlpha and hit(state.MouseX, state.MouseY, px + 10, py + 12 + svSize + 14, svSize, 9)
			local inCancel = hit(state.MouseX, state.MouseY, px + 10, by, (pw - 30) / 2, 20)
			local inDone = hit(state.MouseX, state.MouseY, px + 10 + (pw - 30) / 2 + 10, by, (pw - 30) / 2, 20)
			local inHex = hit(state.MouseX, state.MouseY, px + 44, ay - 4, 122, 22)

			if state.Click and inSV then el._dragSV = true end
			if state.Click and inHue then el._dragHue = true end
			if state.Click and inAlpha then el._dragAlpha = true end

			if el._dragSV and state.Lmb then
				el._s = clampN((state.MouseX - svX) / svSize, 0, 1)
				el._v = clampN(1 - (state.MouseY - svY) / svSize, 0, 1)
				el.Value = Color3.fromHSV(el._h / 360, el._s, el._v)
				if el.UpdateOnChange then emitNow() end
			end
			if el._dragHue and state.Lmb then
				el._h = clampN((state.MouseY - hy) / hh, 0, 1) * 360
				el.Value = Color3.fromHSV(el._h / 360, el._s, el._v)
				if el.UpdateOnChange then emitNow() end
			end
			if el._dragAlpha and state.Lmb then
				el.alpha = clampN((state.MouseX - (px + 10)) / svSize, 0, 1)
			end
			if not state.Lmb then
				el._dragSV = false
				el._dragHue = false
				el._dragAlpha = false
			end

			if state.Click and inCancel then
				el._h, el._s, el._v = rgbToHsv(el.Value.R, el.Value.G, el.Value.B)
				el:_closePopup()
			end
			if state.Click and inDone then
				emitNow()
				el:_closePopup()
			end
			if state.Click and inHex then
				el._editHex = true
				el._hexBuf = hexFromColor(el.Value, nil):sub(2)
				state.focusedEdit = el
				state.fullPoll = true
			end

			if el._editHex and el._hexBuf ~= nil then
				for _, ch in ipairs(state.typedChars) do
					if ch:match("[0-9a-fA-F]") and #el._hexBuf < 8 then
						el._hexBuf = el._hexBuf .. ch
					end
				end
				if keyJustPressed(0x08) then
					el._hexBuf = el._hexBuf:sub(1, -2)
				end
				if keyJustPressed(0x0D) then
					local c, a = colorFromHex(el._hexBuf)
					if c then
						el.Value = c
						if a then el.alpha = a end
						el._h, el._s, el._v = rgbToHsv(c.R, c.G, c.B)
						safeCallback(el.Callback, c, el.alpha)
						el:_emit(c, el.alpha)
					end
					el._editHex = false
					el._hexBuf = nil
					state.focusedEdit = nil
				elseif keyJustPressed(0x1B) then
					el._editHex = false
					el._hexBuf = nil
					state.focusedEdit = nil
				end
			end
		else
			el:_closePopup()
		end
	end

	addNode(tab, el)
	el._visible = true
	registerOption(el)
	return el
end

-- ============================================================
-- Input
-- ============================================================

local function createInput(tab, config)
	config = config or {}
	local el = setmetatable({
		Type = "Input",
		Id = config.Id or config.Flag,
		Title = config.Title,
		Callback = config.Callback,
		_ownerTab = tab,
		_visible = false,
		_hoverT = 0,
		Height = 48,
		Value = config.Default or "",
		Placeholder = config.Placeholder or "",
		Numeric = config.Numeric == true,
		Finished = config.Finished == true,
		MaxLength = config.MaxLength,
		ClearOnFocusLost = config.ClearOnFocusLost == true,
		_focused = false,
		_caret = 0,
	}, BaseHandle)

	el._bg = newSquare()
	el._bar = newSquare()
	el._title = newText(TEXT_FONT_BODY)
	el._field = newSquare()
	el._fieldBorder = newSquare()
	el._text = newText(TEXT_FONT_BODY)
	el._caretDraw = newSquare()

	function el:SetValue(t, fire)
		t = tostring(t or "")
		if el.Numeric then
			t = t:gsub("[^%d%-%.]", "")
		end
		if el.MaxLength and #t > el.MaxLength then
			t = t:sub(1, el.MaxLength)
		end
		if t ~= el.Value then
			el.Value = t
			if fire ~= false then
				safeCallback(el.Callback, t)
				el:_emit(t)
			end
		end
	end

	function el:_hideAll()
		el._bg.Visible = false
		el._bar.Visible = false
		el._title.Visible = false
		el._field.Visible = false
		el._fieldBorder.Visible = false
		el._text.Visible = false
		el._caretDraw.Visible = false
	end

	function el:_destroyDrawings()
		el._bg:Remove()
		el._bar:Remove()
		el._title:Remove()
		el._field:Remove()
		el._fieldBorder:Remove()
		el._text:Remove()
		el._caretDraw:Remove()
	end

	function el:_blur()
		el._focused = false
		if state.focusedInput == el then
			state.focusedInput = nil
			state.fullPoll = false
		end
		if el.Finished and el.ClearOnFocusLost then
			safeCallback(el.Callback, "")
		end
	end

	function el:_update(dt, cx, cy, cw, ch, scroll)
		local th = theme()
		if not el._visible then return end
		local y = cy + el.y - scroll
		if y + el.h < cy or y > cy + ch then
			el:_hideAll()
			return
		end
		local hov = hit(state.MouseX, state.MouseY, cx, y, cw, el.h)
		el._hoverT = ease(el._hoverT, (hov or el._focused) and 1 or 0, dt, 14)

		local base = colorLerp(th.element, th.elementHover, el._hoverT)
		el._bg.Color = base
		el._bg.Corner = CORNER_EL
		setRect(el._bg, cx, y, cw, el.h)

		el._bar.Color = el._focused and colorLerp(th.accent, th.accent2, 0.2) or (el._hoverT > 0.01 and th.accent or th.border)
		el._bar.Corner = 2
		setRect(el._bar, cx, y + 4, 3, el.h - 8)
		el._bar.Visible = true

		setText(el._title, el.Title or "", cx + 14, y + 6, 13, th.text, false, true)

		local fx = cx + 14
		local fy = y + 26
		local fw = cw - 28
		local fh = 18
		el._field.Color = el._focused and th.fieldHover or (hov and th.fieldHover or th.field)
		el._field.Corner = CORNER_SM
		setRect(el._field, fx, fy, fw, fh)
		el._field.Visible = true

		el._fieldBorder.Color = el._focused and colorLerp(th.accent, th.accent2, 0.2) or (hov and th.border or th.borderSoft)
		el._fieldBorder.Corner = CORNER_SM
		el._fieldBorder.Outline = true
		el._fieldBorder.Filled = false
		el._fieldBorder.Thickness = 1
		setRect(el._fieldBorder, fx, fy, fw, fh)
		el._fieldBorder.Visible = true

		local disp = el.Value
		if #disp == 0 then
			setText(el._text, el.Placeholder, fx + 6, fy + 2, 12, th.textFaint, false, true)
			el._caretDraw.Visible = false
		else
			el._caret = clampN(el._caret, 0, #disp)
			local deadW = textW(disp:sub(1, el._caret), 12)
			local avail = math.max(fw - 14, 0)
			local xoff = fx + 6
			if deadW > avail then
				xoff = fx + 6 - (deadW - avail)
			end
			setText(el._text, disp, xoff, fy + 2, 12, th.text, false, true)

			if el._focused then
				local caretX = fx + 6 + textW(disp:sub(1, el._caret), 12)
				el._caretDraw.Color = th.accent
				setRect(el._caretDraw, caretX, fy + 3, 1, 12)
				el._caretDraw.Visible = (tick() * 2) % 1 < 0.6
			else
				el._caretDraw.Visible = false
			end
		end

		if state.Click then
			if hit(state.MouseX, state.MouseY, fx, fy, fw, fh) then
				if not el._focused then
					el._focused = true
					el._caret = #el.Value
					state.focusedInput = el
					state.fullPoll = true
				end
				local rx = clampN(state.MouseX - fx, 0, #el.Value)
				local pos = #el.Value
				for i = 0, #el.Value do
					if textW(el.Value:sub(1, i), 12) > rx then
						pos = i
						break
					end
				end
				el._caret = pos
			else
				if el._focused then el:_blur() end
			end
		end

		if el._focused then
			for _, ch in ipairs(state.typedChars) do
				if not (el.Numeric and not (ch == "-" or ch == "." or (ch >= "0" and ch <= "9"))) then
					local before = el.Value
					local newS = before:sub(1, el._caret) .. ch .. before:sub(el._caret + 1)
					el:SetValue(newS, not el.Finished)
					el._caret = el._caret + 1
				end
			end
			if keyJustPressed(0x08) then
				if el._caret > 0 then
					local before = el.Value
					el:SetValue(before:sub(1, el._caret - 1) .. before:sub(el._caret + 1), not el.Finished)
					el._caret = el._caret - 1
				end
			end
			if keyJustPressed(0x2E) then
				local before = el.Value
				if el._caret < #before then
					el:SetValue(before:sub(1, el._caret) .. before:sub(el._caret + 2), not el.Finished)
				end
			end
			if keyJustPressed(0x25) then el._caret = math.max(el._caret - 1, 0) end
			if keyJustPressed(0x27) then el._caret = math.min(el._caret + 1, #el.Value) end
			if keyJustPressed(0x24) then el._caret = 0 end
			if keyJustPressed(0x23) then el._caret = #el.Value end
			if keyJustPressed(0x0D) then
				if el.Finished then
					safeCallback(el.Callback, el.Value)
					el:_emit(el.Value)
				end
				if el.Finished then el:_blur() end
			end
			if keyJustPressed(0x1B) then el:_blur() end
		end
	end

	addNode(tab, el)
	el._visible = true
	registerOption(el)
	return el
end

-- ============================================================
-- Paragraph
-- ============================================================

local function createParagraph(tab, config)
	config = config or {}
	local el = setmetatable({
		Type = "Paragraph",
		Title = config.Title,
		Content = config.Content or "",
		TitleAlignment = config.TitleAlignment or "Left",
		ContentAlignment = config.ContentAlignment or "Left",
		_ownerTab = tab,
		_visible = false,
		Value = nil,
	}, BaseHandle)

	el.HeightFn = function()
		local n = 0
		for _ in string.gmatch(el.Content or "", "\n") do n = n + 1 end
		if #(el.Content or "") > 0 then n = n + 1 end
		if n == 0 then return 16 end
		return 14 + n * 16
	end

	el._accent = newSquare()
	el._title = newText(TEXT_FONT_TITLE)
	el._lines = {}
	for i = 1, 6 do
		el._lines[i] = newText(TEXT_FONT_BODY)
	end

	function el:SetContent(text)
		el.Content = text
		layoutTab(el._ownerTab)
		safeCallback(el.Callback, text)
		el:_emit(text)
	end
	el.SetValue = el.SetContent

	function el:_hideAll()
		el._accent.Visible = false
		el._title.Visible = false
		for _, d in ipairs(el._lines) do d.Visible = false end
	end

	function el:_destroyDrawings()
		el._accent:Remove()
		el._title:Remove()
		for _, d in ipairs(el._lines) do d:Remove() end
	end

	function el:_update(dt, cx, cy, cw, ch, scroll)
		local th = theme()
		if not el._visible then return end
		local y = cy + el.y - scroll
		if y + el.h < cy or y > cy + ch then
			el:_hideAll()
			return
		end
		local function alignX(w, mode)
			if mode == "Center" then return cx + (cw - w) / 2
			elseif mode == "Right" then return cx + cw - w
			else return cx end
		end
		if el.Title and #el.Title > 0 then
			el._accent.Color = colorLerp(th.accent, th.accent2, 0.2)
			el._accent.Corner = 2
			setRect(el._accent, cx, y + 4, 3, 12)
			el._accent.Visible = true
			setText(el._title, el.Title, cx + 10, y, 13, th.text, false, true)
		else
			el._accent.Visible = false
			el._title.Visible = false
		end
		local ly = y + 22
		local i = 1
		local content = el.Content or ""
		for line in string.gmatch(content, "[^\n]*") do
			if i > 6 then break end
			if #line > 0 then
				setText(el._lines[i], line, cx + 10, ly, 12, th.textDim, false, true)
				ly = ly + 16
				i = i + 1
			end
		end
		for j = i, 6 do
			el._lines[j].Visible = false
		end
	end

	addNode(tab, el)
	el._visible = true
	return el
end

-- ============================================================
-- Keybind
-- ============================================================

local function createKeybind(tab, config)
	config = config or {}
	local el = setmetatable({
		Type = "Keybind",
		Id = config.Id or config.Flag,
		Title = config.Title,
		Callback = config.Callback,
		_ownerTab = tab,
		_visible = false,
		_hoverT = 0,
		Height = 38,
		mode = config.Mode or "Toggle",
		toggled = false,
		_listening = false,
		Value = config.Default,
	}, BaseHandle)

	if el.Value ~= nil then
		local vk = vkFromName(el.Value)
		if vk then boundVks[vk] = true end
	end

	el._bg = newSquare()
	el._bar = newSquare()
	el._title = newText(TEXT_FONT_BODY)
	el._field = newSquare()
	el._fieldBorder = newSquare()
	el._fieldText = newText(TEXT_FONT_BODY)
	el._dot = newCircle()

	local function keyLabel()
		if el._listening then return "Listening..." end
		if el.Value == nil then return "Unbound" end
		return tostring(el.Value)
	end

	function el:SetValue(key, mode)
		if el.Value ~= nil then
			local ovk = vkFromName(el.Value)
			if ovk then boundVks[ovk] = nil end
		end
		if mode then el.mode = mode end
		if type(key) == "number" then
			key = VK_BY_NAME[key] or nil
		end
		el.Value = key
		if el.Value ~= nil then
			local vk = vkFromName(el.Value)
			if vk then boundVks[vk] = true end
		end
		safeCallback(config.ChangedCallback, key)
		el:_emit(key)
	end

	function el:DoClick()
		el.toggled = not el.toggled
		safeCallback(el.Callback, el:GetState())
	end

	function el:GetState()
		if el.mode == "Always" then return true end
		if el.mode == "Hold" then
			if el.Value == nil then return false end
			local vk = vkFromName(el.Value)
			if vk then return keyDown(vk) end
			return false
		end
		return el.toggled
	end

	function el:_hideAll()
		el._bg.Visible = false
		el._bar.Visible = false
		el._title.Visible = false
		el._field.Visible = false
		el._fieldBorder.Visible = false
		el._fieldText.Visible = false
		el._dot.Visible = false
	end

	function el:_destroyDrawings()
		el._bg:Remove()
		el._bar:Remove()
		el._title:Remove()
		el._field:Remove()
		el._fieldBorder:Remove()
		el._fieldText:Remove()
		el._dot:Remove()
	end

	function el:_update(dt, cx, cy, cw, ch, scroll)
		local th = theme()
		if not el._visible then return end
		local y = cy + el.y - scroll
		if y + el.h < cy or y > cy + ch then
			el:_hideAll()
			return
		end
		local hov = hit(state.MouseX, state.MouseY, cx, y, cw, el.h)
		el._hoverT = ease(el._hoverT, (hov or el._listening) and 1 or 0, dt, 14)

		local base = colorLerp(th.element, th.elementHover, el._hoverT)
		el._bg.Color = base
		el._bg.Corner = CORNER_EL
		el._bg.Outline = hov or el._listening
		el._bg.Thickness = (hov or el._listening) and 1 or 0
		setRect(el._bg, cx, y, cw, el.h)

		el._bar.Color = el._listening and colorLerp(th.accent, th.accent2, 0.2) or (el._hoverT > 0.01 and th.accent or th.border)
		el._bar.Corner = 2
		setRect(el._bar, cx, y + 4, 3, el.h - 8)
		el._bar.Visible = true

		setText(el._title, el.Title or "", cx + 14, y + 12, 13, th.text, false, true)

		-- mode dot
		el._dot.Color = el.mode == "Hold" and th.warning or el.mode == "Always" and th.success or th.accent
		el._dot.Radius = 3
		el._dot.Position = Vector2.new(cx + 12, y + 28)
		el._dot.Visible = el.mode ~= "Toggle"

		local fx = cx + cw - 98
		local fy = y + 8
		local fw = 84
		el._field.Color = el._listening and colorLerp(th.accent, th.accent2, 0.25) or (hov and th.fieldHover or th.field)
		el._field.Corner = CORNER_SM
		setRect(el._field, fx, fy, fw, 22)
		el._field.Visible = true

		el._fieldBorder.Color = el._listening and th.activeRing or th.borderSoft
		el._fieldBorder.Corner = CORNER_SM
		el._fieldBorder.Outline = true
		el._fieldBorder.Filled = false
		el._fieldBorder.Thickness = 1
		setRect(el._fieldBorder, fx, fy, fw, 22)
		el._fieldBorder.Visible = true

		setText(el._fieldText, keyLabel(), fx + fw / 2, fy + 4, 12, el._listening and th.titleBarText or th.text, true, true)

		if state.Click and hov then
			el._listening = true
			state.fullPoll = true
			state.listeningKeybind = el
		end

		if el._listening then
			for _, code in ipairs(BASE_POLL) do
				if keyJustPressed(code) and not (code == 0x10 or code == 0x11) then
					if code == 0x1B then
						el._listening = false
						state.fullPoll = false
						state.listeningKeybind = nil
						break
					end
					if code == 0x2E then
						el:SetValue(nil)
						el._listening = false
						state.fullPoll = false
						state.listeningKeybind = nil
						break
					end
					local name = VK_BY_NAME[code] or tostring(code)
					el:SetValue(name)
					el._listening = false
					state.fullPoll = false
					state.listeningKeybind = nil
					break
				end
			end
			for _, code in ipairs(ALPHA_POLL) do
				if keyJustPressed(code) then
					local name = VK_BY_NAME[code] or tostring(code)
					el:SetValue(name)
					el._listening = false
					state.fullPoll = false
					state.listeningKeybind = nil
					break
				end
			end
			if not state.Lmb and keyDown(0x01) then end
		end
	end

	addNode(tab, el)
	el._visible = true
	registerOption(el)
	return el
end

-- ============================================================
-- Tab / Section
-- ============================================================

local Section = {}
Section.__index = Section

function Section:AddButton(c) return self.__tab:_add("Button", c) end
function Section:AddToggle(c) return self.__tab:_add("Toggle", c) end
function Section:AddSlider(c) return self.__tab:_add("Slider", c) end
function Section:AddDropdown(c) return self.__tab:_add("Dropdown", c) end
function Section:AddColorpicker(c) return self.__tab:_add("Colorpicker", c) end
function Section:AddInput(c) return self.__tab:_add("Input", c) end
function Section:AddParagraph(c) return self.__tab:_add("Paragraph", c) end
function Section:AddKeybind(c) return self.__tab:_add("Keybind", c) end
function Section:AddSection(name)
	local sec = setmetatable({ Title = name, __tab = self.__tab }, Section)
	table.insert(self.__tab.nodes, { kind = "section", section = sec })
	layoutTab(self.__tab)
	return sec
end

local Tab = {}
Tab.__index = Tab

function Tab:_add(kind, config)
	if kind == "Button" then return createButton(self, config)
	elseif kind == "Toggle" then return createToggle(self, config)
	elseif kind == "Slider" then return createSlider(self, config)
	elseif kind == "Dropdown" then return createDropdown(self, config)
	elseif kind == "Colorpicker" then return createColorpicker(self, config)
	elseif kind == "Input" then return createInput(self, config)
	elseif kind == "Paragraph" then return createParagraph(self, config)
	elseif kind == "Keybind" then return createKeybind(self, config) end
end

function Tab:AddButton(c) return self:_add("Button", c) end
function Tab:AddToggle(c) return self:_add("Toggle", c) end
function Tab:AddSlider(c) return self:_add("Slider", c) end
function Tab:AddDropdown(c) return self:_add("Dropdown", c) end
function Tab:AddColorpicker(c) return self:_add("Colorpicker", c) end
function Tab:AddInput(c) return self:_add("Input", c) end
function Tab:AddParagraph(c) return self:_add("Paragraph", c) end
function Tab:AddKeybind(c) return self:_add("Keybind", c) end

function Tab:AddSection(name)
	local sec = setmetatable({ Title = name, __tab = self }, Section)
	table.insert(self.nodes, { kind = "section", section = sec })
	layoutTab(self)
	return sec
end

function Tab:_removeNode(element)
	removeNode(self, element)
end

-- ============================================================
-- Window
-- ============================================================

local winViewW = 1920
local winViewH = 1080

local Win = {}
Win.__index = Win

local function buildWindow(config)
	local w = {
		Title = config.Title,
		SubTitle = config.SubTitle,
		x = math.floor((winViewW - config.Size.X) / 2),
		y = math.floor((winViewH - config.Size.Y) / 2),
		w = config.Size.X,
		h = config.Size.Y,
		minW = config.MinSize.X,
		minH = config.MinSize.Y,
		TabWidth = config.TabWidth,
		minimized = false,
		maximized = false,
		dragging = false,
		resizing = false,
		alive = true,
		winAlpha = 0,
		Tabs = {},
		SelectedTab = nil,
		scroll = 0,
		MinimizeKey = config.MinimizeKey,
		_lastSelected = nil,
		_scrollDrag = false,
		lastTitleClick = 0,
	}
	return setmetatable(w, Win)
end

function Win:AddTab(arg)
	local name, icon
	if type(arg) == "table" then
		name = arg.Title or arg.Name or "Tab"
		icon = arg.Icon
	else
		name = arg or "Tab"
	end
	local tab = setmetatable({
		Title = name,
		Icon = icon,
		nodes = {},
		scroll = 0,
		contentH = 0,
		chrome = nil,
	}, Tab)
	table.insert(self.Tabs, tab)
	if not self.SelectedTab then
		self.SelectedTab = tab
		self._lastSelected = tab
	end
	layoutTab(tab)
	return tab
end

local function computeContentRect()
	local topH = TITLE_H + ACCENT_H
	local cx = win.x + win.TabWidth
	local cy = win.y + topH
	local cw = math.max(win.w - win.TabWidth, 60)
	local ch = math.max(win.h - topH, 40)
	return cx, cy, cw, ch
end

local function equalTab(a, b)
	return a == b
end

local function renderWindow(dt)
	local th = theme()
	if not win or not win.alive then return end

	win.winAlpha = ease(win.winAlpha, 1, dt, 8)

	local x, y, w, h = win.x, win.y, win.w, win.h
	local viewW = state.viewW
	local viewH = state.viewH

	if win.maximized then
		x, y, w, h = 1, 1, viewW - 2, viewH - 2
	end
	if win.minimized then
		h = TITLE_H + ACCENT_H + 6
	end

	local a = win.winAlpha

	-- drop shadow layers
	local shA = 0.22 * a
	chrome.shadow1.Color = th.shadow
	chrome.shadow1.Transparency = shA
	chrome.shadow1.Corner = CORNER_WIN + 4
	setRect(chrome.shadow1, x + 8, y + 10, w, h)
	chrome.shadow1.Visible = not win.minimized

	chrome.shadow2.Color = th.shadow
	chrome.shadow2.Transparency = shA * 0.6
	chrome.shadow2.Corner = CORNER_WIN + 3
	setRect(chrome.shadow2, x + 5, y + 6, w, h)
	chrome.shadow2.Visible = not win.minimized

	chrome.shadow3.Color = th.bgAlt
	chrome.shadow3.Transparency = visibleT(0)
	chrome.shadow3.Corner = CORNER_WIN + 2
	setRect(chrome.shadow3, x + 2, y + 3, w, h)
	chrome.shadow3.Visible = false

	-- main window surface
	chrome.bg.Color = th.bg
	chrome.bg.Corner = CORNER_WIN
	chrome.bg.Transparency = visibleT(0)
	chrome.bg.Outline = true
	chrome.bg.Thickness = 1
	chrome.bg.Color = th.bg
	setRect(chrome.bg, x, y, w, h)
	chrome.bg.Visible = true

	-- outer border
	chrome.frame.Color = colorLerp(th.border, th.activeRing, 0.25)
	chrome.frame.Corner = CORNER_WIN
	chrome.frame.Outline = true
	chrome.frame.Filled = false
	chrome.frame.Thickness = 1
	setRect(chrome.frame, x, y, w, h)
	chrome.frame.Visible = true

	-- top accent gradient strip (three overlapping bars for gradient feel)
	local ga = win.winAlpha
	chrome.accentA.Color = th.accent
	chrome.accentA.Corner = 2
	chrome.accentA.Transparency = visibleT(0)
	setRect(chrome.accentA, x + 12, y + ACCENT_H, w - 24, 2)
	chrome.accentA.Visible = not win.minimized

	chrome.accentB.Color = th.accent2
	chrome.accentB.Corner = 2
	chrome.accentB.Transparency = visibleT(0.15)
	setRect(chrome.accentB, x + 12, y + ACCENT_H, (w - 24) * 0.7, 2)
	chrome.accentB.Visible = not win.minimized

	chrome.accentC.Color = th.accent3
	chrome.accentC.Corner = 2
	chrome.accentC.Transparency = visibleT(0.3)
	setRect(chrome.accentC, x + 12, y + ACCENT_H, (w - 24) * 0.4, 2)
	chrome.accentC.Visible = not win.minimized

	-- title bar surface
	chrome.title.Color = th.title
	chrome.title.Transparency = visibleT(0.02)
	chrome.title.Corner = CORNER_WIN
	chrome.title.Corner = math.max(CORNER_WIN - 2, 8)
	setRect(chrome.title, x + 1, y + ACCENT_H + 1, w - 2, TITLE_H + 2)
	chrome.title.Visible = true

	local titleY = win.SubTitle and 7 or 13
	setGradientText(chrome.titleText, chrome.titleText2, win.Title, x + 16, y + ACCENT_H + titleY, 15,
		th.titleBarText, colorLerp(th.titleBarText, th.accent, 0.55), false, true)
	if win.SubTitle then
		setText(chrome.subText, win.SubTitle, x + 16, y + ACCENT_H + 26, 11, th.titleBarSub, false, true)
	else
		chrome.subText.Visible = false
	end

	-- app icon square on title bar
	chrome.iconBg.Color = colorLerp(th.accent, th.accent2, 0.3)
	chrome.iconBg.Corner = 5
	chrome.iconBg.Outline = true
	chrome.iconBg.Thickness = 1
	setRect(chrome.iconBg, x + 16, y + ACCENT_H + 11, 22, 22)
	chrome.iconBg.Visible = true
	chrome.iconText.Text = "N"
	setText(chrome.iconText, "N", x + 27, y + ACCENT_H + 14, 13, th.titleBarText, true, true)
	if win.SubTitle then
		setGradientText(chrome.titleText, chrome.titleText2, win.Title, x + 48, y + ACCENT_H + 7, 15,
			th.titleBarText, colorLerp(th.titleBarText, th.accent, 0.55), false, true)
	else
		setGradientText(chrome.titleText, chrome.titleText2, win.Title, x + 48, y + ACCENT_H + 13, 15,
			th.titleBarText, colorLerp(th.titleBarText, th.accent, 0.55), false, true)
	end

	-- window control buttons (rounded pills)
	local btnW = 26
	local btnH = 22
	local by = y + ACCENT_H + 10
	local bxClose = x + w - btnW - 10
	local bxMax = bxClose - btnW - 6
	local bxMin = bxMax - btnW - 6

	local closeHovD = hit(state.MouseX, state.MouseY, bxClose, by, btnW, btnH)
	local maxHovD = hit(state.MouseX, state.MouseY, bxMax, by, btnW, btnH)
	local minHovD = hit(state.MouseX, state.MouseY, bxMin, by, btnW, btnH)

	chrome.closeBg.Color = closeHovD and th.danger or th.bgAlt
	chrome.closeBg.Corner = 6
	chrome.closeBg.Outline = closeHovD
	chrome.closeBg.Thickness = 1
	setRect(chrome.closeBg, bxClose, by, btnW, btnH)
	setText(chrome.closeText, closeHovD and "x" or "x", bxClose + btnW / 2, by + 4, 12, closeHovD and Color3.new(1, 1, 1) or th.textDim, true, true)

	chrome.maxBg.Color = maxHovD and th.elementHover or th.bgAlt
	chrome.maxBg.Corner = 6
	chrome.maxBg.Outline = maxHovD
	chrome.maxBg.Thickness = 1
	setRect(chrome.maxBg, bxMax, by, btnW, btnH)
	setText(chrome.maxText, win.maximized and "x" or "+", bxMax + btnW / 2, by + 4, 12, maxHovD and th.text or th.textDim, true, true)

	chrome.minBg.Color = minHovD and th.elementHover or th.bgAlt
	chrome.minBg.Corner = 6
	chrome.minBg.Outline = minHovD
	chrome.minBg.Thickness = 1
	setRect(chrome.minBg, bxMin, by, btnW, btnH)
	setText(chrome.minText, "-", bxMin + btnW / 2, by + 4, 12, minHovD and th.text or th.textDim, true, true)

	local titleDrag = hit(state.MouseX, state.MouseY, x + 2, y + ACCENT_H, w - 4, TITLE_H - ACCENT_H)
		and not closeHovD and not maxHovD and not minHovD

	if state.Click then
		if closeHovD then
			Nebula:Destroy()
		elseif minHovD then
			Nebula:Minimize()
		elseif maxHovD then
			Nebula:Maximize()
		elseif titleDrag then
			local now = tick()
			if now - win.lastTitleClick < 0.3 then
				Nebula:Maximize(not win.maximized)
				win.lastTitleClick = 0
			else
				win.lastTitleClick = now
			end
			win.dragging = true
			win.dragOffX = state.MouseX - win.x
			win.dragOffY = state.MouseY - win.y
		end
		local grip = 14
		if not win.maximized and not win.minimized
			and hit(state.MouseX, state.MouseY, x + w - grip, y + h - grip, grip, grip) then
			win.resizing = true
			win.resizeOffX = state.MouseX - win.w
			win.resizeOffY = state.MouseY - win.h
		end
	end

	if not state.Lmb then
		win.dragging = false
		win.resizing = false
	end

	if win.dragging then
		win.x = clampN(state.MouseX - win.dragOffX, -w + 120, viewW - 60)
		win.y = clampN(state.MouseY - win.dragOffY, 0, viewH - 40)
	end

	if win.resizing then
		win.w = clampN(state.MouseX - win.resizeOffX, win.minW, viewW)
		win.h = clampN(state.MouseY - win.resizeOffY, win.minH, viewH)
	end

	if win.minimized then
		chrome.shadow1.Visible = false
		chrome.shadow2.Visible = false
		chrome.frame.Visible = false
		chrome.tabBg.Visible = false
		chrome.contentBg.Visible = false
		chrome.divider.Visible = false
		chrome.resizeGrip.Visible = false
		chrome.scrollBg.Visible = false
		chrome.scrollThumb.Visible = false
		win.dragging = false
		win.resizing = false
		win._scrollDrag = false
		chrome.iconBg.Visible = true
		for _, t in ipairs(win.Tabs) do
			if t.chrome then
				t.chrome.bg.Visible = false
				t.chrome.text.Visible = false
				t.chrome.pill.Visible = false
				t.chrome.color.Visible = false
				t.chrome.underline.Visible = false
				t.chrome.shadow.Visible = false
				t.chrome.icon.Visible = false
			end
			for _, node in ipairs(t.nodes) do
				if node.kind == "element" then
					node.element:_hideAll()
				end
			end
		end
		return
	end

	local cx, cy, cw, ch = computeContentRect()

	chrome.tabBg.Color = th.tab
	chrome.tabBg.Corner = 6
	chrome.tabBg.Transparency = visibleT(0)
	setRect(chrome.tabBg, x + 1, y + TITLE_H + ACCENT_H, win.TabWidth - 1, ch)
	chrome.tabBg.Visible = true

	chrome.contentBg.Color = th.content
	chrome.contentBg.Corner = 6
	chrome.contentBg.Transparency = visibleT(0)
	setRect(chrome.contentBg, cx, cy, cw, ch)
	chrome.contentBg.Visible = true

	chrome.divider.Color = th.border
	setRect(chrome.divider, x + win.TabWidth - 1, y + TITLE_H + ACCENT_H, 1, ch)
	chrome.divider.Transparency = visibleT(0)
	chrome.divider.Visible = true

	chrome.resizeGrip.From = Vector2.new(x + w - 6, y + h - 14)
	chrome.resizeGrip.To = Vector2.new(x + w - 14, y + h - 6)
	chrome.resizeGrip.Color = th.textFaint
	chrome.resizeGrip.Thickness = 2
	chrome.resizeGrip.Visible = not win.maximized and not win.minimized

	-- tabs
	for i, t in ipairs(win.Tabs) do
		local bxx = x + 10
		local bh = 32
		local byy = y + TITLE_H + ACCENT_H + 8 + (i - 1) * (bh + 5)
		local active = t == win.SelectedTab
		local hovT = hit(state.MouseX, state.MouseY, bxx, byy, win.TabWidth - 24, bh)
		if not t.chrome then
			t.chrome = {}
			t.chrome.shadow = newSquare()
			t.chrome.bg = newSquare()
			t.chrome.pill = newSquare()
t.chrome.text = newText(TEXT_FONT_TITLE)
		t.chrome.icon = newText(TEXT_FONT_BODY)
		t.chrome.color = newSquare()
		t.chrome.underline = newSquare()
		t.chrome._anim = active and 1 or 0
		end
		local tc = t.chrome
		local target = active and 1 or (hovT and 0.4 or 0)
		tc._anim = ease(tc._anim, target, dt, 16)

		local c = tc._anim
		local bgColor = colorLerp(th.tab, th.tabHover, c)
		if active then
			bgColor = colorLerp(th.tab, th.tabActive, c)
		end

		-- active pill indicator behind tab (glows)
		if active or c > 0.01 then
			tc.pill.Color = colorLerp(th.tabHover, th.tabActive, c)
			tc.pill.Corner = 8
			tc.pill.Transparency = visibleT(0)
			tc.pill.Outline = active
			tc.pill.Thickness = 1
			setRect(tc.pill, bxx, byy, win.TabWidth - 24, bh)
			tc.pill.Visible = true
		else
			tc.pill.Visible = false
		end

		tc.bg.Color = bgColor
		tc.bg.Corner = 8
		setRect(tc.bg, bxx, byy, win.TabWidth - 24, bh)
		tc.bg.Visible = true

		tc.shadow.Color = th.shadow
		tc.shadow.Transparency = active and 0.35 or 0
		tc.shadow.Corner = 10
		setRect(tc.shadow, bxx + 2, byy + 2, win.TabWidth - 24, bh)
		tc.shadow.Visible = active

		local label = t.Title or "Tab"
		local icon = t.Icon or ""
		tc.icon.Text = icon
		tc.icon.Color = active and th.accent or (c > 0.2 and th.text or th.textDim)
		tc.icon.Position = Vector2.new(bxx + 13, byy + 9)
		tc.icon.Size = 13
		tc.icon.Visible = #icon > 0

		setText(tc.text, label, bxx + (icon ~= "" and 30 or 14), byy + 9, 13,
			active and th.accent or (c > 0.2 and th.text or th.textDim), false, true)
		tc.color.Color = colorLerp(th.accent, th.accent2, 0.2)
		tc.color.Corner = 3
		tc.color.Transparency = visibleT(0)
		setRect(tc.color, bxx + 4, byy + 6 + (1 - c) * 8, 3, 20 * c)
		tc.color.Visible = c > 0.05

		if state.Click and hovT then
			win.SelectedTab = t
			t.scroll = 0
		end
	end

	local sel = win.SelectedTab
	if not sel then return end
	if sel ~= win._lastSelected then
		if win._lastSelected then
			for _, node in ipairs(win._lastSelected.nodes) do
				if node.kind == "element" then
					node.element:_hideAll()
				end
			end
		end
		win._lastSelected = sel
	end

	layoutTab(sel)

	local maxScroll = math.max(0, sel.contentH - ch + 10)
	sel.scroll = clampN(sel.scroll, 0, maxScroll)

	local scrollX = cx + cw - SCROLLBAR_W - 2
	local scrollY = cy + 4
	local scrollH = ch - 8

	if maxScroll > 0 then
		local thumbHpx = math.max(scrollH * (ch / sel.contentH), 24)
		local thumbY = scrollY + (scrollH - thumbHpx) * (sel.scroll / maxScroll)

		chrome.scrollBg.Color = th.elementPress
		chrome.scrollBg.Corner = 2
		setRect(chrome.scrollBg, scrollX, scrollY, SCROLLBAR_W, scrollH)
		chrome.scrollBg.Transparency = visibleT(0)
		chrome.scrollBg.Visible = true

		local thumbHovD = hit(state.MouseX, state.MouseY, scrollX - 2, thumbY, SCROLLBAR_W + 4, thumbHpx)
		chrome.scrollThumb.Color = thumbHovD and th.scrollHover or th.scroll
		chrome.scrollThumb.Corner = 2
		setRect(chrome.scrollThumb, scrollX, thumbY, SCROLLBAR_W, thumbHpx)
		chrome.scrollThumb.Visible = true

		if state.Click and hit(state.MouseX, state.MouseY, scrollX - 4, scrollY, SCROLLBAR_W + 8, scrollH) then
			win._scrollDrag = true
			win._scrollOff = state.MouseY - thumbY
		end
		if win._scrollDrag then
			local rel = state.MouseY - scrollY - win._scrollOff
			sel.scroll = (rel / math.max(scrollH - thumbHpx, 1)) * maxScroll
			sel.scroll = clampN(sel.scroll, 0, maxScroll)
		end
		if not state.Lmb then win._scrollDrag = false end
	else
		chrome.scrollBg.Visible = false
		chrome.scrollThumb.Visible = false
	end

	if keyJustPressed(0x21) then sel.scroll = math.max(sel.scroll - ch * 0.8, 0) end
	if keyJustPressed(0x22) then sel.scroll = math.min(sel.scroll + ch * 0.8, maxScroll) end

	local elemPadTop = 8
	local elemW = cw - CONTENT_PAD_X * 2 - (maxScroll > 0 and (SCROLLBAR_W + 10) or 0)
	local elemX = cx + CONTENT_PAD_X

	for _, node in ipairs(sel.nodes) do
		if node.kind == "section" then
			local sec = node.section
			if not sec.isRoot then
				if not sec.text then
					sec.text = newText(TEXT_FONT_TITLE)
					sec.text2 = newText(TEXT_FONT_TITLE)
					sec.line = newSquare()
					sec.dot = newSquare()
				end
				local sy = cy + sec.y - sel.scroll + 6
				local vis = sy > cy - 20 and sy < cy + ch
				local headText = (sec.Title or ""):upper()
				setGradientText(sec.text, sec.text2, headText, elemX + 14, sy, 11,
					colorLerp(th.accent, th.text, 0.35), colorLerp(th.accent2, th.text, 0.25), false, vis and true or false)
				sec.line.Color = th.border
				sec.line.Corner = 1
				setRect(sec.line, elemX + 14 + textW(headText, 11) + 12, sy + 7, cw - (14 + textW(headText, 11) + 12) - 16, 1)
				sec.line.Transparency = visibleT(0)
				sec.line.Visible = vis
				sec.dot.Color = colorLerp(th.accent, th.accent2, 0.2)
				sec.dot.Corner = 2
				setRect(sec.dot, elemX + 4, sy + 2, 4, 8)
				sec.dot.Visible = vis
			end
		else
			local el = node.element
			if el._visible then
				el:_update(dt, elemX, cy + elemPadTop, elemW, ch - 8, sel.scroll)
			end
		end
	end
end

local function handleKeybinds()
	if state.focusedInput or state.focusedEdit or state.listeningKeybind then return end
	if not win then return end
	if currentDialog then return end
	for _, t in ipairs(win.Tabs) do
		for _, node in ipairs(t.nodes) do
			local el = node.element
			if node.kind == "element" and el then
				local vk = vkFromName(el.Value)
				if el.Type == "Toggle" and el.Keybind and vk and keyJustPressed(vk) then
					el:SetValue(not el.Value, true)
				elseif el.Type == "Keybind" and not el._listening and vk and keyJustPressed(vk) then
					if el.mode == "Toggle" then
						el.toggled = not el.toggled
						safeCallback(el.Callback, el:GetState())
					elseif el.mode == "Hold" then
						safeCallback(el.Callback, true)
					end
				end
			end
		end
	end
end

-- ============================================================
-- Notifications
-- ============================================================

local notifSlots = 5
local notifPool = {}
local notifActive = {}

local NOTIF_W = 300
local NOTIF_PAD = 12

for i = 1, notifSlots do
	notifPool[i] = {
		shadow = newSquare(),
		bg = newSquare(),
		border = newSquare(),
		accent = newSquare(),
		title = newText(TEXT_FONT_TITLE),
		content = newText(TEXT_FONT_BODY),
		close = newText(TEXT_FONT_BODY),
		inUse = false,
	}
end

function Nebula:Notify(config)
	config = config or {}
	local slot = nil
	for i, s in ipairs(notifPool) do
		if not s.inUse then
			slot = s
			break
		end
	end
	if not slot then return nil end
	local kind = config.Type
	local n = {
		title = config.Title or "",
		content = config.Content or config.SubContent or "",
		dur = config.Duration or 60,
		t = 0,
		buttons = config.Buttons,
		removed = false,
		type = kind,
		slot = slot,
		h = (config.Buttons and 88 or (config.SubContent and 64 or (config.Content and 64 or 48))),
	}
	slot.inUse = true
	if config.Buttons then
		n._bPool = {}
		for bi, b in ipairs(config.Buttons) do
			n._bPool[bi] = { bg = newSquare(), text = newText(TEXT_FONT_BODY), border = newSquare() }
		end
	end
	table.insert(notifActive, n)
	return n
end

local function renderNotifications(dt)
	local th = theme()
	local x = state.viewW - NOTIF_W - NOTIF_PAD
	local bottomY = state.viewH - NOTIF_PAD

	for i = #notifActive, 1, -1 do
		local n = notifActive[i]
		n.t = n.t + dt
		n.dur = n.dur - dt
		if n.dur <= 0 then n.removed = true end

		local slot = n.slot
		local y = bottomY - n.h * (#notifActive - i + 1) - 8 * (#notifActive - i)
		local appear = clampN(n.t / 0.25, 0, 1)
		appear = easeOutBack(appear)
		local xoff = (1 - appear) * (NOTIF_W + 30)

		slot.shadow.Color = th.shadow
		slot.shadow.Transparency = 0.35
		slot.shadow.Corner = 10
		setRect(slot.shadow, x + xoff + 2, y + 2, NOTIF_W, n.h)
		slot.shadow.Visible = true

		slot.bg.Color = th.title
		slot.bg.Corner = 10
		slot.bg.Transparency = visibleT(0)
		slot.bg.Outline = true
		slot.bg.Thickness = 1
		setRect(slot.bg, x + xoff, y, NOTIF_W, n.h)
		slot.bg.Visible = true

		-- left accent stripe
		local accentC = n.type == "success" and th.success or n.type == "warning" and th.warning or n.type == "danger" and th.danger or colorLerp(th.accent, th.accent2, 0.2)
		slot.accent.Color = accentC
		slot.accent.Corner = 4
		setRect(slot.accent, x + xoff, y + 6, 3, n.h - 12)
		slot.accent.Visible = true

		setText(slot.title, n.title, x + xoff + 16, y + 9, 13, th.text, false, true)
		setText(slot.content, n.content, x + xoff + 16, y + 28, 11, th.textDim, false, true)

		local closeH = hit(state.MouseX, state.MouseY, x + xoff + NOTIF_W - 26, y + 6, 20, 20)
		setText(slot.close, "x", x + xoff + NOTIF_W - 16, y + 8, 12, closeH and th.textDim or th.textFaint, true, true)
		slot.close.Visible = true

		if state.Click and closeH then
			n.removed = true
		end

		if n.buttons and n._bPool then
			local bx = x + xoff + 16
			local byb = y + n.h - 26
			local btotal = 0
			local bwArr = {}
			for bi, b in ipairs(n.buttons) do
				local bw = math.min(math.max(textW(b.Title or "", 11) + 22, 48), 90)
				bwArr[bi] = bw
				btotal = btotal + bw + 6
			end
			bx = x + xoff + math.max(16, (NOTIF_W - btotal) / 2)
			for bi, b in ipairs(n.buttons) do
				if n._bPool[bi] then
					local bb = n._bPool[bi]
					local bw = bwArr[bi]
					local bhov = hit(state.MouseX, state.MouseY, bx, byb, bw, 20)
					bb.border.Color = th.border
					bb.border.Corner = 5
					bb.border.Outline = true
					bb.border.Filled = false
					bb.border.Thickness = 1
					setRect(bb.border, bx, byb, bw, 20)
					bb.border.Visible = true
					bb.bg.Color = bhov and colorLerp(th.accent, th.accent2, 0.15) or th.accent
					bb.bg.Corner = 5
					setRect(bb.bg, bx, byb, bw, 20)
					bb.bg.Visible = true
					setText(bb.text, b.Title, bx + bw / 2, byb + 4, 10, th.titleBarText, true, true)
					if state.Click and hit(state.MouseX, state.MouseY, bx, byb, bw, 20) then
						safeCallback(b.Callback)
						n.removed = true
					end
					bx = bx + bw + 6
				end
			end
		end
	end

	for i = #notifActive, 1, -1 do
		local n = notifActive[i]
		if n.removed then
			table.remove(notifActive, i)
			n.slot.inUse = false
			n.slot.shadow.Visible = false
			n.slot.bg.Visible = false
			n.slot.border.Visible = false
			n.slot.accent.Visible = false
			n.slot.title.Visible = false
			n.slot.content.Visible = false
			n.slot.close.Visible = false
			if n._bPool then
				for _, bb in ipairs(n._bPool) do
					bb.bg:Remove()
					bb.text:Remove()
					bb.border:Remove()
				end
			end
		end
	end
end

-- ============================================================
-- Dialog
-- ============================================================

local Dialog = {}
Dialog.__index = Dialog

function Dialog:Close()
	if self._closed then return end
	self._closed = true
	currentDialog = nil
	if self._overlay then self._overlay.Visible = false end
	if self._panel then self._panel.Visible = false end
	if self._shadow then self._shadow.Visible = false end
	if self._border then self._border.Visible = false end
	for _, t in ipairs(self._texts) do t.Visible = false end
	for _, b in ipairs(self._buttons) do
		b.bg.Visible = false
		b.text.Visible = false
		b.border.Visible = false
	end
	if self._onClosed then
		for _, fn in ipairs(self._onClosed) do
			safeCallback(fn)
		end
	end
end

function Dialog:OnClosed(fn)
	self._onClosed = self._onClosed or {}
	table.insert(self._onClosed, fn)
end

function Dialog:OnClosing(fn)
	self._onClosing = self._onClosing or {}
	table.insert(self._onClosing, fn)
end

function Win:Dialog(config)
	config = config or {}
	local t = theme()
	local d = setmetatable({}, Dialog)
	d._texts = {}
	d._buttons = {}

	d._overlay = newSquare()
	d._overlay.Color = t.dialogOverlay
	d._overlay.Transparency = 0.6
	d._overlay.ZIndex = 900
	setRect(d._overlay, 0, 0, state.viewW, state.viewH)
	d._overlay.Visible = true

	d._shadow = newSquare()
	d._shadow.Color = t.shadow
	d._shadow.Transparency = 0.4
	d._shadow.Corner = 12
	d._shadow.ZIndex = 900
	d._shadow.Visible = false

	d._panel = newSquare()
	d._panel.Color = t.content
	d._panel.Corner = 12
	d._panel.ZIndex = 901
	d._panel.Outline = true
	d._panel.Thickness = 1
	d._panel.Visible = false

	d._border = newSquare()
	d._border.Color = t.border
	d._border.Corner = 12
	d._border.Outline = true
	d._border.Filled = false
	d._border.Thickness = 1
	d._border.ZIndex = 902
	d._border.Visible = false

	local pw = 360
	local lines = {}
	for line in string.gmatch(config.Content or "", "[^\n]*") do
		if #line > 0 then table.insert(lines, line) end
	end
	local ph = 46 + math.max(#lines, 1) * 18 + 46
	local px = clampN((state.viewW - pw) / 2, 4, state.viewW - pw - 4)
	local py = clampN((state.viewH - ph) / 2, 4, state.viewH - ph - 4)

	setRect(d._shadow, px + 4, py + 5, pw, ph)
	setRect(d._panel, px, py, pw, ph)
	setRect(d._border, px, py, pw, ph)

	local tt = newText(TEXT_FONT_TITLE)
	tt.ZIndex = 903
	setText(tt, config.Title or "", px + 18, py + 15, 16, t.text, false, false)
	table.insert(d._texts, tt)

	local thLine = newSquare()
	thLine.Color = colorLerp(t.accent, t.accent2, 0.2)
	thLine.Corner = 2
	thLine.ZIndex = 902
	setRect(thLine, px + 18, py + 32, 42, 3)
	thLine.Visible = false
	table.insert(d._texts, thLine)

	local ly = py + 48
	local contentColor = t.textDim
	for i, line in ipairs(lines) do
		if i <= 5 then
			local ct = newText(TEXT_FONT_BODY)
			ct.ZIndex = 903
			setText(ct, line, px + 18, ly, 12, contentColor, false, false)
			table.insert(d._texts, ct)
			ly = ly + 18
		end
	end

	local btns = config.Buttons or {}
	local bxStart = px + pw - 18
	local by = py + ph - 32
	for i, b in ipairs(btns) do
		if i > 2 then break end
		local bw = textW(b.Title or "", 12) + 36
		bxStart = bxStart - bw
		local bbg = newSquare()
		bbg.ZIndex = 904
		bbg.Corner = 6
		bbg.Color = i == 1 and colorLerp(t.accent, t.accent2, 0.15) or t.elementHover
		bbg.Outline = i ~= 1
		bbg.Thickness = 1
		setRect(bbg, bxStart, by, bw, 24)
		local bbdr = newSquare()
		bbdr.ZIndex = 904
		bbdr.Corner = 6
		bbdr.Outline = true
		bbdr.Filled = false
		bbdr.Thickness = 1
		bbdr.Color = t.border
		setRect(bbdr, bxStart, by, bw, 24)
		local btxt = newText(TEXT_FONT_BODY)
		btxt.ZIndex = 905
		setText(btxt, b.Title, bxStart + bw / 2, by + 4, 12, i == 1 and t.titleBarText or t.text, true, false)
		table.insert(d._buttons, { bg = bbg, border = bbdr, text = btxt, title = b.Title, x = bxStart, y = by, w = bw, h = 24, cb = b.Callback })
		bxStart = bxStart - 8
	end

	d._step = function(dt)
		if d._closed then return end
		local thx = theme()
		d._overlay.Visible = true
		d._shadow.Visible = true
		d._panel.Visible = true
		d._border.Visible = true
		d._panel.Color = thx.content
		for _, tx in ipairs(d._texts) do tx.Visible = true end
		for _, b in ipairs(d._buttons) do
			local hovBtn = hit(state.MouseX, state.MouseY, b.x, b.y, b.w, b.h)
			b.bg.Visible = true
			b.border.Visible = true
			b.text.Visible = true
			if b.cb and b.title == (btns[1] and btns[1].Title or "") then
				b.bg.Color = colorLerp(thx.accent, thx.accent2, 0.15)
			elseif hovBtn then
				b.bg.Color = thx.elementHover
			else
				b.bg.Color = thx.elementPress
			end
			if state.Click and hovBtn then
				if b.cb then safeCallback(b.cb) end
				d:Close()
			end
		end
	end

	d._onClosed = d._onClosed or {}
	table.insert(d._onClosed, function()
		d._overlay:Remove()
		d._panel:Remove()
		d._shadow:Remove()
		d._border:Remove()
		for _, tx in ipairs(d._texts) do tx:Remove() end
		for _, b in ipairs(d._buttons) do
			b.bg:Remove()
			b.text:Remove()
			b.border:Remove()
		end
	end)

	currentDialog = d
	return d
end

-- ============================================================
-- Render loop
-- ============================================================

local function frame(dt)
	if unloaded then return end
	local cam = workspace.CurrentCamera
	local vs = cam and cam.ViewportSize
	if vs then
		state.viewW = vs.X
		state.viewH = vs.Y
	end

	readInput()

	if currentDialog then
		currentDialog._step(dt)
		if currentDialog then state.Click = false end
	end

	if win and win.alive then
		renderWindow(dt)
		handleKeybinds()
		if win.MinimizeKey and not state.focusedInput and not state.focusedEdit and not state.listeningKeybind then
			local mk = type(win.MinimizeKey) == "number" and win.MinimizeKey or vkFromName(win.MinimizeKey)
			if mk and keyJustPressed(mk) then
				Nebula:Minimize()
			end
		end
	end

	renderNotifications(dt)

	for pop in pairs(allPopups) do
		if type(pop._outerClick) == "function" and not pop._justOpened then
			pop:_outerClick()
		end
	end
end

-- ============================================================
-- Public API
-- ============================================================

function Nebula:GetTheme()
	return themeName
end

function Nebula:SetTheme(name)
	if Themes[name] then
		themeName = name
		for _, fn in ipairs(themeChangedCallbacks) do
			safeCallback(fn, name)
		end
	end
end

function Nebula:SetTranslucent(v)
	translucent = v == true
end

local defaultOptions = {
	Title = "Nebula",
	SubTitle = "",
	Size = Vector2.new(600, 480),
	MinSize = Vector2.new(480, 400),
	Resize = false,
	TabWidth = 172,
	Theme = "Aurora",
	Translucent = false,
	MinimizeKey = "End",
	ConfigName = nil,
	AutoStep = true,
}

function Nebula:CreateWindow(config)
	if loaded then
		warn("Nebula already has a window.")
		return nil
	end
	config = config or {}
	for k, v in pairs(defaultOptions) do
		if config[k] == nil then config[k] = v end
	end

	local cam = workspace.CurrentCamera
	if cam and cam.ViewportSize then
		winViewW = cam.ViewportSize.X
		winViewH = cam.ViewportSize.Y
	else
		winViewW = 1920
		winViewH = 1080
	end
	state.viewW = winViewW
	state.viewH = winViewH

	local function pixelDim(v)
		if typeof(v) == "Vector2" then return v end
		if typeof(v) == "UDim2" then
			return Vector2.new(v.X.Scale * winViewW + v.X.Offset, v.Y.Scale * winViewH + v.Y.Offset)
		end
		return nil
	end
	config.Size = pixelDim(config.Size) or Vector2.new(600, 480)
	config.MinSize = pixelDim(config.MinSize) or Vector2.new(480, 400)

	if config.Resize then
		local kx = winViewW / 1920
		local ky = winViewH / 1080
		config.Size = config.Size and Vector2.new(config.Size.X * kx, config.Size.Y * ky) or Vector2.new(600, 480)
		config.MinSize = config.MinSize and Vector2.new(config.MinSize.X * kx, config.MinSize.Y * ky) or Vector2.new(480, 400)
		config.TabWidth = intRound(config.TabWidth * kx)
	end

	themeName = config.Theme or "Aurora"
	if not Themes[themeName] then themeName = "Aurora" end
	translucent = config.Translucent == true

	win = buildWindow(config)
	win.config = config
	win.UpdateMinKey = config.MinimizeKey
	win.MinimizeKey = type(config.MinimizeKey) == "number" and config.MinimizeKey or vkFromName(config.MinimizeKey) or EndC

	chrome.shadow1 = newSquare()
	chrome.shadow2 = newSquare()
	chrome.shadow3 = newSquare()
	chrome.bg = newSquare()
	chrome.frame = newSquare()
	chrome.accent = newSquare()
	chrome.accentA = newSquare()
	chrome.accentB = newSquare()
	chrome.accentC = newSquare()
	chrome.title = newSquare()
	chrome.titleText = newText(TEXT_FONT_TITLE)
	chrome.titleText2 = newText(TEXT_FONT_TITLE)
	chrome.subText = newText(TEXT_FONT_BODY)
	chrome.iconBg = newSquare()
	chrome.iconText = newText(TEXT_FONT_TITLE)
	chrome.closeBg = newSquare()
	chrome.closeText = newText(TEXT_FONT_BODY)
	chrome.maxBg = newSquare()
	chrome.maxText = newText(TEXT_FONT_BODY)
	chrome.minBg = newSquare()
	chrome.minText = newText(TEXT_FONT_BODY)
	chrome.tabBg = newSquare()
	chrome.contentBg = newSquare()
	chrome.divider = newLine()
	chrome.resizeGrip = newLine()
	chrome.scrollBg = newSquare()
	chrome.scrollThumb = newSquare()

	loaded = true
	unloaded = false
	Nebula.Loaded = true
	Nebula.Unloaded = false

	if config.AutoStep and not conn then
		conn = RunService.RenderStepped:Connect(frame)
	end

	return win
end

function Nebula:OnUnload(fn)
	table.insert(unloadCallbacks, fn)
end

function Nebula:OnMinimized(fn)
	table.insert(minimizedCallbacks, fn)
end

function Nebula:OnMaximized(fn)
	table.insert(maximizedCallbacks, fn)
end

function Nebula:OnThemeChanged(fn)
	table.insert(themeChangedCallbacks, fn)
end

function Nebula:SafeCallback(fn, ...)
	safeCallback(fn, ...)
end

function Nebula:Destroy()
	if unloaded then return end
	unloaded = true
	loaded = false
	Nebula.Unloaded = true
	Nebula.Loaded = false
	if conn then
		conn:Disconnect()
		conn = nil
	end
	if win then
		for _, t in ipairs(win.Tabs) do
			if t.chrome then
				t.chrome.shadow:Remove()
				t.chrome.bg:Remove()
				t.chrome.pill:Remove()
				t.chrome.text:Remove()
				t.chrome.icon:Remove()
				t.chrome.color:Remove()
				t.chrome.underline:Remove()
			end
			for _, node in ipairs(t.nodes) do
				if node.kind == "element" and node.element._destroyDrawings then
					node.element:_destroyDrawings()
				elseif node.kind == "section" and node.section.text then
					node.section.text:Remove()
					if node.section.line then node.section.line:Remove() end
					if node.section.dot then node.section.dot:Remove() end
				end
			end
		end
	end
	for _, d in pairs(chrome) do
		if type(d) == "table" and d.Remove then d:Remove() end
	end
	for _, slot in ipairs(notifPool) do
		slot.shadow:Remove()
		slot.bg:Remove()
		slot.border:Remove()
		slot.accent:Remove()
		slot.title:Remove()
		slot.content:Remove()
		slot.close:Remove()
	end
	for _, fn in ipairs(unloadCallbacks) do
		pcall(fn)
	end
	win = nil
end

function Nebula:Minimize()
	if not win then return end
	win.minimized = not win.minimized
	if win.minimized then
		win.dragging = false
		win.resizing = false
		win._scrollDrag = false
		for pop in pairs(allPopups) do
			if type(pop._outerClick) == "function" then
				pop:_outerClick()
			end
		end
	end
	for _, fn in ipairs(minimizedCallbacks) do
		safeCallback(fn, win.minimized)
	end
end

function Nebula:Maximize(on)
	if not win then return end
	if on == nil then on = not win.maximized end
	win.maximized = on
	for _, fn in ipairs(maximizedCallbacks) do
		safeCallback(fn, on)
	end
	for pop in pairs(allPopups) do
		if type(pop._outerClick) == "function" then
			pop:_outerClick()
		end
	end
end

function Win:SelectTab(index)
	if self.Tabs[index] then
		self.SelectedTab = self.Tabs[index]
		self.SelectedTab.scroll = 0
	end
end

-- ============================================================
-- Config
-- ============================================================

function Nebula:SetFolder(name)
	if name then
		FOLDER = tostring(name)
	end
	return FOLDER
end

function Nebula:SetIgnoreIndexes(list)
	ignoreIndexes = list or {}
end

function Nebula:GetConfigs()
	if not isfolder(FOLDER) then return {} end
	local out = {}
	for _, f in ipairs(listfiles(FOLDER)) do
		if f:match("%.json$") and not f:match("interface%.json$") then
			local name = f:match("([^\\/]+)%.json$")
			if name then table.insert(out, name) end
		end
	end
	table.sort(out)
	return out
end

function Nebula:SaveConfig(name)
	name = name or autoloadName
	if not name then
		warn("No config name.")
		return false
	end
	if not isfolder(FOLDER) then makefolder(FOLDER) end
	local data = {}
	for id, handle in pairs(Nebula.Options) do
		if not (ignoreIndexes and ignoreIndexes[id]) then
			local v = serializeValue(handle)
			if v ~= nil then data[id] = v end
		end
	end
	local ok, encoded = pcall(HttpService.JSONEncode, HttpService, data)
	if ok then
		writefile(FOLDER .. "/" .. name .. ".json", encoded)
		Nebula:Notify({ Title = "Config saved", Content = name, Duration = 3, Type = "success" })
		return true
	end
	return false
end

function Nebula:LoadConfig(name)
	if not isfile(FOLDER .. "/" .. name .. ".json") then
		Nebula:Notify({ Title = "Config not found", Content = tostring(name), Duration = 3, Type = "warning" })
		return false
	end
	local data = readfile(FOLDER .. "/" .. name .. ".json")
	local ok, decoded = pcall(HttpService.JSONDecode, HttpService, data)
	if not ok or type(decoded) ~= "table" then return false end
	for id, v in pairs(decoded) do
		if Nebula.Options[id] then
			applyValue(Nebula.Options[id], v)
		end
	end
	Nebula:Notify({ Title = "Config loaded", Content = tostring(name), Duration = 3, Type = "success" })
	return true
end

function Nebula:SetAutoload(name)
	autoloadName = name
	if not isfolder(FOLDER) then makefolder(FOLDER) end
	writefile(FOLDER .. "/autoload.txt", tostring(name))
end

function Nebula:LoadAutoloadConfig()
	if isfile(FOLDER .. "/autoload.txt") then
		local name = readfile(FOLDER .. "/autoload.txt")
		if name and #name > 0 then
			autoloadName = name
			Nebula:LoadConfig(name)
		end
	end
end

-- ============================================================
-- Prebuilt sections
-- ============================================================

function Win:BuildInterfaceSection(tab)
	tab:AddDropdown({
		Title = "Theme",
		Values = Nebula.Themes,
		Default = themeName,
		Callback = function(v)
			Nebula:SetTheme(v)
		end,
	})
	tab:AddButton({
		Title = "Toggle translucency",
		Description = "Switch between solid and glass panels",
		Callback = function()
			Nebula:SetTranslucent(not translucent)
		end,
	})
	tab:AddKeybind({
		Title = "Minimize key",
		Default = "End",
		ChangedCallback = function(v)
			if v then win.MinimizeKey = vkFromName(v) or win.MinimizeKey end
		end,
	})
end

function Win:BuildConfigSection(tab)
	local dropdown = tab:AddDropdown({
		Title = "Config",
		Values = Nebula:GetConfigs(),
		Default = "None",
		Callback = function(v)
			if v ~= "None" then
				Nebula:LoadConfig(v)
				dropdown:SetValues(Nebula:GetConfigs())
			end
		end,
	})
	local inp = tab:AddInput({
		Title = "Config name",
		Placeholder = "name...",
	})
	tab:AddButton({
		Title = "Save config",
		Style = "accent",
		Callback = function()
			local name = inp.Value
			if name and #name > 0 then
				Nebula:SaveConfig(name)
				dropdown:SetValues(Nebula:GetConfigs())
			end
		end,
	})
	tab:AddButton({
		Title = "Set autoload",
		Callback = function()
			local name = inp.Value
			if name and #name > 0 then
				Nebula:SetAutoload(name)
				Nebula:Notify({ Title = "Autoload set", Content = name, Duration = 3, Type = "success" })
			end
		end,
	})
end

_G.Nebula = Nebula
return Nebula
