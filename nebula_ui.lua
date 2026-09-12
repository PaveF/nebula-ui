-- Nebula UI Library v2.0.0 — Full UI Remake
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

local themeName = "Dark"
local translucent = true
local loaded = false
local unloaded = false
local currentDialog = nil

local FOLDER = "Nebula"
local autoloadName = nil
local ignoreIndexes = nil

local Themes = {}

local function C3(r, g, b) return Color3.fromRGB(r, g, b) end

Themes.Dark = {
	name = "Dark",
	accent = C3(139, 92, 246),
	accent2 = C3(124, 77, 230),
	text = C3(245, 245, 247),
	textDim = C3(154, 158, 169),
	textFaint = C3(101, 105, 116),
	bg = C3(10, 11, 14),
	title = C3(16, 17, 21),
	content = C3(12, 13, 17),
	tab = C3(15, 16, 20),
	tabHover = C3(24, 25, 31),
	tabActive = C3(29, 24, 41),
	tabActiveAccent = C3(139, 92, 246),
	element = C3(19, 20, 25),
	elementHover = C3(24, 25, 31),
	elementPress = C3(15, 16, 20),
	field = C3(15, 16, 21),
	fieldHover = C3(22, 23, 29),
	border = C3(39, 41, 49),
	toggleOff = C3(55, 58, 68),
	toggleOn = C3(139, 92, 246),
	sliderTrack = C3(49, 51, 61),
	sliderFill = C3(139, 92, 246),
	scroll = C3(74, 77, 88),
	scrollHover = C3(101, 105, 116),
	success = C3(86, 205, 142),
	warning = C3(236, 183, 76),
	danger = C3(231, 93, 102),
	dialogOverlay = C3(0, 0, 0),
	accentBar = C3(139, 92, 246),
	titleBarText = C3(250, 250, 252),
}

Themes.Midnight = {
	name = "Midnight",
	accent = C3(56, 189, 248),
	accent2 = C3(38, 165, 225),
	text = C3(241, 247, 252),
	textDim = C3(150, 164, 177),
	textFaint = C3(92, 108, 122),
	bg = C3(8, 12, 17),
	title = C3(12, 18, 25),
	content = C3(9, 13, 19),
	tab = C3(11, 16, 23),
	tabHover = C3(18, 26, 35),
	tabActive = C3(18, 37, 51),
	tabActiveAccent = C3(56, 189, 248),
	element = C3(14, 20, 28),
	elementHover = C3(19, 27, 36),
	elementPress = C3(11, 16, 23),
	field = C3(10, 15, 22),
	fieldHover = C3(16, 23, 31),
	border = C3(29, 40, 52),
	toggleOff = C3(47, 61, 74),
	toggleOn = C3(56, 189, 248),
	sliderTrack = C3(39, 52, 66),
	sliderFill = C3(56, 189, 248),
	scroll = C3(60, 78, 95),
	scrollHover = C3(82, 104, 124),
	success = C3(82, 201, 144),
	warning = C3(238, 183, 76),
	danger = C3(228, 102, 111),
	dialogOverlay = C3(0, 0, 0),
	accentBar = C3(56, 189, 248),
	titleBarText = C3(249, 252, 255),
}

Themes.Neon = {
	name = "Neon",
	accent = C3(45, 212, 191),
	accent2 = C3(20, 184, 166),
	text = C3(239, 250, 247),
	textDim = C3(142, 167, 162),
	textFaint = C3(87, 111, 106),
	bg = C3(8, 14, 13),
	title = C3(12, 21, 19),
	content = C3(9, 16, 15),
	tab = C3(11, 19, 18),
	tabHover = C3(18, 29, 27),
	tabActive = C3(12, 48, 44),
	tabActiveAccent = C3(45, 212, 191),
	element = C3(14, 23, 22),
	elementHover = C3(19, 31, 29),
	elementPress = C3(11, 19, 18),
	field = C3(10, 18, 17),
	fieldHover = C3(16, 27, 25),
	border = C3(28, 47, 44),
	toggleOff = C3(42, 63, 59),
	toggleOn = C3(45, 212, 191),
	sliderTrack = C3(37, 55, 52),
	sliderFill = C3(45, 212, 191),
	scroll = C3(55, 80, 74),
	scrollHover = C3(75, 107, 99),
	success = C3(77, 205, 142),
	warning = C3(240, 193, 76),
	danger = C3(229, 99, 109),
	dialogOverlay = C3(0, 0, 0),
	accentBar = C3(45, 212, 191),
	titleBarText = C3(248, 255, 253),
}

