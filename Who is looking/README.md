# based on this script:
```lua
local headSize = 9

local function createHeadIndicator(hrp)
    local boxAdornment = Instance.new("BoxHandleAdornment", hrp.Head)
    boxAdornment.Color3 = Color3.new(0.000000, 0.517647, 1.000000)
    boxAdornment.Adornee = hrp.Head
    boxAdornment.AlwaysOnTop = true
    boxAdornment.ZIndex = 10
    boxAdornment.Transparency = 0
    boxAdornment.Size = Vector3.new(5, 5, 5)
end

local function updateHeadSize(character)
    if character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Head") then
        local head = character.Head
        head.Size = Vector3.new(headSize, headSize, headSize)
        head.Transparency = 0.2
        head.Color = Color3.fromRGB(123, 222, 78)
        head.CanCollide = false
        createHeadIndicator(character)
    end
end

-- Update existing characters in the workspace
for _, obj in pairs(workspace:GetChildren()) do
    if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
        updateHeadSize(obj)
    end
end

-- Automatically update new characters when they are added to the workspace
workspace.ChildAdded:Connect(function(child)
    task.wait(0.1) -- Small delay to ensure parts are fully loaded
    if child:IsA("Model") and child:FindFirstChild("HumanoidRootPart") then
        updateHeadSize(child)
    end
end)
```

