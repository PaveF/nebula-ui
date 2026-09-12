# Nebula UI Library

A WabiSabi-style Drawing-based menu framework for the **Matcha** Roblox executor.

Pure Luau. No `Instance`, no `ScreenGui` — the entire UI renders through the `Drawing` library, which makes it invisible to the game and immune to GUI-based checks. Objects are created once and reused, so it is fully animated and GPU-cheap.

```lua
loadstring(readfile("nebula_ui.lua"))()  -- -> global 'Nebula'
```

---

## Requirements / Host VM

This library is written specifically for **Matcha** (a Luau executor with a custom `Drawing` VM) and will **not** run in a standard Roblox executor:

- There is **no `Instance.new` / `ScreenGui`** — everything is `Drawing` (Square, Text, Circle, Line).
- There is **no `Color3:Lerp`** — the library implements its own `colorLerp` internally; never write `color:Lerp(...)` in scripts.
- `UDim2.X`/`.Y` are UDim userdata; the library converts them to pixel `Vector2` internally via `pixelDim`.
- Keybinds store **string key names** (`"H"`, `"F1"`), **not** `Enum.KeyCode`. Passing an enum breaks config round-trips.
- The sandbox filesystem is `C:/matcha/workspace` (`readfile` / `writefile`). Configs are stored in a `Nebula/` subfolder there.

---

## Quick Start

```lua
loadstring(readfile("nebula_ui.lua"))()

local Nebula = _G.Nebula          -- loadstring(...)() returns 0 values; always read _G.Nebula

local win = Nebula:CreateWindow({
    Title  = "My Script",
    Size   = Vector2.new(620, 440),
    Theme  = "Dark",              -- "Dark" | "Midnight" | "Neon" | "Light"
})

local combat = win:AddTab("Combat")

combat:AddToggle({
    Title    = "Aimbot",
    Id       = "aimbot",          -- Id registers the option with the config system
    Default  = true,
    Callback = function(v) print("aimbot", v) end,
})

win:SelectTab(1)
```

Copy `nebula_ui.lua` into your Matcha workspace (`C:/matcha/workspace/nebula_ui.lua`), then run the script above in Matcha.

---

## `Nebula:CreateWindow(config)`

| Key            | Type / Default     | Notes                                              |
| -------------- | ------------------ | -------------------------------------------------- |
| `Title`        | `string` `"Nebula"`| Window title                                       |
| `SubTitle`     | `string` `""`      | Subtitle under the title                           |
| `Size`         | `Vector2` `580x460`| Initial window size                                |
| `MinSize`      | `Vector2` `470x380`| Minimum size when `Resize` is enabled              |
| `Resize`       | `bool` `false`     | Allow edge drag-resizing                           |
| `TabWidth`     | `number` `160`     | Width of the left tab rail                         |
| `Theme`        | `string` `"Dark"`  | `"Dark"`, `"Midnight"`, `"Neon"`, `"Light"`        |
| `Translucent`  | `bool` `true`      | Background translucency                            |
| `MinimizeKey`  | `string` `"End"`   | Key (string name) that collapses/expands the window |
| `ConfigName`   | `string?`          | Optional persistent config profile                 |
| `AutoStep`     | `bool` `true`      | Run the render loop on RenderStepped automatically  |