Themes.Light = {
	name = "Light",
	accent = C3(99, 102, 241),
	accent2 = C3(79, 70, 229),
	text = C3(27, 29, 36),
	textDim = C3(103, 108, 121),
	textFaint = C3(151, 156, 169),
	bg = C3(239, 241, 245),
	title = C3(249, 250, 252),
	content = C3(244, 245, 248),
	tab = C3(237, 239, 243),
	tabHover = C3(228, 231, 236),
	tabActive = C3(228, 227, 252),
	tabActiveAccent = C3(99, 102, 241),
	element = C3(255, 255, 255),
	elementHover = C3(249, 250, 252),
	elementPress = C3(241, 243, 247),
	field = C3(238, 240, 244),
	fieldHover = C3(231, 233, 239),
	border = C3(218, 221, 229),
	toggleOff = C3(199, 203, 213),
	toggleOn = C3(99, 102, 241),
	sliderTrack = C3(210, 213, 222),
	sliderFill = C3(99, 102, 241),
	scroll = C3(192, 197, 208),
	scrollHover = C3(166, 171, 185),
	success = C3(53, 160, 103),
	warning = C3(207, 153, 46),
	danger = C3(218, 78, 90),
	dialogOverlay = C3(0, 0, 0),
	accentBar = C3(99, 102, 241),
	titleBarText = C3(255, 255, 255),
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
	d.NumSides = 24
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

local function visibleT(base)
	if not translucent then return 0 end
	return base or 0.02
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

local TITLE_H = 46
local ACCENT_H = 1
local CONTENT_HEADER_H = 54
local CONTENT_PAD_X = 18
local ELEMENT_GAP = 6
local SCROLLBAR_W = 3

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
				sec.h = 24
				y = y + 12
				sec.y = y
				y = y + sec.h
			end
		else
			local el = node.element
			local h = el.Height or 34
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
		Callback = config.Callback,
		_ownerTab = tab,
		Height = config.Description and 48 or 40,
		_hoverT = 0,
		_visible = false,
		Value = nil,
	}, BaseHandle)

	el._bg = newSquare()
	el._title = newText(TEXT_FONT_BODY)
	el._desc = newText(TEXT_FONT_BODY)

	function el:_hideAll()
		el._bg.Visible = false
		el._title.Visible = false
		el._desc.Visible = false
	end

	function el:_destroyDrawings()
		el._bg:Remove()
		el._title:Remove()
		el._desc:Remove()
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
		el._hoverT = ease(el._hoverT, hov and 1 or 0, dt, 12)
		local press = hov and state.Lmb
		local base = th.element
		local hover = th.elementHover
		local bg = Color3.fromRGB(
			intRound(lerpN(base.R * 255, hover.R * 255, el._hoverT)),
			intRound(lerpN(base.G * 255, hover.G * 255, el._hoverT)),
			intRound(lerpN(base.B * 255, hover.B * 255, el._hoverT))
		)
		if press then
			bg = Color3.fromRGB(
				intRound(bg.R * 255 - 12),
				intRound(bg.G * 255 - 12),
				intRound(bg.B * 255 - 12)
			)
		end
		el._bg.Color = bg
		el._bg.Corner = 5
		el._bg.Outline = true
		el._bg.Transparency = visibleT(0)
		setRect(el._bg, cx, y, cw, el.h)
		setText(el._title, el.Title or "Button", cx + 16, y + (el.Description and 7 or 12), 13, th.text, false, true)
		if el.Description then
			setText(el._desc, el.Description, cx + 16, y + 29, 11, th.textDim, false, true)
		end
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
		Value = config.Default == true,
	}, BaseHandle)

	el.HeightFn = function()
		return el.Description and 48 or 40
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
	el._title = newText(TEXT_FONT_BODY)
	el._desc = newText(TEXT_FONT_BODY)
	el._track = newSquare()
	el._knob = newCircle()

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
		el._title.Visible = false
		el._desc.Visible = false
		el._track.Visible = false
		el._knob.Visible = false
	end

	function el:_destroyDrawings()
		el._bg:Remove()
		el._title:Remove()
		el._desc:Remove()
		el._track:Remove()
		el._knob:Remove()
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
		el._hoverT = ease(el._hoverT, hov and 1 or 0, dt, 12)
		el._knobAnim = ease(el._knobAnim, el.Value and 1 or 0, dt, 14)

		local hover = th.elementHover
		el._bg.Color = Color3.fromRGB(
			intRound(lerpN(th.element.R * 255, hover.R * 255, el._hoverT)),
			intRound(lerpN(th.element.G * 255, hover.G * 255, el._hoverT)),
			intRound(lerpN(th.element.B * 255, hover.B * 255, el._hoverT))
		)
		el._bg.Corner = 6
		setRect(el._bg, cx, y, cw, h)
		setText(el._title, el.Title or "", cx + 12, y + (el.Description and 6 or 10), 13, th.text, false, true)
		if el.Description then
			setText(el._desc, el.Description, cx + 16, y + 29, 11, th.textDim, false, true)
		end

		local tx = cx + cw - 54
		local trackW = 38
		local trackH = 20
		local ty = y + (h - trackH) / 2
		el._track.Color = colorLerp(th.toggleOff, th.toggleOn, el._knobAnim)
		el._track.Corner = 10
		setRect(el._track, tx, ty, trackW, trackH)
		local kx = tx + 4 + el._knobAnim * (trackW - trackH)
		el._knob.Position = Vector2.new(kx + trackH / 2, ty + trackH / 2)
		el._knob.Radius = 8
		el._knob.Color = Color3.new(1, 1, 1)
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
		Height = 50,
		Min = config.Min or 0,
		Max = config.Max or 100,
		Rounding = config.Rounding or 0,
		_dragging = false,
		_editValue = false,
		_editBuf = "",
	}, BaseHandle)

	el.Value = config.Default
	if el.Value == nil then el.Value = el.Min end

	el._bg = newSquare()
	el._title = newText(TEXT_FONT_BODY)
	el._track = newSquare()
	el._fill = newSquare()
	el._knob = newCircle()
	el._value = newText(TEXT_FONT_BODY)
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
		el._title.Visible = false
		el._track.Visible = false
		el._fill.Visible = false
		el._knob.Visible = false
		el._value.Visible = false
		el._editBg.Visible = false
		el._editText.Visible = false
	end

	function el:_destroyDrawings()
		el._bg:Remove()
		el._title:Remove()
		el._track:Remove()
		el._fill:Remove()
		el._knob:Remove()
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
		el._hoverT = ease(el._hoverT, hov and 1 or 0, dt, 12)
		el._bg.Color = Color3.fromRGB(
			intRound(lerpN(th.element.R * 255, th.elementHover.R * 255, el._hoverT)),
			intRound(lerpN(th.element.G * 255, th.elementHover.G * 255, el._hoverT)),
			intRound(lerpN(th.element.B * 255, th.elementHover.B * 255, el._hoverT))
		)
		el._bg.Corner = 5
		el._bg.Outline = true
		el._bg.Transparency = visibleT(0)
		setRect(el._bg, cx, y, cw, el.h)
		setText(el._title, el.Title or "", cx + 16, y + 8, 13, th.text, false, true)

		local trackX = cx + 12
		local trackW = math.max(cw - 32 - 68, 40)
		local trackY = y + 31
		local range = el.Max - el.Min
		local frac = range > 0 and (el.Value - el.Min) / range or 0
		frac = clampN(frac, 0, 1)

		el._track.Color = th.sliderTrack
		el._track.Corner = 3
		setRect(el._track, trackX, trackY, trackW, 5)
		el._fill.Color = th.sliderFill
		el._fill.Corner = 3
		setRect(el._fill, trackX, trackY, math.max(frac * trackW, 1), 5)
		el._knob.Position = Vector2.new(trackX + frac * trackW, trackY + 2.5)
		el._knob.Radius = 7
		el._knob.Color = Color3.new(1, 1, 1)
		el._knob.Visible = true

		local vt = fmtNum(el.Value, el.Rounding)
		if el._editValue then
			el._editBg.Color = th.fieldHover
			el._editBg.Corner = 4
			setRect(el._editBg, cx + cw - 70, y + 3, 58, 18)
			el._editText.Color = th.text
			setText(el._editText, el._editBuf, cx + cw - 70, y + 4, 12, th.text, false, true)
		else
			setText(el._value, vt, cx + cw - 12 - textW(vt, 13), y + 6, 13, th.accent, false, true)
		end

		local onTrack = hit(state.MouseX, state.MouseY, trackX, trackY - 4, trackW, 12)
		local onValue = not el._editValue and hit(state.MouseX, state.MouseY, cx + cw - 70, y + 3, 62, 20)

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
			if keyJustPressed(EnterC) then
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

		if state.Lmb and not state.Click and el._dragging then
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
		Height = 40,
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
	el._title = newText(TEXT_FONT_BODY)
	el._valueText = newText(TEXT_FONT_BODY)
	el._chevron = newText(TEXT_FONT_BODY)

	el._popupBg = newSquare()
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
		el._title.Visible = false
		el._valueText.Visible = false
		el._chevron.Visible = false
		el:_closePopup()
	end

	function el:_closePopup()
		el._popupBg.Visible = false
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
		el._title:Remove()
		el._valueText:Remove()
		el._chevron:Remove()
		el._popupBg:Remove()
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
		el._hoverT = ease(el._hoverT, (hov or el._open) and 1 or 0, dt, 12)
		el._bg.Color = Color3.fromRGB(
			intRound(lerpN(th.element.R * 255, th.elementHover.R * 255, el._hoverT)),
			intRound(lerpN(th.element.G * 255, th.elementHover.G * 255, el._hoverT)),
			intRound(lerpN(th.element.B * 255, th.elementHover.B * 255, el._hoverT))
		)
		el._bg.Corner = 5
		el._bg.Outline = true
		el._bg.Transparency = visibleT(0)
		setRect(el._bg, cx, y, cw, el.h)
		setText(el._title, el.Title or "", cx + 12, y + (el.Description and 6 or 10), 13, th.text, false, true)
		if el.Description then
			setText(el._descText or (function()
				el._descText = newText(TEXT_FONT_BODY)
				return el._descText
			end)(), el.Description, cx + 16, y + 29, 11, th.textDim, false, true)
		end
		local dv = displayVal()
		setText(el._valueText, dv, cx + cw - 12 - math.min(textW(dv, 12), cw - 80), y + 10, 12, th.textDim, false, true)
		setText(el._chevron, el._open and "/\\" or "\\/", cx + cw - 22, y + 10, 11, th.textFaint, true, true)

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
			local pw = math.min(cw, 260)
			local ph = (el.Searchable and 26 or 0) + visible * itemH + 4
			local px = cx
			local py = y + el.h + 4
			if py + ph > state.viewH then
				py = y - ph - 4
			end
			if py < 0 then py = y + el.h + 4 end

			el._popupBg.Color = th.tab
			el._popupBg.Corner = 8
			el._popupBg.Outline = true
			setRect(el._popupBg, px, py, pw, ph)
			el._popupBg.Visible = true

			local iy = py
			if el.Searchable then
				el._searchBg.Color = th.field
				el._searchBg.Corner = 6
				setRect(el._searchBg, px + 4, iy + 2, pw - 8, 20)
				el._searchBg.Visible = true
				local place = el._search == "" and (config.SearchPlaceholder or "Search...") or el._search
				setText(el._searchText, place, px + 9, iy + 5, 11, el._search == "" and th.textFaint or th.text, false, true)
				iy = iy + 26
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
					local ohov = hit(state.MouseX, state.MouseY, px + 2, yyReal, pw - 4, itemH)
					if ohov or selected then
						slot.bg.Transparency = visibleT(0.05)
						slot.bg.Color = selected and Color3.fromRGB(
							intRound(th.accent.R * 255 * 0.35 + th.tab.R * 255 * 0.65),
							intRound(th.accent.G * 255 * 0.35 + th.tab.G * 255 * 0.65),
							intRound(th.accent.B * 255 * 0.35 + th.tab.B * 255 * 0.65)
						) or th.tabHover
					else
						slot.bg.Transparency = 1
						slot.bg.Color = th.tab
					end
					slot.bg.Corner = 4
					setRect(slot.bg, px + 2, yyReal, pw - 4, itemH)
					slot.bg.Visible = ohov or selected
					setText(slot.text, el.Displayer(o), px + 10, yyReal + 6, 12, selected and th.accent or th.text, false, true)
					if selected then
						setText(slot.check, "*", px + pw - 16, yyReal + 5, 12, th.accent, true, true)
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
				local sx = px + pw - 8
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

				if state.Click and hit(state.MouseX, state.MouseY, sx, iy, 3, listH) then
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
		Height = 40,
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
	el._title = newText(TEXT_FONT_BODY)
	el._swatch = newSquare()
	el._valueHex = newText(TEXT_FONT_BODY)

	el._popBg = newSquare()
	el._svGrid = {}
	for i = 1, 9 do
		el._svGrid[i] = {}
		for j = 1, 9 do
			el._svGrid[i][j] = newSquare()
		end
	end
	el._svCursor = newCircle()
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
		el._title.Visible = false
		el._swatch.Visible = false
		el._valueHex.Visible = false
		el:_closePopup()
	end

	function el:_closePopup()
		el._popBg.Visible = false
		el._svCursor.Visible = false
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
		el._title:Remove()
		el._swatch:Remove()
		el._valueHex:Remove()
		el._popBg:Remove()
		el._svCursor:Remove()
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
			if not hit(state.MouseX, state.MouseY, p.Position.X, p.Position.Y, 220, 176) then
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
		el._hoverT = ease(el._hoverT, (hov or el._open) and 1 or 0, dt, 12)
		el._bg.Color = Color3.fromRGB(
			intRound(lerpN(th.element.R * 255, th.elementHover.R * 255, el._hoverT)),
			intRound(lerpN(th.element.G * 255, th.elementHover.G * 255, el._hoverT)),
			intRound(lerpN(th.element.B * 255, th.elementHover.B * 255, el._hoverT))
		)
		el._bg.Corner = 5
		el._bg.Outline = true
		el._bg.Transparency = visibleT(0)
		setRect(el._bg, cx, y, cw, el.h)
		setText(el._title, el.Title or "", cx + 16, y + 12, 13, th.text, false, true)

		el._swatch.Color = el.Value
		el._swatch.Corner = 6
		setRect(el._swatch, cx + cw - 40, y + 8, 18, 18)
		el._swatch.Transparency = el.alpha and clampN(el.alpha, 0, 0.9) or 0
		el._swatch.Visible = true

		local hexFull = hexFromColor(el.Value, el.alpha and el.alpha > 0 and el.alpha or nil)
		setText(el._valueHex, hexFull, cx + cw - 66, y + 10, 12, th.textDim, false, true)

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
			local pw, ph = 236, 188
			local px = math.max(cx, 4)
			if px + pw > state.viewW then px = cx end
			local py = y + el.h + 4
			if py + ph > state.viewH then py = y - ph - 4 end
			if py < 0 then py = y + el.h + 4 end

			el._popBg.Color = th.tab
			el._popBg.Corner = 10
			el._popBg.Outline = true
			setRect(el._popBg, px, py, pw, ph)
			el._popBg.Visible = true

			local svX = px + 10
			local svY = py + 10
			local svSize = 96
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

			local hx = px + 116
			local hy = py + 10
			local hw = 10
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
			setRect(el._hueCursor, hx - 2, hy + (el._h / 360) * hh - 2, hw + 4, 3)
			el._hueCursor.Visible = true

			local ay = py + 10 + svSize + 14
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
					setRect(ab, ax + (i - 1) * acell, ay, acell + 1, 8)
					ab.Visible = true
				end
				el._alphaCursor.Color = Color3.new(1, 1, 1)
				el._alphaCursor.Corner = 2
				setRect(el._alphaCursor, ax + clampN(el.alpha or 0, 0, 1) * svSize - 2, ay - 2, 4, 12)
				el._alphaCursor.Visible = true
				ay = ay + 18
			end

			setText(el._hexLab, "HEX", px + 10, ay, 10, th.textFaint, false, true)
			el._hexBg.Color = th.field
			el._hexBg.Corner = 4
			setRect(el._hexBg, px + 44, ay - 4, 120, 20)
			el._hexBg.Visible = true
			local hexStr = el._editHex and (el._hexBuf or "") or hexFromColor(el.Value, el.alpha and el.alpha > 0 and el.alpha or nil)
			setText(el._hexText, hexStr, px + 52, ay, 12, th.text, false, true)
			el._hexLab.Visible = true

			local by = py + ph - 26
			el._cancelBg.Color = th.elementPress
			el._cancelBg.Corner = 4
			setRect(el._cancelBg, px + 10, by, (pw - 28) / 2, 18)
			el._cancelBg.Visible = true
			setText(el._cancelText, "Cancel", px + 10 + (pw - 28) / 4, by + 4, 11, th.textDim, true, true)
			el._doneBg.Color = th.accent
			el._doneBg.Corner = 4
			setRect(el._doneBg, px + 10 + (pw - 28) / 2 + 8, by, (pw - 28) / 2, 18)
			el._doneBg.Visible = true
			setText(el._doneText, "Done", px + 10 + (pw - 28) / 2 + 8 + (pw - 28) / 4, by + 4, 11, th.titleBarText, true, true)

			local inSV = hit(state.MouseX, state.MouseY, svX, svY, svSize, svSize)
			local inHue = hit(state.MouseX, state.MouseY, hx, hy, hw, hh)
			local inAlpha = el._hasAlpha and hit(state.MouseX, state.MouseY, px + 10, py + 10 + svSize + 14, svSize, 8)
			local inCancel = hit(state.MouseX, state.MouseY, px + 10, by, (pw - 28) / 2, 18)
			local inDone = hit(state.MouseX, state.MouseY, px + 10 + (pw - 28) / 2 + 8, by, (pw - 28) / 2, 18)
			local inHex = hit(state.MouseX, state.MouseY, px + 44, ay - 4, 120, 20)

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
		Height = 50,
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
	el._title = newText(TEXT_FONT_BODY)
	el._field = newSquare()
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
		el._title.Visible = false
		el._field.Visible = false
		el._text.Visible = false
		el._caretDraw.Visible = false
	end

	function el:_destroyDrawings()
		el._bg:Remove()
		el._title:Remove()
		el._field:Remove()
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
		el._hoverT = ease(el._hoverT, (hov or el._focused) and 1 or 0, dt, 12)

		el._bg.Color = Color3.fromRGB(
			intRound(lerpN(th.element.R * 255, th.elementHover.R * 255, el._hoverT)),
			intRound(lerpN(th.element.G * 255, th.elementHover.G * 255, el._hoverT)),
			intRound(lerpN(th.element.B * 255, th.elementHover.B * 255, el._hoverT))
		)
		el._bg.Corner = 5
		el._bg.Outline = true
		el._bg.Transparency = visibleT(0)
		setRect(el._bg, cx, y, cw, el.h)
		setText(el._title, el.Title or "", cx + 16, y + 8, 13, th.text, false, true)

		local fx = cx + 12
		local fy = y + 27
		local fw = cw - 24
		local fh = 18
		el._field.Color = el._focused and th.accent2 or (hov and th.fieldHover or th.field)
		el._field.Corner = 6
		setRect(el._field, fx, fy, fw, fh)
		el._field.Visible = true

		local disp = el.Value
		if #disp == 0 then
			setText(el._text, el.Placeholder, fx + 5, fy + 1, 12, th.textFaint, false, true)
			el._caretDraw.Visible = false
		else
			el._caret = clampN(el._caret, 0, #disp)
			local deadW = textW(disp:sub(1, el._caret), 12)
			local avail = math.max(fw - 12, 0)
			local xoff = fx + 5
			if deadW > avail then
				xoff = fx + 5 - (deadW - avail)
			end
			setText(el._text, disp, xoff, fy + 1, 12, th.text, false, true)

			if el._focused then
				local caretX = fx + 5 + textW(disp:sub(1, el._caret), 12)
				el._caretDraw.Color = th.accent
				setRect(el._caretDraw, caretX, fy + 2, 1, 12)
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
		if n == 0 then return 12 end
		return 10 + n * 15
	end

	el._title = newText(TEXT_FONT_BODY)
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
		el._title.Visible = false
		for _, d in ipairs(el._lines) do d.Visible = false end
	end

	function el:_destroyDrawings()
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
			setText(el._title, el.Title, alignX(textW(el.Title, 13), el.TitleAlignment), y + 2, 13, th.accent, false, true)
		else
			el._title.Visible = false
		end
		local ly = y + 26
		local i = 1
		local content = el.Content or ""
		for line in string.gmatch(content, "[^\n]*") do
			if i > 6 then break end
			if #line > 0 then
				setText(el._lines[i], line, alignX(textW(line, 12), el.ContentAlignment), ly, 12, th.textDim, false, true)
				ly = ly + 15
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
		Height = 40,
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
	el._title = newText(TEXT_FONT_BODY)
	el._field = newSquare()
	el._fieldText = newText(TEXT_FONT_BODY)

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
		el._title.Visible = false
		el._field.Visible = false
		el._fieldText.Visible = false
	end

	function el:_destroyDrawings()
		el._bg:Remove()
		el._title:Remove()
		el._field:Remove()
		el._fieldText:Remove()
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
		el._hoverT = ease(el._hoverT, (hov or el._listening) and 1 or 0, dt, 12)

		el._bg.Color = Color3.fromRGB(
			intRound(lerpN(th.element.R * 255, th.elementHover.R * 255, el._hoverT)),
			intRound(lerpN(th.element.G * 255, th.elementHover.G * 255, el._hoverT)),
			intRound(lerpN(th.element.B * 255, th.elementHover.B * 255, el._hoverT))
		)
		el._bg.Corner = 5
		el._bg.Outline = true
		el._bg.Transparency = visibleT(0)
		setRect(el._bg, cx, y, cw, el.h)
		setText(el._title, el.Title or "", cx + 16, y + 12, 13, th.text, false, true)

		local fx = cx + cw - 104
		local fy = y + 9
		local fw = 92
		el._field.Color = el._listening and th.accent or (hov and th.fieldHover or th.field)
		el._field.Corner = 6
		setRect(el._field, fx, fy, fw, 20)
		el._field.Visible = true
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
	local cy = win.y + topH + CONTENT_HEADER_H
	local cw = math.max(win.w - win.TabWidth, 60)
	local ch = math.max(win.h - topH - CONTENT_HEADER_H, 40)
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
	local viewW, viewH = state.viewW, state.viewH

	if win.maximized then
		x, y, w, h = 1, 1, viewW - 2, viewH - 2
	end
	if win.minimized then
		h = TITLE_H + ACCENT_H + 2
	end

	-- Base frame
	chrome.bg.Color = th.bg
	chrome.bg.Corner = 8
	chrome.bg.Transparency = visibleT(0)
	chrome.bg.Outline = true
	setRect(chrome.bg, x, y, w, h)

	chrome.accent.Color = th.accentBar
	chrome.accent.Corner = 1
	setRect(chrome.accent, x + 1, y + 1, w - 2, ACCENT_H)
	chrome.accent.Visible = not win.minimized

	-- Header
	chrome.title.Color = th.title
	chrome.title.Corner = 8
	chrome.title.Transparency = visibleT(0)
	setRect(chrome.title, x + 1, y + ACCENT_H + 1, w - 2, TITLE_H - 1)

	local titleY = win.SubTitle and 7 or 13
	setText(chrome.titleText, win.Title, x + 18, y + ACCENT_H + titleY, 15, th.titleBarText, false, true)
	if win.SubTitle then
		setText(chrome.subText, win.SubTitle, x + 18, y + ACCENT_H + 27, 10, th.textDim, false, true)
	else
		chrome.subText.Visible = false
	end

	-- Window controls
	local btnW, btnH = 30, 26
	local by = y + 10
	local bxClose = x + w - btnW - 8
	local bxMax = bxClose - btnW - 4
	local bxMin = bxMax - btnW - 4

	local closeHovD = hit(state.MouseX, state.MouseY, bxClose, by, btnW, btnH)
	local maxHovD = hit(state.MouseX, state.MouseY, bxMax, by, btnW, btnH)
	local minHovD = hit(state.MouseX, state.MouseY, bxMin, by, btnW, btnH)

	chrome.closeBg.Color = closeHovD and th.danger or th.title
	chrome.closeBg.Corner = 6
	setRect(chrome.closeBg, bxClose, by, btnW, btnH)
	setText(chrome.closeText, "x", bxClose + btnW / 2, by + 5, 12,
		closeHovD and Color3.new(1, 1, 1) or th.textFaint, true, true)

	chrome.maxBg.Color = maxHovD and th.elementHover or th.title
	chrome.maxBg.Corner = 6
	setRect(chrome.maxBg, bxMax, by, btnW, btnH)
	setText(chrome.maxText, win.maximized and "[]" or "[]", bxMax + btnW / 2, by + 5, 11,
		maxHovD and th.text or th.textFaint, true, true)

	chrome.minBg.Color = minHovD and th.elementHover or th.title
	chrome.minBg.Corner = 6
	setRect(chrome.minBg, bxMin, by, btnW, btnH)
	setText(chrome.minText, "-", bxMin + btnW / 2, by + 4, 13,
		minHovD and th.text or th.textFaint, true, true)

	local titleDrag = hit(state.MouseX, state.MouseY, x + 4, y + ACCENT_H, w - 8, TITLE_H - ACCENT_H)
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
		win.x = clampN(state.MouseX - win.dragOffX, -w + 160, viewW - 60)
		win.y = clampN(state.MouseY - win.dragOffY, 0, viewH - 40)
	end

	if win.resizing then
		win.w = clampN(state.MouseX - win.resizeOffX, win.minW, viewW)
		win.h = clampN(state.MouseY - win.resizeOffY, win.minH, viewH)
	end

	if win.minimized then
		chrome.tabBg.Visible = false
		chrome.contentBg.Visible = false
		chrome.divider.Visible = false
		chrome.pageBar.Visible = false
		chrome.pageTitle.Visible = false
		chrome.pageSub.Visible = false
		chrome.resizeGrip.Visible = false
		for _, t in ipairs(win.Tabs) do
			if t.chrome then
				t.chrome.bg.Visible = false
				t.chrome.text.Visible = false
				t.chrome.color.Visible = false
			end
		end
		for _, node in ipairs(win.SelectedTab and win.SelectedTab.nodes or {}) do
			if node.kind == "element" then
				node.element:_hideAll()
			end
		end
		return
	end

	local cx, cy, cw, ch = computeContentRect()

	-- Sidebar
	chrome.tabBg.Color = th.tab
	chrome.tabBg.Corner = 7
	chrome.tabBg.Transparency = visibleT(0)
	setRect(chrome.tabBg, x + 1, y + TITLE_H + ACCENT_H, win.TabWidth - 2, h - TITLE_H - ACCENT_H - 1)
	chrome.tabBg.Visible = true

	-- Content surface
	chrome.contentBg.Color = th.content
	chrome.contentBg.Corner = 7
	chrome.contentBg.Transparency = visibleT(0)
	setRect(chrome.contentBg, cx, y + TITLE_H + ACCENT_H, cw, h - TITLE_H - ACCENT_H - 1)
	chrome.contentBg.Visible = true

	-- Sidebar divider
	chrome.divider.Color = th.border
	chrome.divider.Transparency = visibleT(0)
	chrome.divider.From = Vector2.new(x + win.TabWidth - 1, y + TITLE_H + ACCENT_H)
	chrome.divider.To = Vector2.new(x + win.TabWidth - 1, y + h)
	chrome.divider.Visible = true

	-- Page header
	local sel = win.SelectedTab
	local pageTitle = sel and sel.Title or ""
	local pageSub = (sel and sel.Icon and ("SECTION  •  " .. tostring(sel.Icon))) or "CONTROL PANEL"
	chrome.pageBar.Color = th.content
	chrome.pageBar.Corner = 0
	setRect(chrome.pageBar, cx + 1, y + TITLE_H + ACCENT_H, cw - 2, CONTENT_HEADER_H)
	chrome.pageBar.Visible = true

	setText(chrome.pageTitle, pageTitle, cx + CONTENT_PAD_X, y + TITLE_H + ACCENT_H + 13, 16, th.text, false, true)
	setText(chrome.pageSub, pageSub, cx + CONTENT_PAD_X, y + TITLE_H + ACCENT_H + 34, 9, th.textFaint, false, true)

	-- Resize grip
	chrome.resizeGrip.From = Vector2.new(x + w - 5, y + h - 12)
	chrome.resizeGrip.To = Vector2.new(x + w - 13, y + h - 4)
	chrome.resizeGrip.Color = th.textFaint
	chrome.resizeGrip.Thickness = 1
	chrome.resizeGrip.Visible = not win.maximized

	-- Sidebar tabs
	for i, t in ipairs(win.Tabs) do
		local bxx = x + 8
		local bw = win.TabWidth - 16
		local bh = 34
		local byy = y + TITLE_H + ACCENT_H + 12 + (i - 1) * (bh + 5)
		local active = t == win.SelectedTab
		local hovT = hit(state.MouseX, state.MouseY, bxx, byy, bw, bh)

		if not t.chrome then
			t.chrome = {}
			t.chrome.bg = newSquare()
			t.chrome.text = newText(TEXT_FONT_BODY)
			t.chrome.color = newSquare()
		end

		local tc = t.chrome
		tc.bg.Color = active and th.tabActive or (hovT and th.tabHover or th.tab)
		tc.bg.Corner = 7
		tc.bg.Transparency = visibleT(0)
		tc.bg.Outline = active
		setRect(tc.bg, bxx, byy, bw, bh)

		tc.color.Color = th.tabActiveAccent
		tc.color.Corner = 1
		tc.color.Transparency = active and 0 or 1
		setRect(tc.color, bxx, byy + 8, 2, bh - 16)
		tc.color.Visible = active

		local label = t.Title
		setText(tc.text, label, bxx + 13, byy + 10, 12,
			active and th.text or (hovT and th.textDim or th.textFaint), false, true)

		if state.Click and hovT then
			win.SelectedTab = t
			t.scroll = 0
		end
	end

	sel = win.SelectedTab
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

	local scrollX = cx + cw - SCROLLBAR_W - 6
	local scrollY = cy + 5
	local scrollH = ch - 10

	if maxScroll > 0 then
		local thumbHpx = math.max(scrollH * (ch / sel.contentH), 26)
		local thumbY = scrollY + (scrollH - thumbHpx) * (sel.scroll / maxScroll)

		chrome.scrollBg.Color = th.elementPress
		chrome.scrollBg.Corner = 2
		setRect(chrome.scrollBg, scrollX, scrollY, SCROLLBAR_W, scrollH)
		chrome.scrollBg.Visible = true

		local thumbHovD = hit(state.MouseX, state.MouseY, scrollX - 3, thumbY, SCROLLBAR_W + 6, thumbHpx)
		chrome.scrollThumb.Color = thumbHovD and th.scrollHover or th.scroll
		chrome.scrollThumb.Corner = 2
		setRect(chrome.scrollThumb, scrollX, thumbY, SCROLLBAR_W, thumbHpx)
		chrome.scrollThumb.Visible = true

		if state.Click and hit(state.MouseX, state.MouseY, scrollX - 5, scrollY, SCROLLBAR_W + 10, scrollH) then
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

	local elemPadTop = 10
	local elemW = cw - CONTENT_PAD_X * 2 - (maxScroll > 0 and (SCROLLBAR_W + 10) or 0)
	local elemX = cx + CONTENT_PAD_X

	for _, node in ipairs(sel.nodes) do
		if node.kind == "section" then
			local sec = node.section
			if not sec.isRoot then
				if not sec.text then sec.text = newText(TEXT_FONT_TITLE) end
				local sy = cy + sec.y - sel.scroll + 2
				local headText = (sec.Title or ""):upper()
				setText(sec.text, headText, elemX, sy, 9, th.textFaint, false, sy > cy - 20 and sy < cy + ch)
			end
		else
			local el = node.element
			if el._visible then
				el:_update(dt, elemX, cy + elemPadTop, elemW, ch - 12, sel.scroll)
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
local NOTIF_PAD = 14

for i = 1, notifSlots do
	notifPool[i] = {
		bg = newSquare(),
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
	local n = {
		title = config.Title or "",
		content = config.Content or config.SubContent or "",
		dur = config.Duration or 60,
		t = 0,
		buttons = config.Buttons,
		removed = false,
		slot = slot,
		h = (config.Buttons and 84 or (config.SubContent and 62 or (config.Content and 62 or 44))),
	}
	slot.inUse = true
	if config.Buttons then
		n._bPool = {}
		for bi, b in ipairs(config.Buttons) do
			n._bPool[bi] = { bg = newSquare(), text = newText(TEXT_FONT_BODY) }
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
		local appear = clampN(n.t / 0.2, 0, 1)
		local xoff = (1 - appear) * 40

		slot.bg.Color = th.title
		slot.bg.Corner = 7
		slot.bg.Transparency = visibleT(0)
		slot.bg.Outline = true
		setRect(slot.bg, x + xoff, y, NOTIF_W, n.h)
		slot.bg.Visible = true

		setText(slot.title, n.title, x + xoff + 12, y + 8, 13, th.text, false, true)
		setText(slot.content, n.content, x + xoff + 12, y + 29, 11, th.textDim, false, true)
		setText(slot.close, "x", x + xoff + NOTIF_W - 17, y + 8, 12, th.textFaint, true, true)

		if state.Click and hit(state.MouseX, state.MouseY, x + xoff + NOTIF_W - 24, y + 6, 20, 18) then
			n.removed = true
		end

		if n.buttons and n._bPool then
			local bx = x + xoff + 12
			local byb = y + n.h - 22
			for bi, b in ipairs(n.buttons) do
				if n._bPool[bi] then
					local bb = n._bPool[bi]
					local bw = math.min(math.max(textW(b.Title or "", 11) + 20, 44), 90)
					bb.bg.Color = th.accent
					bb.bg.Corner = 4
					setRect(bb.bg, bx, byb, bw, 16)
					bb.bg.Visible = true
					setText(bb.text, b.Title, bx + bw / 2, byb + 2, 10, th.titleBarText, true, true)
					if state.Click and hit(state.MouseX, state.MouseY, bx, byb, bw, 16) then
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
			n.slot.bg.Visible = false
			n.slot.title.Visible = false
			n.slot.content.Visible = false
			n.slot.close.Visible = false
			if n._bPool then
				for _, bb in ipairs(n._bPool) do
					bb.bg:Remove()
					bb.text:Remove()
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
	for _, t in ipairs(self._texts) do t.Visible = false end
	for _, b in ipairs(self._buttons) do
		b.bg.Visible = false
		b.text.Visible = false
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
	d._overlay.Transparency = 0.55
	d._overlay.ZIndex = 900
	setRect(d._overlay, 0, 0, state.viewW, state.viewH)
	d._overlay.Visible = false

	d._panel = newSquare()
	d._panel.Color = t.content
	d._panel.Corner = 8
	d._panel.ZIndex = 901
	d._panel.Visible = false

	local pw = 360
	local lines = {}
	for line in string.gmatch(config.Content or "", "[^\n]*") do
		if #line > 0 then table.insert(lines, line) end
	end
	local ph = 48 + math.max(#lines, 1) * 18 + 48
	local px = clampN((state.viewW - pw) / 2, 4, state.viewW - pw - 4)
	local py = clampN((state.viewH - ph) / 2, 4, state.viewH - ph - 4)

	setRect(d._panel, px, py, pw, ph)

	local tt = newText(TEXT_FONT_TITLE)
	tt.ZIndex = 902
	setText(tt, config.Title or "", px + 16, py + 14, 15, t.text, false, false)
	table.insert(d._texts, tt)

	local ly = py + 42
	local contentColor = t.textDim
	for i, line in ipairs(lines) do
		if i <= 5 then
			local ct = newText(TEXT_FONT_BODY)
			ct.ZIndex = 902
			setText(ct, line, px + 16, ly, 12, contentColor, false, false)
			table.insert(d._texts, ct)
			ly = ly + 17
		end
	end

	local btns = config.Buttons or {}
	local bxStart = px + pw - 16
	local by = py + ph - 30
	for i, b in ipairs(btns) do
		if i > 2 then break end
		local bw = textW(b.Title or "", 12) + 32
		bxStart = bxStart - bw
		local bbg = newSquare()
		bbg.ZIndex = 903
		bbg.Corner = 6
		bbg.Color = i == 1 and t.accent or t.elementHover
		setRect(bbg, bxStart, by, bw, 22)
		local btxt = newText(TEXT_FONT_BODY)
		btxt.ZIndex = 904
		setText(btxt, b.Title, bxStart + bw / 2, by + 4, 12, i == 1 and t.titleBarText or t.text, true, false)
		table.insert(d._buttons, { bg = bbg, text = btxt, title = b.Title, x = bxStart, y = by, w = bw, h = 22, cb = b.Callback })
		bxStart = bxStart - 8
	end

	d._step = function(dt)
		if d._closed then return end
		local thx = theme()
		d._overlay.Visible = true
		d._panel.Visible = true
		d._panel.Color = thx.content
		for _, b in ipairs(d._buttons) do
			local hovBtn = hit(state.MouseX, state.MouseY, b.x, b.y, b.w, b.h)
			if b.bg.Visible == false then
				b.bg.Visible = true
				b.text.Visible = true
			end
			b.bg.Color = b.cb and (b.title == (btns[1] and btns[1].Title or "")) and thx.accent or (hovBtn and thx.elementHover or thx.elementPress)
			b.bg.Visible = true
			b.text.Visible = true
			b.text.Color = b.title == (btns[1] and btns[1].Title or "") and thx.titleBarText or thx.text
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
		for _, tx in ipairs(d._texts) do tx:Remove() end
		for _, b in ipairs(d._buttons) do
			b.bg:Remove()
			b.text:Remove()
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
		if win.MinimizeKey then
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
	Size = Vector2.new(640, 500),
	MinSize = Vector2.new(520, 400),
	Resize = false,
	TabWidth = 154,
	Theme = "Dark",
	Translucent = true,
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
	config.Size = pixelDim(config.Size) or Vector2.new(580, 460)
	config.MinSize = pixelDim(config.MinSize) or Vector2.new(470, 380)

	if config.Resize then
		local kx = winViewW / 1920
		local ky = winViewH / 1080
		config.Size = config.Size and Vector2.new(config.Size.X * kx, config.Size.Y * ky) or Vector2.new(580, 460)
		config.MinSize = config.MinSize and Vector2.new(config.MinSize.X * kx, config.MinSize.Y * ky) or Vector2.new(470, 380)
		config.TabWidth = intRound(config.TabWidth * kx)
	end

	themeName = config.Theme or "Dark"
	if not Themes[themeName] then themeName = "Dark" end
	translucent = config.Translucent ~= false

	win = buildWindow(config)
	win.config = config
	win.UpdateMinKey = config.MinimizeKey
	win.MinimizeKey = type(config.MinimizeKey) == "number" and config.MinimizeKey or vkFromName(config.MinimizeKey) or EndC

	chrome.bg = newSquare()
	chrome.accent = newSquare()
	chrome.title = newSquare()
	chrome.titleText = newText(TEXT_FONT_TITLE)
	chrome.subText = newText(TEXT_FONT_BODY)
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
	chrome.pageBar = newSquare()
	chrome.pageTitle = newText(TEXT_FONT_TITLE)
	chrome.pageSub = newText(TEXT_FONT_BODY)

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
	Nebula.Unloaded = true
	Nebula.Loaded = false
	if conn then
		conn:Disconnect()
		conn = nil
	end
	if win then
		for _, t in ipairs(win.Tabs) do
			if t.chrome then
				t.chrome.bg:Remove()
				t.chrome.text:Remove()
				t.chrome.color:Remove()
			end
			for _, node in ipairs(t.nodes) do
				if node.kind == "element" and node.element._destroyDrawings then
					node.element:_destroyDrawings()
				elseif node.kind == "section" and node.section.text then
					node.section.text:Remove()
				end
			end
		end
	end
	for _, d in pairs(chrome) do
		if type(d) == "table" and d.Remove then d:Remove() end
	end
	for _, slot in ipairs(notifPool) do
		slot.bg:Remove()
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
		Nebula:Notify({ Title = "Config saved", Content = name, Duration = 3 })
		return true
	end
	return false
end

function Nebula:LoadConfig(name)
	if not isfile(FOLDER .. "/" .. name .. ".json") then
		Nebula:Notify({ Title = "Config not found", Content = tostring(name), Duration = 3 })
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
	Nebula:Notify({ Title = "Config loaded", Content = tostring(name), Duration = 3 })
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
				Nebula:Notify({ Title = "Autoload set", Content = name, Duration = 3 })
			end
		end,
	})
end

_G.Nebula = Nebula
return Nebula