# Original (UNIVERSAL)
```
--========================================================--
--   MINIMAL AWARENESS SYSTEM (LOW / MED / HIGH TRIANGLES)
--   • LOW → White triangle
--   • MED → Yellow triangle + Warning
--   • HIGH → Big red triangle + Strong warning
--========================================================--

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local LocalPlayer  = Players.LocalPlayer
local Workspace    = game:GetService("Workspace")

-- CONFIG
local FOV_ANGLE      = 45
local MAX_DIST       = 120
local PERSIST_TIME   = 2.5
local THREAT_MIN     = 0.03

local ANGLE_WEIGHT   = 0.5
local DIST_WEIGHT    = 0.2
local PERSIST_WEIGHT = 0.3

-- CLEANUP
if getgenv().A_TRI then for _,v in ipairs(getgenv().A_TRI) do v:Remove() end end
if getgenv().A_TRI_CONN then getgenv().A_TRI_CONN:Disconnect() end
if getgenv().A_CONN then getgenv().A_CONN:Disconnect() end
if getgenv().A_WARN then getgenv().A_WARN:Remove() end

getgenv().A_TRI = {}

-- UTIL
local function angleTo(fromCF, toPos)
    local look = fromCF.LookVector
    local dir = (toPos - fromCF.Position)
    local m = dir.Magnitude
    if m < 1e-6 then return 180 end
    dir = dir / m
    local dot = math.clamp(look:Dot(dir), -1, 1)
    return math.deg(math.acos(dot))
end

local function lerpColor(c1, c2, t)
    return Color3.new(
        c1.R + (c2.R - c1.R) * t,
        c1.G + (c2.G - c1.G) * t,
        c1.B + (c2.B - c1.B) * t
    )
end

-- WATCHERS
local watchers = {}

--========================================================--
--   TOP-CENTER WARNING TEXT
--========================================================--
local warn = Drawing.new("Text")
warn.Size = 32
warn.Center = true
warn.Outline = true
warn.OutlineColor = Color3.new(0,0,0)
warn.Visible = false
getgenv().A_WARN = warn

--========================================================--
--   MAIN THREAT LOOP
--========================================================--
getgenv().A_CONN = RunService.Heartbeat:Connect(function(dt)

    local char = LocalPlayer.Character
    if not char then return end

    local head = char:FindFirstChild("Head")
    local root = char:FindFirstChild("HumanoidRootPart")
    local myPos = head and head.Position or (root and root.Position)
    if not myPos then return end

    local cam = Workspace.CurrentCamera
    warn.Position = Vector2.new(cam.ViewportSize.X / 2, 40)

    local now = os.clock()

    -- Compute threats
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not plr.Character then continue end
        
        local h = plr.Character:FindFirstChild("Head")
        local r = plr.Character:FindFirstChild("HumanoidRootPart")
        local ref = h or r
        if not ref then continue end

        if not watchers[plr] then
            watchers[plr] = { lookTime = 0, lastSeen = now, threat = 0 }
        end

        local info = watchers[plr]
        local angle = angleTo(ref.CFrame, myPos)
        local dist  = (ref.Position - myPos).Magnitude
        local facing = angle <= FOV_ANGLE

        if facing then
            info.lookTime += dt
            info.lastSeen = now

            local angleScore   = 1 - math.clamp(angle / FOV_ANGLE, 0,1)
            local distScore    = 1 - math.clamp(dist / MAX_DIST, 0,1)
            local persistScore = math.clamp(info.lookTime / PERSIST_TIME,0,1)

            info.threat =
                angleScore   * ANGLE_WEIGHT +
                distScore    * DIST_WEIGHT +
                persistScore * PERSIST_WEIGHT
            
            info.threat = math.clamp(info.threat, 0, 1)
        else
            info.lookTime = math.max(0, info.lookTime - dt * 0.5)
            info.threat  = math.max(0, info.threat  - dt * 0.3)
        end
    end

    -- prune
    for plr, info in pairs(watchers) do
        if not plr.Character or (now - info.lastSeen > 8 and info.threat <= THREAT_MIN) then
            watchers[plr] = nil
        end
    end

    -- highest threat
    local topThreat = 0
    for _, info in pairs(watchers) do
        if info.threat > topThreat then topThreat = info.threat end
    end

    --========================================================--
    -- WARNING LOGIC
    --========================================================--
    if topThreat >= 0.75 then
        warn.Text = "YOU ARE BEING WATCHED"
        warn.Color = Color3.new(1,0,0)
        warn.Visible = true

    elseif topThreat >= 0.4 then
        warn.Text = "MEDIUM THREAT DETECTED"
        warn.Color = Color3.new(1,0.8,0)
        warn.Visible = true

    else
        warn.Visible = false
    end
end)

--========================================================--
--   TRIANGLE INDICATORS (LOW / MED / HIGH)
--========================================================--
local cam = Workspace.CurrentCamera

local function triangleLines()
    local a = Drawing.new("Line")
    local b = Drawing.new("Line")
    local c = Drawing.new("Line")
    a.Thickness = 2
    b.Thickness = 2
    c.Thickness = 2
    a.Visible = true
    b.Visible = true
    c.Visible = true
    table.insert(getgenv().A_TRI, a)
    table.insert(getgenv().A_TRI, b)
    table.insert(getgenv().A_TRI, c)
    return a,b,c
end

getgenv().A_TRI_CONN = RunService.RenderStepped:Connect(function()
    for _, d in ipairs(getgenv().A_TRI) do d:Remove() end
    table.clear(getgenv().A_TRI)

    for plr, info in pairs(watchers) do
        if not plr.Character then continue end
        if info.threat <= THREAT_MIN then continue end

        local head = plr.Character:FindFirstChild("Head")
        if not head then continue end

        local pos, vis = cam:WorldToViewportPoint(head.Position + Vector3.new(0,2.5,0))
        if not vis then continue end

        local t = info.threat

        --========================================================--
        -- TRIANGLE SIZE + COLOR BASED ON THREAT LEVEL
        --========================================================--
        local size, col

        if t >= 0.75 then
            -- HIGH
            size = 36
            col = Color3.new(1,0,0)

        elseif t >= 0.4 then
            -- MED
            size = 24
            col = Color3.new(1,0.85,0)

        else
            -- LOW
            size = 18
            col = Color3.new(1,1,1)  -- white
        end

        local top  = Vector2.new(pos.X, pos.Y - size)
        local left = Vector2.new(pos.X - size*0.75, pos.Y + size*0.6)
        local right= Vector2.new(pos.X + size*0.75, pos.Y + size*0.6)

        local A,B,C = triangleLines()

        A.From = left;  A.To = top;   A.Color = col
        B.From = top;   B.To = right; B.Color = col
        C.From = right; C.To = left;  C.Color = col
    end
end)
```
