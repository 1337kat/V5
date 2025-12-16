# Potential Concept
```lua
--========================================================--
--  AUTHORITATIVE + SIMILARITY CLUSTERED ENTITY ID ESP
--========================================================--

local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local Workspace   = game:GetService("Workspace")
local Camera      = Workspace.CurrentCamera

--========================================================--
-- CONFIG
--========================================================--
local TEXT_SIZE = 14
local Y_OFFSET  = 2.8

--========================================================--
-- AUTHORITATIVE ANIMATION OVERRIDES
--========================================================--
local AUTHORITATIVE_ANIMS = {
    ["rbxassetid://13280887764"] = true
}

--========================================================--
-- INTERNAL STATE
--========================================================--
local tracked          = {} -- [Model] = { root, draw, clusterKey }
local clusterMap       = {} -- [clusterKey] = clusterId
local nextClusterIndex = 1

--========================================================--
-- FAST HASH (deterministic)
--========================================================--
local function fastHash(str)
    local h = 2166136261
    for i = 1, #str do
        h = bit32.bxor(h, str:byte(i))
        h = (h * 16777619) % 2^32
    end
    return string.format("%08X", h)
end

--========================================================--
-- GET ANIMATOR
--========================================================--
local function getAnimator(model)
    local hum = model:FindFirstChildWhichIsA("Humanoid")
    if hum then
        return hum:FindFirstChildOfClass("Animator")
    end
    return model:FindFirstChildOfClass("AnimationController")
end

--========================================================--
-- BUILD CLUSTER KEY (AUTHORITATIVE → SIMILARITY)
--========================================================--
local function buildClusterKey(model)
    local animator = getAnimator(model)

    -- 🔴 AUTHORITATIVE OVERRIDE
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            local anim = track.Animation
            if anim and AUTHORITATIVE_ANIMS[anim.AnimationId] then
                return "AUTH:13280887764"
            end
        end
    end

    -- 🧬 SIMILARITY FINGERPRINT
    local partCount, jointCount = 0, 0
    local humanoid = model:FindFirstChildWhichIsA("Humanoid")

    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            partCount += 1
        elseif v:IsA("Motor6D") then
            jointCount += 1
        end
    end

    local rigType = humanoid and humanoid.RigType.Name or "None"

    -- animation signature (non-authoritative)
    local animSig = {}
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            local anim = track.Animation
            if anim and anim.AnimationId then
                animSig[#animSig + 1] = anim.AnimationId
            end
        end
    end
    table.sort(animSig)

    local rawKey = table.concat({
        model.ClassName,
        model.Name,
        rigType,
        tostring(partCount),
        tostring(jointCount),
        table.concat(animSig, ",")
    }, "|")

    return fastHash(rawKey)
end

--========================================================--
-- CLUSTER ID ASSIGNMENT
--========================================================--
local function getClusterId(clusterKey)
    local id = clusterMap[clusterKey]
    if not id then
        id = "CLUSTER-" .. string.format("%02d", nextClusterIndex)
        nextClusterIndex += 1
        clusterMap[clusterKey] = id
    end
    return id
end

--========================================================--
-- DRAWING
--========================================================--
local function newLabel()
    local t = Drawing.new("Text")
    t.Size = TEXT_SIZE
    t.Center = true
    t.Outline = true
    t.Color = Color3.fromRGB(0, 170, 255)
    t.OutlineColor = Color3.new(0, 0, 0)
    t.Visible = false
    return t
end

--========================================================--
-- TRACK MODEL
--========================================================--
local function trackModel(model)
    if tracked[model] then return end
    if not model:IsA("Model") then return end

    local root =
        model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("Head")

    if not root then return end

    local clusterKey = buildClusterKey(model)
    local clusterId  = getClusterId(clusterKey)

    tracked[model] = {
        root       = root,
        draw       = newLabel(),
        clusterId = clusterId,
        clusterKey = clusterKey
    }
end

--========================================================--
-- INITIAL DISCOVERY
--========================================================--
for _, v in ipairs(Workspace:GetChildren()) do
    if v:IsA("Model") then
        trackModel(v)
    end
end

Workspace.ChildAdded:Connect(function(v)
    task.wait()
    if v:IsA("Model") then
        trackModel(v)
    end
end)

Workspace.ChildRemoved:Connect(function(v)
    local info = tracked[v]
    if info then
        pcall(info.draw.Remove, info.draw)
        tracked[v] = nil
    end
end)

--========================================================--
-- RENDER + LIVE RECLUSTER
--========================================================--
RunService.RenderStepped:Connect(function()
    for model, info in pairs(tracked) do
        local root = info.root
        local draw = info.draw

        if not root or not root.Parent then
            pcall(draw.Remove, draw)
            tracked[model] = nil
            continue
        end

        -- 🔄 live re-clustering (animation changes)
        local newKey = buildClusterKey(model)
        if newKey ~= info.clusterKey then
            info.clusterKey = newKey
            info.clusterId  = getClusterId(newKey)
        end

        local pos, onScreen = Camera:WorldToViewportPoint(
            root.Position + Vector3.new(0, Y_OFFSET, 0)
        )

        if onScreen then
            draw.Position = Vector2.new(pos.X, pos.Y)
            draw.Text = info.clusterId
            draw.Visible = true
        else
            draw.Visible = false
        end
    end
end)

```
