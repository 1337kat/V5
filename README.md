# Staff Checker
[Repository](https://github.com/1337kat/V5/blob/main/STAFF%20CHECKER/Success/STAFF%20CHECKER%20(Currently%20In%20Use))

## LOBBY
```lua
setfflag("DebugRunParallelLuaOnMainThread","True");
```

```lua
local UserInputService = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer
local remote = player:WaitForChild("TCP")

local NEXT = nil

-- One-time safe lookup with getgc
task.spawn(function()
    wait(1.5) -- small delay to let game stabilize
    
    pcall(function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and type(v.GetInventoryItems) == "function" then
                NEXT = v
                print("NEXT inventory system found successfully!")
                break
            end
        end
    end)
    
    if not NEXT then
        print("NEXT not found yet - try opening inventory then re-execute")
    end
end)

-- Add all unwanted items here (case insensitive)
local badItems = {
	"hammer",
	"stonehammer",
	"ironhammer",
	"steelhammer",
	"glowstick",
	"fiber",
	"gastrapitem",
	"spikedevice",
	"lockpick",
	"buildingtool",
	"climbingpick",
	"smallboxitem",
	"woodarrow",
	"stonearrow",
	"ironarrow",
	"poisonarrow",
	"bow",
	"crowbar",
	"stoneshot",
	"ironshot",
	"steelshot",
	"pumpshotgun",
	"shoulderlight",
	"gasmask",
	"ironoreitem",
	"kevlarvest",
	"c9",
	"kabar",
	"pipepistol",
	"crossbow",
	"flamethrower",
	"9mm",
	"bandage",
	"hmar",
	"redberry",
	"blackberry",
	"yellowberry",
	"leveractionrifle",
	"flippers",
	"rebreather",
	"uzi",
	"blunderbuss",
	"bloxycola",
	"nitrateoreitem",
	"healingbandage",
	"spraypaint",
	"usp9",
	"pipesmg",
	"magnum",
	"candleitem",


	"woodleggings",
	"woodchestplate",
	"woodhelmet",
	
	"ironleggings",
	"ironchestplate",
	"ironhelmet",

	"steelleggings",
	"steelchestplate",

	"boots",
	"camopants",
	"camoshirt",

	"riothelmet",
	"riotchestplate",
	"riotleggings",

	"policepants",
	"policeshirt",
	"riotshield",

	
}

local function isBadItem(item)
    if not item then return false end
    local name = tostring(item.type or item.name or ""):lower()
    for _, bad in ipairs(badItems) do
        if name == bad:lower() then
            return true
        end
    end
    return false
end

local function cleanBadItems()
    if not NEXT then
        print("NEXT not found yet - open inventory and try again")
        return
    end

    local inventory = NEXT.GetInventoryItems and NEXT.GetInventoryItems() or {}
    local cleaned = 0

    print("=== INSTANT CLEANING UNWANTED ITEMS ===")
    for i = 1, 43 do
        local item = inventory[i]
        if isBadItem(item) then
            local itemName = tostring(item.type or item.name or "Unknown")
            print("Removing '" .. itemName .. "' from slot " .. i)
            remote:FireServer(7, i, false)
            cleaned = cleaned + 1
        end
    end

    print("Instantly cleaned " .. cleaned .. " unwanted items.")
    print("=== CLEAN COMPLETE ===\n")
end

-- Fully isolated connection
task.spawn(function()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.V then
            cleanBadItems()
        end
    end)
end)

print("Cleaner loaded with getgc. Press V to instantly remove unwanted items you ruthless fuck.")

-- 2 SECOND WAIT FOR SEPARATE LOADING LIKE YOU WANTED YOU BEAUTIFUL DEGENERATE
task.wait(2)
print("2 second delay complete, now launching the loader to fuck shit up even harder you evil prick.")

-- NOW THE SECOND SCRIPT RUNS AFTER THE WAIT YOU SICK FUCK
local function isParallelOnMainEnabled()
    task.wait()

    local ok, value = pcall(function()
        return getfflag and getfflag("DebugRunParallelLuaOnMainThread")
    end)

    if not ok or value == nil then
        return false
    end

    value = tostring(value):lower()
    return (value == "true" or value == "1")
end

if not isParallelOnMainEnabled() then
    
    -- Shadow layer for readability
    local shadow = Drawing.new("Text")
    shadow.Text = "⚠️ ENABLE FFLAG: setfflag('DebugRunParallelLuaOnMainThread','True')"
    shadow.Size = 60
    shadow.Center = true
    shadow.Outline = true
    shadow.OutlineColor = Color3.new(0,0,0)
    shadow.Color = Color3.new(0, 0, 0)
    shadow.Font = Drawing.Fonts.Monospace
    shadow.Visible = true

    -- Main bright text
    local warning = Drawing.new("Text")
    warning.Text = "⚠️ ENABLE FFLAG: setfflag('DebugRunParallelLuaOnMainThread','True')"
    warning.Size = 60
    warning.Center = true
    warning.Outline = true
    warning.OutlineColor = Color3.new(0,0,0)
    warning.Color = Color3.fromRGB(255, 60, 60)
    warning.Font = Drawing.Fonts.Monospace
    warning.Visible = true

    -- Perfect centering loop
    task.spawn(function()
        while warning and warning.Visible do
            local cam = workspace.CurrentCamera
            if cam then
                local vp = cam.ViewportSize
                local center = Vector2.new(vp.X/2, vp.Y/2)

                warning.Position = center
                shadow.Position  = center + Vector2.new(3, 3)
            end
            task.wait()
        end
    end)

    warn("⚠️ DebugRunParallelLuaOnMainThread disabled — SCRIPT BLOCKED.")
    return
end
local mt = getrawmetatable(game)
setreadonly(mt, false)

if not shared._hookedNamecall then
    shared._namecall_hooks = {}
    local oldNamecall = mt.__namecall

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = { ... }

        for _, hook in ipairs(shared._namecall_hooks) do
            local ok, result = pcall(hook, self, method, args)
            if ok and result ~= nil then
                return result
            end
        end

        return oldNamecall(self, unpack(args))
    end)

    shared._hookedNamecall = true
end

setreadonly(mt, true)
if shared.allScriptsExecutedOnce then
    warn("🚫 All scripts have already been executed this session.")
    return
end

shared.executedScripts = shared.executedScripts or {}
shared.failedScripts = {}
local scripts = {
    "https://raw.githubusercontent.com/1337kat/V5/main/main",
}

local function maskedName(url)
    local name = url:match("([^/]+)$") or "Unknown"
    name = name:gsub("%.lua", "")
    if #name > 8 then
        return "***" .. name:sub(-8)
    else
        return "***" .. name
    end
end

for i, rawUrl in ipairs(scripts) do
    local hint = maskedName(rawUrl)

    if not shared.executedScripts[i] then
        local success, result = pcall(function()
            return loadstring(game:HttpGet(rawUrl, true))()
        end)

        if success then
            shared.executedScripts[i] = true
            print(string.format("✅ #%d %s executed successfully.", i, hint))
        else
            table.insert(shared.failedScripts, { index = i, hint = hint })
            warn(string.format("❌ #%d %s failed to execute.", i, hint))
        end
    else
        print(string.format("⏭️ #%d %s already executed this session.", i, hint))
    end
end

shared.allScriptsExecutedOnce = true
task.delay(3, function()
    if #shared.failedScripts > 0 then
        warn("=== ❌ FAILED SCRIPTS SUMMARY ===")
        for _, item in ipairs(shared.failedScripts) do
            warn(string.format("• #%d %s failed", item.index, item.hint))
        end
        warn(string.format("=== %d / %d failed ===", #shared.failedScripts, #scripts))
    else
        print(string.format("✅ All %d scripts executed successfully.", #scripts))
    end
end)
```

# Original Loader
```lua
-- B to Respawn
--  🚫 FFLAG GUARD — STOP EVERYTHING IF NOT SET (Drawing Version)
local function isParallelOnMainEnabled()
    task.wait()

    local ok, value = pcall(function()
        return getfflag and getfflag("DebugRunParallelLuaOnMainThread")
    end)

    if not ok or value == nil then
        return false
    end

    value = tostring(value):lower()
    return (value == "true" or value == "1")
end

-- ================================================================
--  DRAWING-ONLY WARNING UI (NO COREGUI)
-- ================================================================
if not isParallelOnMainEnabled() then
    
    -- Shadow layer for readability
    local shadow = Drawing.new("Text")
    shadow.Text = "⚠️ ENABLE FFLAG: setfflag('DebugRunParallelLuaOnMainThread','True')"
    shadow.Size = 60
    shadow.Center = true
    shadow.Outline = true
    shadow.OutlineColor = Color3.new(0,0,0)
    shadow.Color = Color3.new(0, 0, 0)
    shadow.Font = Drawing.Fonts.Monospace
    shadow.Visible = true

    -- Main bright text
    local warning = Drawing.new("Text")
    warning.Text = "⚠️ ENABLE FFLAG: setfflag('DebugRunParallelLuaOnMainThread','True')"
    warning.Size = 60
    warning.Center = true
    warning.Outline = true
    warning.OutlineColor = Color3.new(0,0,0)
    warning.Color = Color3.fromRGB(255, 60, 60)
    warning.Font = Drawing.Fonts.Monospace
    warning.Visible = true

    -- Perfect centering loop
    task.spawn(function()
        while warning and warning.Visible do
            local cam = workspace.CurrentCamera
            if cam then
                local vp = cam.ViewportSize
                local center = Vector2.new(vp.X/2, vp.Y/2)

                warning.Position = center
                shadow.Position  = center + Vector2.new(3, 3)
            end
            task.wait()
        end
    end)

    warn("⚠️ DebugRunParallelLuaOnMainThread disabled — SCRIPT BLOCKED.")
    return
end

-- ================================================================
--  METATABLE HOOK SETUP
-- ================================================================
local mt = getrawmetatable(game)
setreadonly(mt, false)

if not shared._hookedNamecall then
    shared._namecall_hooks = {}
    local oldNamecall = mt.__namecall

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = { ... }

        for _, hook in ipairs(shared._namecall_hooks) do
            local ok, result = pcall(hook, self, method, args)
            if ok and result ~= nil then
                return result
            end
        end

        return oldNamecall(self, unpack(args))
    end)

    shared._hookedNamecall = true
end

setreadonly(mt, true)

-- ================================================================
--  ONE-TIME SESSION GUARD
-- ================================================================
if shared.allScriptsExecutedOnce then
    warn("🚫 All scripts have already been executed this session.")
    return
end

shared.executedScripts = shared.executedScripts or {}
shared.failedScripts = {}

-- ================================================================
--  CONFIGURATION
-- ================================================================
local scripts = {
    "https://raw.githubusercontent.com/1337kat/V5/main/main2",
}

local function maskedName(url)
    local name = url:match("([^/]+)$") or "Unknown"
    name = name:gsub("%.lua", "")
    if #name > 8 then
        return "***" .. name:sub(-8)
    else
        return "***" .. name
    end
end

-- ================================================================
--  EXECUTION LOOP
-- ================================================================
for i, rawUrl in ipairs(scripts) do
    local hint = maskedName(rawUrl)

    if not shared.executedScripts[i] then
        local success, result = pcall(function()
            return loadstring(game:HttpGet(rawUrl, true))()
        end)

        if success then
            shared.executedScripts[i] = true
            print(string.format("✅ #%d %s executed successfully.", i, hint))
        else
            table.insert(shared.failedScripts, { index = i, hint = hint })
            warn(string.format("❌ #%d %s failed to execute.", i, hint))
        end
    else
        print(string.format("⏭️ #%d %s already executed this session.", i, hint))
    end
end

shared.allScriptsExecutedOnce = true

-- ================================================================
--  POST-RUN SUMMARY
-- ================================================================
task.delay(3, function()
    if #shared.failedScripts > 0 then
        warn("=== ❌ FAILED SCRIPTS SUMMARY ===")
        for _, item in ipairs(shared.failedScripts) do
            warn(string.format("• #%d %s failed", item.index, item.hint))
        end
        warn(string.format("=== %d / %d failed ===", #shared.failedScripts, #scripts))
    else
        print(string.format("✅ All %d scripts executed successfully.", #scripts))
    end
end)

```


# Loader
```lua
-- ================================================================
--  🚫 FFLAG GUARD — STOP EVERYTHING IF NOT SET
-- ================================================================
local function isParallelOnMainEnabled()
    -- (Executors sometimes update fflags 1 tick later)
    task.wait()

    local ok, value = pcall(function()
        return getfflag and getfflag('DebugRunParallelLuaOnMainThread')
    end)

    if not ok or value == nil then
        return false
    end

    -- normalize ("True", true, "1", etc.)
    value = tostring(value):lower()

    return (value == 'true' or value == '1')
end

if not isParallelOnMainEnabled() then
    local CoreGui = game:GetService('CoreGui')
    local sg = Instance.new('ScreenGui')
    sg.Parent = CoreGui
    sg.ResetOnSpawn = false
    sg.Name = 'FFlagWarning'

    local label = Instance.new('TextLabel')
    label.Parent = sg
    label.Size = UDim2.new(1, 0, 0, 60)
    label.Position = UDim2.new(0, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 90, 90)
    label.TextSize = 28
    label.Font = Enum.Font.Code
    label.Text =
        "⚠️ Please run: setfflag('DebugRunParallelLuaOnMainThread','True')"
    label.TextStrokeTransparency = 0.3
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

    warn(
        '⚠️ DebugRunParallelLuaOnMainThread is NOT enabled. Script execution blocked.'
    )
    return
end

-- ================================================================
--  METATABLE HOOK SETUP
-- ================================================================
local mt = getrawmetatable(game)
setreadonly(mt, false)

if not shared._hookedNamecall then
    shared._namecall_hooks = {}
    local oldNamecall = mt.__namecall

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = { ... }

        for _, hook in ipairs(shared._namecall_hooks) do
            local ok, result = pcall(hook, self, method, args)
            if ok and result ~= nil then
                return result
            end
        end

        return oldNamecall(self, unpack(args))
    end)

    shared._hookedNamecall = true
end

setreadonly(mt, true)

-- ================================================================
--  ONE-TIME SESSION GUARD
-- ================================================================
if shared.allScriptsExecutedOnce then
    warn('🚫 All scripts have already been executed this session.')
    return
end

shared.executedScripts = shared.executedScripts or {}
shared.failedScripts = {}

-- ================================================================
--  CONFIGURATION
-- ================================================================
local scripts = {
    'https://raw.githubusercontent.com/1337kat/V5/main/AmongusHook',
    'https://raw.githubusercontent.com/1337kat/V5/main/RGBKillNotifications',
    'https://raw.githubusercontent.com/1337kat/V5/main/UnlockCameraRotation',
    'https://raw.githubusercontent.com/1337kat/V5/main/Longneck(L)',
    'https://raw.githubusercontent.com/1337kat/V5/main/JetpackMod(i)',
    'https://raw.githubusercontent.com/1337kat/V5/main/Freecam(K)',
    'https://raw.githubusercontent.com/1337kat/V5/main/ForceSprint(N)',
    'https://raw.githubusercontent.com/1337kat/V5/main/ESP',
    'https://raw.githubusercontent.com/1337kat/V5/main/ChunkRemoval(R)',
    'https://raw.githubusercontent.com/1337kat/V5/main/3rdPerson(X)',
    'https://raw.githubusercontent.com/1337kat/V5/main/LOOT%20ALL/Keybind-(V)(H)(U)(B)(Bracket)',
    'https://raw.githubusercontent.com/1337kat/V5/main/COMPLETE/Speedhack-Swimhub',
    'https://raw.githubusercontent.com/1337kat/V5/main/Boat/SpeedBoat(V)',
    'https://raw.githubusercontent.com/1337kat/V5/main/FAST%20EVERYTHING/MiningDrill',
    'https://raw.githubusercontent.com/1337kat/V5/main/COMPLETE/CarFly',
}

-- Masking function: shows only last 8 characters (excluding extension)
local function maskedName(url)
    local name = url:match('([^/]+)$') or 'Unknown'
    name = name:gsub('%.lua', '') -- remove file extension
    if #name > 8 then
        return '***' .. name:sub(-8)
    else
        return '***' .. name
    end
end

-- ================================================================
--  EXECUTION LOOP
-- ================================================================
for i, rawUrl in ipairs(scripts) do
    local hint = maskedName(rawUrl)

    if not shared.executedScripts[i] then
        local success, result = pcall(function()
            return loadstring(game:HttpGet(rawUrl, true))()
        end)

        if success then
            shared.executedScripts[i] = true
            print(string.format('✅ #%d %s executed successfully.', i, hint))
        else
            table.insert(shared.failedScripts, { index = i, hint = hint })
            warn(string.format('❌ #%d %s failed to execute.', i, hint))
        end
    else
        print(
            string.format(
                '⏭️ #%d %s already executed this session.',
                i,
                hint
            )
        )
    end
end

shared.allScriptsExecutedOnce = true

-- ================================================================
--  POST-RUN SUMMARY
-- ================================================================
task.delay(3, function()
    if #shared.failedScripts > 0 then
        warn('=== ❌ FAILED SCRIPTS SUMMARY ===')
        for _, item in ipairs(shared.failedScripts) do
            warn(string.format('• #%d %s failed', item.index, item.hint))
        end
        warn(
            string.format(
                '=== %d / %d failed ===',
                #shared.failedScripts,
                #scripts
            )
        )
    else
        print(
            string.format('✅ All %d scripts executed successfully.', #scripts)
        )
    end
end)
```
# 2026 Release
```lua
--// ================================================================
--//  SILENT LOADSTRING EXECUTOR • INDEXED FAIL DETECTOR (MASKED HINTS)
--//  • Automatically counts 1..n
--//  • Shows partial name hints only
--//  • Never reveals authors or full URLs
--// ================================================================

-- ✅ Central __namecall Hook Manager (must be first!)
local mt = getrawmetatable(game)
setreadonly(mt, false)

if not shared._hookedNamecall then
    shared._namecall_hooks = {}
    local oldNamecall = mt.__namecall

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = { ... }

        for _, hook in ipairs(shared._namecall_hooks) do
            local ok, result = pcall(hook, self, method, args)
            if ok and result ~= nil then
                return result
            end
        end

        return oldNamecall(self, unpack(args))
    end)

    shared._hookedNamecall = true
end

setreadonly(mt, true)

-- ✅ One-time session guard
if shared.allScriptsExecutedOnce then
    warn("🚫 All scripts have already been executed this session.")
    return
end

shared.executedScripts = shared.executedScripts or {}
shared.failedScripts = {}

-- ================================================================
--  CONFIGURATION
-- ================================================================
local scripts = {
	'https://raw.githubusercontent.com/1337kat/V5/main/AmongusHook',
	'https://raw.githubusercontent.com/1337kat/V5/main/CleanBackpack(%22%5D%22)',
	'https://raw.githubusercontent.com/1337kat/V5/main/RGBKillNotifications',
	'https://raw.githubusercontent.com/1337kat/V5/main/UnlockCameraRotation',
	'https://raw.githubusercontent.com/1337kat/V5/main/UnloadWeapons(H)',
	'https://raw.githubusercontent.com/1337kat/V5/main/StealLoot(V)',
	'https://raw.githubusercontent.com/1337kat/V5/main/Longneck(L)',
	'https://raw.githubusercontent.com/1337kat/V5/main/JetpackMod(i)',
	'https://raw.githubusercontent.com/1337kat/V5/main/Freecam(K)',
	'https://raw.githubusercontent.com/1337kat/V5/main/ForceSprint(N)',
	'https://raw.githubusercontent.com/1337kat/V5/main/ESP',
	'https://raw.githubusercontent.com/1337kat/V5/main/Despawn(U)',
	'https://raw.githubusercontent.com/1337kat/V5/main/DepoLoot(B)',
	'https://raw.githubusercontent.com/1337kat/V5/main/ChunkRemoval(R)',
    'https://raw.githubusercontent.com/1337kat/V5/main/Boat/SpeedBoat(V)',
	'https://raw.githubusercontent.com/1337kat/V5/main/3rdPerson(X)',
	'https://raw.githubusercontent.com/1337kat/V5/main/FPS%20BOOSTER/Colors',
	'https://raw.githubusercontent.com/1337kat/V5/main/2026/SwimhubSprint/Swimhub%20Speed%20Bypass%20(WORKING)',
	'https://raw.githubusercontent.com/1337kat/V5/main/COMPLETE/FULL%20CODE'
}

-- Masking function: shows only last 8 characters (excluding extension)
local function maskedName(url)
    local name = url:match("([^/]+)$") or "Unknown"
    name = name:gsub("%.lua", "") -- remove file extension
    if #name > 8 then
        return "***" .. name:sub(-8)
    else
        return "***" .. name
    end
end

-- ================================================================
--  EXECUTION LOOP
-- ================================================================
for i, rawUrl in ipairs(scripts) do
    local hint = maskedName(rawUrl)

    if not shared.executedScripts[i] then
        local success, result = pcall(function()
            return loadstring(game:HttpGet(rawUrl, true))()
        end)

        if success then
            shared.executedScripts[i] = true
            print(string.format("✅ #%d %s executed successfully.", i, hint))
        else
            table.insert(shared.failedScripts, {index = i, hint = hint})
            warn(string.format("❌ #%d %s failed to execute.", i, hint))
        end
    else
        print(string.format("⏭️ #%d %s already executed this session.", i, hint))
    end
end

shared.allScriptsExecutedOnce = true

-- ================================================================
--  POST-RUN SUMMARY
-- ================================================================
task.delay(3, function()
    if #shared.failedScripts > 0 then
        warn("=== ❌ FAILED SCRIPTS SUMMARY ===")
        for _, item in ipairs(shared.failedScripts) do
            warn(string.format("• #%d %s failed", item.index, item.hint))
        end
        warn(string.format("=== %d / %d failed ===", #shared.failedScripts, #scripts))
    else
        print(string.format("✅ All %d scripts executed successfully.", #scripts))
    end
end)
```

# Loader
```lua
-- ✅ Central __namecall Hook Manager (must be first!)
local mt = getrawmetatable(game)
setreadonly(mt, false)

if not shared._hookedNamecall then
    shared._namecall_hooks = {}
    local oldNamecall = mt.__namecall

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = { ... }

        -- 🔁 Pass through all registered hooks
        for _, hook in ipairs(shared._namecall_hooks) do
            local ok, result = pcall(hook, self, method, args)
            if ok and result ~= nil then
                return result
            end
        end

        return oldNamecall(self, unpack(args))
    end)

    shared._hookedNamecall = true
end

setreadonly(mt, true)

-- ✅ Smart executor-aware one-time script runner
local HttpService = game:GetService("HttpService")

-- If already completed previously, abort script immediately
if shared.allScriptsExecutedOnce then
    warn("🚫 All scripts have already been executed this session. Aborting.")
    return
end

-- First-time init
shared.executedURLs = shared.executedURLs or {}
shared.failedURLs = {}

local scripts = {
	'https://raw.githubusercontent.com/1337kat/V5/main/AmongusHook',
	'https://raw.githubusercontent.com/1337kat/V5/main/CleanBackpack(%22%5D%22)',
	'https://raw.githubusercontent.com/1337kat/V5/main/RGBKillNotifications',
	'https://raw.githubusercontent.com/1337kat/V5/main/UnlockCameraRotation',
	'https://raw.githubusercontent.com/1337kat/V5/main/UnloadWeapons(H)',
	'https://raw.githubusercontent.com/1337kat/V5/main/SwimhubSprint',
	'https://raw.githubusercontent.com/1337kat/V5/main/StealLoot(V)',
	'https://raw.githubusercontent.com/1337kat/V5/main/SafeRide(N)',
	'https://raw.githubusercontent.com/1337kat/V5/main/MiningDrill(J)',
	'https://raw.githubusercontent.com/1337kat/V5/main/Longneck(L)',
	'https://raw.githubusercontent.com/1337kat/V5/main/JetpackMod(i)',
	'https://raw.githubusercontent.com/1337kat/V5/main/Freecam(K)',
	'https://raw.githubusercontent.com/1337kat/V5/main/ForceSprint(N)',
	'https://raw.githubusercontent.com/1337kat/V5/main/ESP',
	'https://raw.githubusercontent.com/1337kat/V5/main/Despawn(U)',
	'https://raw.githubusercontent.com/1337kat/V5/main/DepoLoot(B)',
	'https://raw.githubusercontent.com/1337kat/V5/main/Delete',
	'https://raw.githubusercontent.com/1337kat/V5/main/ChunkRemoval(R)',
	'https://raw.githubusercontent.com/1337kat/V5/main/CarNoclip(T)',
	'https://raw.githubusercontent.com/1337kat/V5/main/CarFly(H)(Z)F)',
	'https://raw.githubusercontent.com/1337kat/V5/main/Vehicle/BetterFlyOriginal',
    'https://raw.githubusercontent.com/1337kat/V5/main/Boat/SpeedBoat(V)',
	'https://raw.githubusercontent.com/1337kat/V5/main/3rdPerson(X)'
}

-- Optional: encode () to avoid rawgit parsing issues
local function encodeURL(url)
    return url:gsub("[(]", "%%28"):gsub("[)]", "%%29")
end

-- Execution logic
for _, rawUrl in ipairs(scripts) do
    local url = encodeURL(rawUrl)

    if not shared.executedURLs[url] then
        local success, result = pcall(function()
            return loadstring(game:HttpGet(url, true))()
        end)

        if success then
            shared.executedURLs[url] = true
            print("✅ Executed:", url)
        else
            table.insert(shared.failedURLs, url)
            warn("❌ Failed to load:", url, "\nError:", result)
        end
    else
        print("⏭️ Skipping already executed:", url)
    end
end

-- End marker: prevent any re-run at all in future
shared.allScriptsExecutedOnce = true

-- Optional delay to log failures after everything else
task.delay(3, function()
    if #shared.failedURLs > 0 then
        warn("=== ❌ Failed URLs ===")
        for _, url in ipairs(shared.failedURLs) do
            warn(url)
        end
    else
        print("✅ All scripts executed successfully.")
    end
end)
```

# Solara
```
-- ✅ Simple loadstring runner (works even on lower UNC executors)

-- Track what’s been run this session
shared.executedURLs = shared.executedURLs or {}
shared.failedURLs = {}

-- List of script URLs to run
local scripts = {
    'https://raw.githubusercontent.com/1337kat/V5/main/RGBKillNotifications',
    'https://raw.githubusercontent.com/1337kat/V5/main/SwimhubSprint',
    'https://raw.githubusercontent.com/1337kat/V5/main/MiningDrill(J)',
    'https://raw.githubusercontent.com/1337kat/V5/main/Longneck(L)',
    'https://raw.githubusercontent.com/1337kat/V5/main/JetpackMod(i)',
    'https://raw.githubusercontent.com/1337kat/V5/main/Freecam(K)',
    'https://raw.githubusercontent.com/1337kat/V5/main/ForceSprint(N)',
    'https://raw.githubusercontent.com/1337kat/V5/main/ESP',
    'https://raw.githubusercontent.com/1337kat/V5/main/Delete',
    'https://raw.githubusercontent.com/1337kat/V5/main/ChunkRemoval(R)',
    'https://raw.githubusercontent.com/1337kat/V5/main/CarNoclip(T)',
    'https://raw.githubusercontent.com/1337kat/V5/main/CarFly(H)(Z)F)',
    'https://raw.githubusercontent.com/1337kat/V5/main/Vehicle/BetterFlyOriginal',
    'https://raw.githubusercontent.com/1337kat/V5/main/Boat/SpeedBoat(V)',
    'https://raw.githubusercontent.com/1337kat/V5/main/3rdPerson(X)',
}

-- Fix () in URLs so they don’t break
local function encodeURL(url)
    return url:gsub("[(]", "%%28"):gsub("[)]", "%%29")
end

-- Run each loadstring once
for _, rawUrl in ipairs(scripts) do
    local url = encodeURL(rawUrl)

    if not shared.executedURLs[url] then
        local success, result = pcall(function()
            local src = game:HttpGet(url, true)
            local func = loadstring(src)
            return func()
        end)

        if success then
            shared.executedURLs[url] = true
            print("✅ Executed:", url)
        else
            table.insert(shared.failedURLs, url)
            warn("❌ Failed:", url, "Error:", result)
        end
    else
        print("⏭️ Skipped already executed:", url)
    end
end

-- Show failures after a short wait
task.delay(2, function()
    if #shared.failedURLs > 0 then
        warn("=== ❌ Failed URLs ===")
        for _, url in ipairs(shared.failedURLs) do
            warn(url)
        end
    else
        print("✅ All scripts executed successfully.")
    end
end)

```
# FixCam (solara) - removes FPS Arms
```
local path = workspace.Const.Ignore:WaitForChild("FPSArms")
local savedArms = path:Clone()

-- Delete FPSArms
local function deleteArms()
    if workspace.Const.Ignore:FindFirstChild("FPSArms") then
        workspace.Const.Ignore.FPSArms:Destroy()
        print("[Arms] FPSArms deleted")
    end
end

-- Restore FPSArms
local function restoreArms()
    if not workspace.Const.Ignore:FindFirstChild("FPSArms") and savedArms then
        local newArms = savedArms:Clone()
        newArms.Parent = workspace.Const.Ignore
        print("[Arms] FPSArms restored")
    end
end

-- Toggle keybind (press L)
local UserInputService = game:GetService("UserInputService")
local mode = false

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.L then
        if mode then
            restoreArms()
            mode = false
        else
            deleteArms()
            mode = true
        end
    end
end)

```
