## LOBBY
```lua
setfflag("DebugRunParallelLuaOnMainThread","True");
```

# 2026 Release
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
	'https://raw.githubusercontent.com/1337kat/V5/main/2026/Bhop%2BDowncliff',
	'https://raw.githubusercontent.com/1337kat/V5/main/StealLoot(V)',
	'https://raw.githubusercontent.com/1337kat/V5/main/SafeRide(N)',
	'https://raw.githubusercontent.com/1337kat/V5/main/Longneck(L)',
	'https://raw.githubusercontent.com/1337kat/V5/main/JetpackMod(i)',
	'https://raw.githubusercontent.com/1337kat/V5/main/Freecam(K)',
	'https://raw.githubusercontent.com/1337kat/V5/main/ForceSprint(N)',
	'https://raw.githubusercontent.com/1337kat/V5/main/ESP',
	'https://raw.githubusercontent.com/1337kat/V5/main/Despawn(U)',
	'https://raw.githubusercontent.com/1337kat/V5/main/DepoLoot(B)',
	'https://raw.githubusercontent.com/1337kat/V5/main/ChunkRemoval(R)',
    'https://raw.githubusercontent.com/1337kat/V5/main/Boat/SpeedBoat(V)',
	'https://raw.githubusercontent.com/1337kat/V5/main/CarFly(H)(Z)F)',
	'https://raw.githubusercontent.com/1337kat/V5/main/2026/CarFly(Bypass)',
	'https://raw.githubusercontent.com/1337kat/V5/main/2026/CarFly/CarFly(Currently%20Using)',
	'https://raw.githubusercontent.com/1337kat/V5/main/2026/SafeRide(Update)',
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
