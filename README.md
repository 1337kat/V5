## LOBBY
```lua
setfflag("DebugRunParallelLuaOnMainThread","True");
```

# Testing
```
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
    'https://raw.githubusercontent.com/1337kat/V5/main/FPS%20BOOSTER/Colors',
    'https://raw.githubusercontent.com/1337kat/V5/main/LOOT%20ALL/Keybind-(V)(H)(U)(B)(Bracket)',
    'https://raw.githubusercontent.com/1337kat/V5/main/COMPLETE/Speedhack-Swimhub',
	'https://raw.githubusercontent.com/1337kat/V5/main/Boat/SpeedBoat(V)',
    'https://raw.githubusercontent.com/1337kat/V5/main/COMPLETE/CarFly'
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