Returns the **Window handle** (setmetatable'd) — it has `AddTab`, `SelectTab`, `Dialog`, `BuildInterfaceSection`, `BuildConfigSection`.

> Only one window at a time. Calling `CreateWindow` twice warns and returns `nil` until the first is `Destroy`ed.

---

## Window handle

| Method | Description |
| --- | --- |
| `win:AddTab(nameOrConf)` | Add a tab. `"Combat"` or `{ Title = "Combat", Name = "combat" }`. Returns the Tab handle. |
| `win:SelectTab(index)` | Switches to the tab at `index` (1-based). |
| `win:Dialog({ Title, Content, Buttons })` | Modal dialog, up to 2 buttons. Returns a handle with `:Close()`. |
| `win:BuildInterfaceSection(tab)` | Adds a prebuilt **Theme / Translucent / Resize** dropdown section to a tab. |
| `win:BuildConfigSection(tab)` | Adds a prebuilt **Save / Load / Autoload** section to a tab. |

---

## Tab handle — element adders

`tab:AddButton`, `tab:AddToggle`, `tab:AddSlider`, `tab:AddDropdown`, `tab:AddColorpicker`, `tab:AddInput`, `tab:AddParagraph`, `tab:AddKeybind`, `tab:AddSection(name)` (returns a Section handle).

Every element handle has: `:Get()` → current value, `:SetValue(...)`, `:SetTitle(text)`, `:SetDescription(text)`, `:OnChanged(fn)` (fires immediately + on change).

### `AddButton(config)`
| Key | Type | Notes |
| --- | --- | --- |
| `Title` | `string` | Label |
| `Description` | `string?` | Dim sub-label |
| `Callback` | `fn()` | Fired on click |
| `Id` | `string?` | Optional config registration |

### `AddToggle(config)`
| Key | Type | Notes |
| --- | --- | --- |
| `Title` | `string` | Label |
| `Description` | `string?` | Dim sub-label |
| `Default` | `bool` | Initial state |
| `Callback` | `fn(v)` | Fired on change |
| `Keybind` | `string?` | Optional in-element key toggle, **string name** e.g. `"X"` |
| `Id` | `string?` | Config id |

### `AddSlider(config)`
| Key | Type | Notes |
| --- | --- | --- |
| `Title` | `string` | Label |
| `Min` / `Max` | `number` | Range (default `0`, `100`) |
| `Default` | `number` | Initial value (clamped) |
| `Rounding` | `number` | Decimals to display / snap (default `0`) |
| `Callback` | `fn(v)` | Fired on change |
| `Id` | `string?` | Config id |

### `AddDropdown(config)`
| Key | Type | Notes |
| --- | --- | --- |
| `Title` | `string` | Label |
| `Values` | `string[]` | Options |
| `Default` | `string` | Selected option |
| `Multi` | `bool` | Multi-select (default `false`); with `Multi`, `Value` is a set-like table |
| `Callback` | `fn(v)` | Fired on pick (single) |
| `Id` | `string?` | Config id |

### `AddColorpicker(config)`
| Key | Type | Notes |
| --- | --- | --- |
| `Title` | `string` | Label |
| `Default` | `Color3` | Initial color (`Color3.fromRGB(...)`) |
| `Alpha` | `bool` | Show an alpha slider (default `false`) |
| `Callback` | `fn(c, a)` | Fired on change (`Color3`, alpha `0..1`) |
| `Id` | `string?` | Config id |

> Change programmatically with `handle:SetValueRGB(color, alpha)`.

### `AddInput(config)`
| Key | Type | Notes |
| --- | --- | --- |
| `Title` | `string` | Label |
| `Value` | `string` | Initial text |
| `Placeholder` | `string?` | Dim empty-state text |
| `Textbox` | `bool` | Focusable text field (default `false` → button-ish) |
| `Callback` | `fn(v)` | Fired on submit / change |
| `Id` | `string?` | Config id |

### `AddParagraph(config)`
| Key | Type | Notes |
| --- | --- | --- |
| `Title` | `string?` | Optional label |
| `Content` | `string` | Multi-line body |

### `AddKeybind(config)`
| Key | Type | Notes |
| --- | --- | --- |
| `Title` | `string` | Label |
| `Default` | `string?` | **String key name**: `"H"`, `"F1"`, `"End"`, … (`nil` = unbound) |
| `Mode` | `string` | `"Toggle"` (default), `"Hold"`, `"Always"` |
| `Callback` | `fn(state)` | Fired with `true`/`false` | 
| `ChangedCallback` | `fn(key)` | Fired when the bound key changes |
| `Id` | `string?` | Config id |

> `SetValue("H")` — pass a string, **never** `Enum.KeyCode`. Pressing a key while the field is focused rebinds (`Delete` unbinds, `Esc` cancels). Use `handle:GetState()` to read the live state.

---

## Sections

```lua
local rendering = tab:AddSection("Rendering")
rendering:AddToggle({ Title = "Chams", Id = "chams", Default = true })
rendering:AddSlider({ Title = "Ambient", Id = "amb", Min = 0, Max = 255, Default = 100 })
```

Section handles expose the same 8 `Add*` methods (plus nested `AddSection`); every element in a section behaves identically to one added directly to the tab.

---

## Notifications

```lua
Nebula:Notify({
    Title    = "Aura",
    Content  = "toasted",
    Duration = 3,              -- seconds
    Buttons  = { { Title = "OK", Callback = function() end } },  -- optional
})

local n = Nebula:Notify({ Title = "X", Content = "Y", Duration = 5 })
-- n:Remove() to dismiss early
```

Stacked bottom-right, auto-expire, fully pooled (no per-frame allocation).

---

## Config system

Persisted to `C:/matcha/workspace/Nebula/*.json`. Only elements with an `Id` are saved and restored.

| Function | Description |
| --- | --- |
| `Nebula:SaveConfig(name)` | Writes `Nebula/<name>.json` with every `Id`-registered option |
| `Nebula:LoadConfig(name)` | Applies a saved profile back onto the elements |
| `Nebula:GetConfigs()` | Returns sorted `string[]` of saved profile names |
| `Nebula:SetAutoload(name)` | Auto-load `name` in future sessions |
| `Nebula:LoadAutoloadConfig()` | Applies the autoload profile now |
| `Nebula:SetFolder(path)` | Change the config folder (default `"Nebula"`) |
| `Nebula:SetIgnoreIndexes({...})` | Skip saving specific `Id`s |

Everything round-trips cleanly: booleans, numbers, strings, dropdown selections (incl. multi), colors **with alpha**, and keybinds.

---

## Themes

| Function | Description |
| --- | --- |
| `Nebula:GetTheme()` | Current theme name |
| `Nebula:SetTheme(name)` | Apply a theme (`"Dark"`, `"Midnight"`, `"Neon"`, `"Light"`) |
| `Nebula.Themes` | `string[]` of available theme names |
| `Nebula:SetTranslucent(v)` | Toggle translucency at runtime |

---

## Window / lifecycle

| Function | Description |
| --- | --- |
| `win:Minimize()` / `Nebula:Minimize()` | Collapse to the tab rail |
| `win:Maximize()` / `Nebula:Maximize()` | Expand back |
| `Nebula:Destroy()` | Remove all drawings, disconnect the render loop, allow a new window |
| `Nebula:OnUnload(fn)` / `OnMinimized` / `OnMaximized` / `OnThemeChanged` | Lifecycle callbacks |

`Nebula.Loaded` / `Nebula.Unloaded` reflect window state.

---

## Giving this to an AI to build a script

1. Push this folder to a GitHub repo (see setup in the section below).
2. Tell the AI:
   - Follow `README.md` for the API.
   - **It must not** use `Instance.new`, `ScreenGui`, `TweenService`, `Color3:Lerp`, `Enum.KeyCode` for keybinds, or `getgenv` — this is the Matcha Drawing VM.
   - Read values from element handles (`.Value` / `:Get()`) instead of QoL globals.
3. For a local coding AI (Claude Code, Cursor, Copilot), clone the repo and point the prompt at the `nebula_ui.lua` + `README.md` files.

---

## License

[MIT](./LICENSE). Heavily inspired by the WabiSabi drawing UI pattern.