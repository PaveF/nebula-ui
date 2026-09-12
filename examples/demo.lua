-- Nebula UI — full demo
-- Usage: copy nebula_ui.lua next to this file (or workspace) and run in Matcha.
-- loadstring(readfile("nebula_ui.lua"))()  ->  global 'Nebula'

loadstring(readfile("nebula_ui.lua"))()

local Nebula = _G.Nebula

local win = Nebula:CreateWindow({
    Title    = "My Script",
    SubTitle = "v1.0.0",
    Size     = Vector2.new(620, 440),
    Theme    = "Dark",
    Translucent = true,
    MinimizeKey = "End",
    AutoStep = true,
})

local combat = win:AddTab("Combat")
local visuals = win:AddTab({ Title = "Visuals" })
local cfg = win:AddTab("Config")

-- Buttons ----------------------------------------------------
combat:AddButton({
    Title       = "Kill Aura",
    Description = "Aura around all players",
    Callback    = function()
        Nebula:Notify { Title = "Kill Aura", Content = "toggled", Duration = 3 }
    end,
})

combat:AddButton({
    Title = "Bypass",
    Callback = function()
        Nebula:Notify { Title = "Bypass", Content = "unimplemented", Duration = 3 }
    end,
})

-- Toggles ----------------------------------------------------
combat:AddToggle({
    Title    = "Aimbot",
    Id       = "aimbot",
    Default  = true,
    Callback = function(v) print("[aimbot]", v) end,
})

combat:AddToggle({
    Title    = "Aimbot (Not Humanoids)",
    Default  = false,
    Callback = function() end,
})

combat:AddToggle({
    Title    = "Team Check",
    Default  = true,
    Callback = function() end,
})

combat:AddToggle({
    Title = "Team Color Circle",
    Default = false,
    Callback = function() end,
})

combat:AddToggle({
    Title    = "Predict Movement",
    Default  = false,
    Callback = function() end,
})

combat:AddToggle({
    Title    = "Flick",
    Default  = true,
    Callback = function() end,
})

-- combos (dropdowns) ------------------------------------------
combat:AddDropdown({
    Title    = "Aimbot Type",
    Values   = { "Camera", "Closest", "FOV" },
    Default  = "Camera",
    Callback = function(v) print("[aimbot type]", v) end,
})

combat:AddDropdown({
    Title    = "Keybind for FOV (in-combination)",
    Values   = { "none", "E", "Q", "F", "X", "Left SHIFT" },
    Default  = "Left SHIFT",
    Callback = function(v) print("[fov bind]", v) end,
})

combat:AddDropdown({
    Title      = "Aimbot Team",
    Values     = { "Enemy", "All", "Enemy + Friendly Fire" },
    Default    = "Enemy",
    Multi      = false,
    Callback   = function(v) print("[team]", v) end,
})

-- sliders -----------------------------------------------------
combat:AddSlider({
    Title     = "FOV",
    Min       = 1,
    Max       = 120,
    Default   = 60,
    Rounding  = 0,
    Callback  = function(v) print("[fov]", v) end,
})

combat:AddSlider({
    Title     = "Smoothness",
    Min       = 0,
    Max       = 1,
    Default   = 0.5,
    Rounding  = 2,
    Callback  = function(v) print("[smooth]", v) end,
})

-- input -------------------------------------------------------
combat:AddInput({
    Title       = "Kill Tag",
    Placeholder = "put a tag here",
    Value       = "you",
    Textbox     = true,
    Callback    = function(v) print("[tag]", v) end,
})

-- keybinds ----------------------------------------------------
visuals:AddKeybind({
    Title           = "Teleport Bind",
    Id              = "tpKey",
    Default         = "F",
    Mode            = "Always",
    Callback        = function(state) print("[tp]", state) end,
})

-- colorpickers ------------------------------------------------
visuals:AddColorpicker({
    Title   = "Aura Color",
    Default = Color3.fromRGB(120, 200, 255),
    Callback = function(c, a) print("[aura color]", c, a) end,
})

visuals:AddColorpicker({
    Title    = "Aim FOV Color",
    Default  = Color3.fromRGB(255, 80, 80),
    Callback = function(c, a) print("[fov color]", c, a) end,
})

-- paragraphs --------------------------------------------------
visuals:AddParagraph({
    Title   = "About",
    Content = "Dolphin themed solars.\nThis is a paragraph element.",
})

-- sections ----------------------------------------------------
local rendering = visuals:AddSection("Rendering")
rendering:AddToggle({ Title = "Chams", Id = "chams", Default = true })
rendering:AddSlider({ Title = "Ambient", Min = 0, Max = 255, Default = 100, Callback = function(v) print("[ambient]", v) end })

-- prebuilt config / interface --------------------------------
win:BuildInterfaceSection(cfg)
win:BuildConfigSection(cfg)

win:SelectTab(1)

-- programmatic control ----------------------------------------
-- win:Minimize()                      -- collapse to rail
-- win:Maximize()                      -- expand
-- Nebula:Notify { Title = "Loaded", Content = "Nebula demo ready", Duration = 3 }
-- Nebula:SaveConfig("my_profile")     -- writes Nebula/my_profile.json
-- Nebula:LoadConfig("my_profile")
-- Nebula:SetTheme("Neon")