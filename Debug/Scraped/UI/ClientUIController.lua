--// ======================================================================
--//  CLIENT UI CONTROLLER • GameInterfaceCore.lua
--// ======================================================================
--//  DESCRIPTION:
--//      The central client-side UI management module. Controls all major
--//      HUD elements, interface transitions, map rendering, input handling,
--//      and server communication for UI actions.
--//
--//  CONTAINS:
--//      • Core UI Initialization (disables Roblox CoreGui, loads GameUI)
--//      • FPS HUD (Health, Energy, Crosshair, MidText)
--//      • Inventory, Armor, Hotbar, and Container Interfaces
--//      • Radial Menu System (Dynamic circular selection menu)
--//      • Spawn/Death Screens (Totems, cooldowns, respawn info)
--//      • Map & Compass System (Zoom, drag, markers, clan pings)
--//      • Prompt/Text Input System (custom inputs and messages)
--//      • ServerList & Core UI State Management
--//      • Cinematic Toggle and Input Lock Handling
--//
--//  NETWORK SIGNALS (u2.NetClient / u2.SendCodes):
--//      • PLAYER_SPAWN
--//      • MENU_OPEN
--//      • PLACE_MAP_MARKER
--//      • TEXT_SUBMIT
--//      • PING_CLAN_MEMBERS
--//
--//  AUTHOR:
--//      YourNameHere  (GitHub: https://github.com/<your-handle>)
--//
--//  LAST UPDATED:
--//      2025-10-23
--//
--//  DEPENDENCIES:
--//      _G.NEXT, _G.classes, ReplicatedStorage assets, RunService
--//      u2 modules: NetClient, InputManager, Sound, FPS, Inventory, etc.
--// ======================================================================

local u1 = _G.NEXT
local u2 = _G.classes
game:GetService("TeleportService")
game:GetService("Players")
game:GetService("Lighting")
local u3 = game:GetService("ReplicatedStorage")
game:GetService("ReplicatedFirst")
local u4 = game:GetService("RunService")
local u5 = game:GetService("StarterGui")
game:GetService("SoundService")
local u6 = game:GetService("UserInputService")
game:GetService("Chat")
game:GetService("GuiService")
local u7 = game.Players.LocalPlayer
local u8 = u5.GameUI
local u9 = u8.FPS
local u10 = u9.BottomCenter
local u11 = u10.SideFrame
local u12 = u10.RadialMenu
local u13 = u3.RadialOption
local u14 = u8.SpawnScreen
local u15 = u8.BlankScreen
local u16 = u10.Inventory
local u17 = u8.LoadingScreen
local _ = u10.Hotbar
local _ = u10.Armor
local u18 = u9.Map
local u19 = u9.MobileControls
local u20 = u9.Map.Markers
local u21 = u8.LobbyMenu
local u22 = u2.SendCodes
local u23 = u2.NetClient
local _ = u2.Player
local u24 = u2.Sound
local u25 = u2.FPS
local u26 = u2.InputManager
local _ = u2.InventoryClient
local u27 = u2.Character
local _ = u2.AdminClient
local _ = u2.ClassTypes
local u28 = u2.ItemClient
u1:Inherit(u2.InventoryUIControls)
u1:Inherit(u2.LobbyUIControls)
u1:Inherit(u2.ClanUIControls)
local u29 = math.atan2
local u30 = UDim2.fromOffset
local _ = math.abs
local _ = math.max
local u31 = math.clamp
local u32 = math.ceil
local u33 = math.floor
local u34 = os.clock
local u35 = math.deg
local u36 = math.sin
local u37 = math.round
local u38 = Enum.UserInputType.MouseButton1
Color3.fromRGB(189, 189, 189)
Color3.fromRGB(255, 58, 58)
Color3.fromRGB(223, 223, 46)
Color3.new(0.792157, 0.235294, 0.235294)
local u39 = nil
local u40 = nil
local u41 = game:GetService("GuiService"):IsTenFootInterface()
local u42 = false
local u43 = Vector2.new(0, 0)
local u44 = false
local u45 = Vector2.new(0, 0)
local u46 = 0
local u47 = workspace:GetAttribute("MapSize")
local u48 = u47 / 2
local u49 = workspace.CurrentCamera
local u50 = u7:GetMouse()
function u1.GetTopBarSizePixels() --[[Anonymous function at line 99]]
    --[[
    Upvalues:
        [1] = u49
        [2] = u50
    --]]
    return (u49.ViewportSize.Y - u50.ViewSizeY) / 2
end
function u1.SetEntityHealth(p51, p52, p53) --[[Anonymous function at line 103]]
    --[[
    Upvalues:
        [1] = u9
        [2] = u25
        [3] = u32
        [4] = u33
    --]]
    if p51 then
        local v54 = u25.GetEquippedItem()
        if v54 and v54.type == "BuildingTool" and true or p53 or u32(p51) ~= p52 then
            u9.Health.Visible = true
            local v55 = p51 / p52
            u9.Health.Text = u33(p51 + 0.5) .. "/" .. p52
            u9.Health.Scale.HP.Size = UDim2.fromScale(v55, 1)
        else
            u9.Health.Visible = false
        end
    else
        u9.Health.Visible = false
        return
    end
end
function u1.SetAdmin(_) --[[Anonymous function at line 122]] end
local function u57() --[[Anonymous function at line 126]]
    --[[
    Upvalues:
        [1] = u12
        [2] = u28
    --]]
    for _, v56 in u12.Options:GetChildren() do
        if not v56:IsA("UIGridLayout") then
            u28.RemoveImage(v56.overrideIcon)
            v56:Destroy()
        end
    end
end
local function u65() --[[Anonymous function at line 135]]
    --[[
    Upvalues:
        [1] = u39
        [2] = u40
        [3] = u12
        [4] = u1
        [5] = u26
    --]]
    if u39 then
        u40 = nil
        local v58 = 4294967296
        local v59 = nil
        local v60 = nil
        for _, v61 in u12.Options:GetChildren() do
            if not v61:IsA("UIGridLayout") then
                v61.BackgroundTransparency = 1
                local v62 = v61.AbsoluteSize.Y / 2
                local v63 = (v61.AbsolutePosition + Vector2.new(v62, v62 + u1.GetTopBarSizePixels()) - u26.GetMousePos()).Magnitude
                if v63 < v62 * 1.25 and v63 < v58 then
                    local v64 = v61.Name
                    v60 = tonumber(v64)
                    v59 = v61
                    v58 = v63
                end
            end
        end
        if v59 then
            v59.BackgroundTransparency = 0.5
            u12.Center.SelectedOption.Text = u39[v60].desc
            u12.Center.SubText.Text = u39[v60].sub
            u40 = u39[v60].desc
        end
    end
end
local u66 = nil
function u1.OpenRadialMenu(p67, p68, p69) --[[Anonymous function at line 163]]
    --[[
    Upvalues:
        [1] = u66
        [2] = u57
        [3] = u12
        [4] = u39
        [5] = u13
        [6] = u28
    --]]
    u66 = p69
    u57()
    u12.Visible = true
    u39 = p67
    u12.Center.Title.Text = p68
    local v70 = 6.283185307179586 / #p67
    for v71, v72 in pairs(p67) do
        local v73 = u13:Clone()
        v73.Parent = u12.Options
        v73.Name = v71
        local v74 = UDim2.new
        local v75 = v70 * v71
        local v76 = math.cos(v75) * 150 - 50
        local v77 = v70 * v71
        v73.Position = v74(0.5, v76, 0.5, math.sin(v77) * 150 - 50)
        local v78 = u28.GetImage(v72.image)
        v78.Name = "overrideIcon"
        v78.Parent = v73
    end
end
function u1.CloseRadialMenu(p79) --[[Anonymous function at line 182]]
    --[[
    Upvalues:
        [1] = u57
        [2] = u12
        [3] = u39
        [4] = u66
        [5] = u40
    --]]
    u57()
    u12.Visible = false
    u39 = nil
    if not p79 then
        if u66 and u40 then
            u66(u40)
        end
    end
end
function u1.IsRadialMenuOpen() --[[Anonymous function at line 194]]
    --[[
    Upvalues:
        [1] = u39
    --]]
    return u39 ~= nil
end
function u1.SetIndicatorVisible(p80, p81) --[[Anonymous function at line 198]]
    --[[
    Upvalues:
        [1] = u9
    --]]
    u9.Indicators.Perm[p80].Visible = p81
end
function u1.AddItem(p82, p83) --[[Anonymous function at line 202]]
    --[[
    Upvalues:
        [1] = u2
        [2] = u3
        [3] = u9
    --]]
    local v84 = u2[p82].Callsign
    local v85 = u3.ItemChange:Clone()
    if p83 < 0 then
        v85.BackgroundColor3 = Color3.fromRGB(166, 74, 74)
        v85.Text = " " .. p83 .. " " .. string.upper(v84)
    else
        v85.Text = " +" .. p83 .. " " .. string.upper(v84)
    end
    v85.Parent = u9.Indicators.Items
    wait(0.25)
    for v86 = 0, 60 do
        v85.BackgroundTransparency = v86 / 60
        v85.TextTransparency = v86 / 60
        v85.Frame.BackgroundTransparency = v86 / 60
        wait()
    end
    v85:Destroy()
end
function u1.SetServerInfo(p87) --[[Anonymous function at line 224]]
    --[[
    Upvalues:
        [1] = u8
    --]]
    u8.ServerInfo.Text = p87
end
function u1.PromptTextInput(p88) --[[Anonymous function at line 228]]
    --[[
    Upvalues:
        [1] = u9
        [2] = u23
        [3] = u22
    --]]
    u9.Input.Visible = true
    u9.Input.PlaceholderText = p88 or "input text here"
    local u89 = nil
    u89 = u9.Input.FocusLost:Connect(function() --[[Anonymous function at line 232]]
        --[[
        Upvalues:
            [1] = u9
            [2] = u89
            [3] = u23
            [4] = u22
        --]]
        u9.Input.Visible = false
        u89:Disconnect()
        u23.SendTCP(u22.TEXT_SUBMIT, u9.Input.Text)
    end)
    wait(0.25)
    u9.Input:CaptureFocus()
end
function u1.SetSpawnOptions(p90) --[[Anonymous function at line 242]]
    --[[
    Upvalues:
        [1] = u14
        [2] = u3
        [3] = u23
        [4] = u22
        [5] = u41
        [6] = u33
    --]]
    for _, v91 in u14.SpawnLocations:GetChildren() do
        if v91:IsA("TextButton") then
            v91:Destroy()
        end
    end
    if p90 == "Continue" then
        local v92 = u3.Awake:Clone()
        v92.Parent = u14.SpawnLocations
        v92.MouseButton1Click:Connect(function() --[[Anonymous function at line 252]]
            --[[
            Upvalues:
                [1] = u23
                [2] = u22
                [3] = u41
            --]]
            u23.SendTCP(u22.PLAYER_SPAWN, nil, u41)
        end)
    else
        local v93 = u3.SpawnRandom:Clone()
        v93.Parent = u14.SpawnLocations
        v93.MouseButton1Click:Connect(function() --[[Anonymous function at line 260]]
            --[[
            Upvalues:
                [1] = u23
                [2] = u22
                [3] = u41
            --]]
            u23.SendTCP(u22.PLAYER_SPAWN, nil, u41)
        end)
        for _, u94 in p90 do
            local u95 = u3.SpawnTotem:Clone()
            u95.Parent = u14.SpawnLocations
            u95.Id.Value = u94.name
            u95.Description.Text = "\"" .. u94.name .. "\""
            u95.Timer.Text = u33(u94.cooldown + 0.5) .. "s"
            if u94.cooldown > 0 then
                u95.BackgroundColor3 = Color3.fromRGB(135, 135, 135)
            end
            u95.MouseButton1Click:Connect(function() --[[Anonymous function at line 273]]
                --[[
                Upvalues:
                    [1] = u23
                    [2] = u22
                    [3] = u94
                    [4] = u41
                --]]
                u23.SendTCP(u22.PLAYER_SPAWN, u94.id, u41)
            end)
            spawn(function() --[[Anonymous function at line 276]]
                --[[
                Upvalues:
                    [1] = u95
                    [2] = u94
                    [3] = u33
                --]]
                while true do
                    wait(1)
                    if not u95.Parent then
                        break
                    end
                    local v96 = u94
                    v96.cooldown = v96.cooldown - 1
                    if u94.cooldown <= 0 then
                        u95.BackgroundColor3 = Color3.fromRGB(80, 148, 152)
                        u95.Timer.Text = ""
                        return
                    end
                    u95.BackgroundColor3 = Color3.fromRGB(135, 135, 135)
                    u95.Timer.Text = u33(u94.cooldown + 0.5) .. "s"
                end
            end)
        end
    end
end
function u1.SetMidTextInfo(p97, p98) --[[Anonymous function at line 294]]
    --[[
    Upvalues:
        [1] = u9
    --]]
    u9.Crosshair.BackgroundTransparency = p97
    u9.MidText.TextTransparency = p97
    u9.MidText.TextStrokeTransparency = p97 * 0.19999999999999996 + 0.8
    u9.MidText.Text = p98
end
function u1.SetHealth(p99, p100, p101) --[[Anonymous function at line 301]]
    --[[
    Upvalues:
        [1] = u9
        [2] = u33
        [3] = u8
        [4] = u24
    --]]
    u9.Vitals.HealthFrame.Health.Size = UDim2.new(p99 / 100, 0, 1, 0)
    local v102 = u9.Vitals.HealthFrame.Amount
    local v103 = u33(p99)
    v102.Text = tostring(v103)
    u8.BloodSplatter.ImageLabel.ImageTransparency = 0.1 + p99 / 100
    if p100 == "Ranged" or p100 == "Melee" then
        if p101 == "Head" then
            u24.Play("PlayerHitHeadshot")
        else
            u24.Play("PlayerHit")
        end
    else
        if p100 == "Suffocation" then
            u24.Play("Drown", math.random(-10, 10) / 100)
        end
        return
    end
end
function u1.SetEnergy(p104) --[[Anonymous function at line 318]]
    --[[
    Upvalues:
        [1] = u9
        [2] = u33
    --]]
    u9.Vitals.EnergyFrame.Energy.Size = UDim2.new(p104 / 100, 0, 1, 0)
    local v105 = u9.Vitals.EnergyFrame.Amount
    local v106 = u33(p104)
    v105.Text = tostring(v106)
end
function u1.GetShouldMouseLock() --[[Anonymous function at line 323]]
    --[[
    Upvalues:
        [1] = u6
        [2] = u14
        [3] = u15
        [4] = u16
        [5] = u12
        [6] = u42
        [7] = u8
        [8] = u9
        [9] = u21
    --]]
    if u6:GetFocusedTextBox() then
        return false
    else
        return not (u14.Visible or u15.Visible or (u16.Visible or u12.Visible) or (u42 or u8.Admin.Visible or (u9.Input.Visible or u21.Visible)))
    end
end
function u1.isInputReserved() --[[Anonymous function at line 330]]
    --[[
    Upvalues:
        [1] = u14
        [2] = u15
        [3] = u16
        [4] = u42
        [5] = u9
        [6] = u21
    --]]
    return u14.Visible or u15.Visible or (u16.Visible or u42 or (u9.Input.Visible or u21.Visible))
end
local u107 = nil
local u108 = nil
local u109 = false
function u1.SetCore(p110, p111) --[[Anonymous function at line 338]]
    --[[
    Upvalues:
        [1] = u107
        [2] = u109
        [3] = u108
        [4] = u9
        [5] = u14
        [6] = u15
        [7] = u17
        [8] = u21
    --]]
    if not p111 then
        u107 = p110
        if u109 then
            return
        end
    end
    u108 = p110
    u9.Input.Visible = false
    u14.Visible = false
    u15.Visible = false
    u9.Visible = false
    u17.Visible = false
    u21.Visible = false
    if p110 == "FPS" then
        u9.Visible = true
        return
    elseif p110 == "spawning" then
        u14.Visible = true
        return
    elseif p110 == "loading" then
        u17.Visible = true
        return
    elseif p110 == "easeSpawning" then
        u15.TextLabel.Visible = false
        u15.Visible = true
        u15.Transparency = 1
        for v112 = 0, 50 do
            if u108 ~= p110 then
                return
            end
            u15.Transparency = 1 - v112 / 50
            wait(0)
        end
        u14.Visible = true
        for v113 = 0, 25 do
            if u108 ~= p110 then
                return
            end
            u15.Transparency = v113 / 25
            wait(0)
        end
        u15.Visible = false
        return
    elseif p110 == "serverlist" then
        u21.Visible = true
    else
        u15.TextLabel.Visible = true
        u15.Visible = true
    end
end
function u1.ToggleMenu(p114) --[[Anonymous function at line 391]]
    --[[
    Upvalues:
        [1] = u108
        [2] = u23
        [3] = u22
        [4] = u109
        [5] = u107
        [6] = u1
    --]]
    if p114 then
        if u108 == "serverlist" then
            u23.SendTCP(u22.MENU_OPEN, false)
            u109 = false
            if u107 == "easeSpawning" then
                u107 = "spawning"
            end
            u1.SetCore(u107, true)
        else
            u23.SendTCP(u22.MENU_OPEN, true)
            u109 = true
            u1.SetCore("serverlist", true)
        end
    else
        return
    end
end
function u1.SetDeathInfo(p115, p116, p117, p118) --[[Anonymous function at line 409]]
    --[[
    Upvalues:
        [1] = u14
    --]]
    u14.DeathInfo.KillerDisplayName.Text = p115 or "Unknown"
    u14.DeathInfo.KillerName.Text = p116 or "Unknown"
    u14.DeathInfo.KillerWeapon.Text = p117 or "Magic"
    u14.DeathInfo.KillerQuip.Text = p118 or "...?"
end
local u119 = u34()
local u120 = u9.CompassFrame
local u121 = math.abs
local u122 = UDim2.fromScale
local function u132(p123) --[[Anonymous function at line 448]]
    --[[
    Upvalues:
        [1] = u18
        [2] = u1
        [3] = u47
        [4] = u48
    --]]
    local v124 = u18.AbsoluteSize
    local v125 = u18.AbsolutePosition
    local v126 = p123 + Vector2.new(0, -u1.GetTopBarSizePixels())
    local v127 = (v126.X - v125.X) / v124.X
    local v128 = (v126.Y - v125.Y) / v124.Y
    local v129 = Vector3.new(v127, 0, v128)
    local v130 = v129.X * u47 - u48
    local v131 = v129.Z * u47 - u48
    return Vector3.new(v130, 0, v131)
end
local u133 = 0
function u1.UpdateMap(p134) --[[Anonymous function at line 456]]
    --[[
    Upvalues:
        [1] = u49
        [2] = u120
        [3] = u122
        [4] = u29
        [5] = u46
        [6] = u42
        [7] = u133
        [8] = u19
        [9] = u31
        [10] = u18
        [11] = u20
        [12] = u27
        [13] = u48
        [14] = u47
        [15] = u35
        [16] = u34
        [17] = u36
        [18] = u121
        [19] = u37
        [20] = u119
        [21] = u23
        [22] = u22
        [23] = u44
        [24] = u6
        [25] = u38
        [26] = u30
        [27] = u43
        [28] = u45
        [29] = u26
    --]]
    local _, v135, _ = u49.CFrame:ToOrientation()
    local v136 = u49.CFrame.Position
    local v137 = u120.N
    local v138 = u122
    local v139 = v135 - 0
    if v139 > 3.141592653589793 then
        v139 = v139 - 6.283185307179586
    end
    if v139 < -3.141592653589793 then
        v139 = v139 + 6.283185307179586
    end
    v137.Position = v138(v139 * 0.5, 0)
    local v140 = u120.E
    local v141 = u122
    local v142 = v135 - -1.5707963267948966
    if v142 > 3.141592653589793 then
        v142 = v142 - 6.283185307179586
    end
    if v142 < -3.141592653589793 then
        v142 = v142 + 6.283185307179586
    end
    v140.Position = v141(v142 * 0.5, 0)
    local v143 = u120.S
    local v144 = u122
    local v145 = v135 - -3.141592653589793
    if v145 > 3.141592653589793 then
        v145 = v145 - 6.283185307179586
    end
    if v145 < -3.141592653589793 then
        v145 = v145 + 6.283185307179586
    end
    v143.Position = v144(v145 * 0.5, 0)
    local v146 = u120.W
    local v147 = u122
    local v148 = v135 - -4.71238898038469
    if v148 > 3.141592653589793 then
        v148 = v148 - 6.283185307179586
    end
    if v148 < -3.141592653589793 then
        v148 = v148 + 6.283185307179586
    end
    v146.Position = v147(v148 * 0.5, 0)
    local v149 = u120.NE
    local v150 = u122
    local v151 = v135 - -0.7853981633974483
    if v151 > 3.141592653589793 then
        v151 = v151 - 6.283185307179586
    end
    if v151 < -3.141592653589793 then
        v151 = v151 + 6.283185307179586
    end
    v149.Position = v150(v151 * 0.5, 0)
    local v152 = u120.SE
    local v153 = u122
    local v154 = v135 - -2.356194490192345
    if v154 > 3.141592653589793 then
        v154 = v154 - 6.283185307179586
    end
    if v154 < -3.141592653589793 then
        v154 = v154 + 6.283185307179586
    end
    v152.Position = v153(v154 * 0.5, 0)
    local v155 = u120.SW
    local v156 = u122
    local v157 = v135 - -3.9269908169872414
    if v157 > 3.141592653589793 then
        v157 = v157 - 6.283185307179586
    end
    if v157 < -3.141592653589793 then
        v157 = v157 + 6.283185307179586
    end
    v155.Position = v156(v157 * 0.5, 0)
    local v158 = u120.NW
    local v159 = u122
    local v160 = v135 - -5.497787143782138
    if v160 > 3.141592653589793 then
        v160 = v160 - 6.283185307179586
    end
    if v160 < -3.141592653589793 then
        v160 = v160 + 6.283185307179586
    end
    v158.Position = v159(v160 * 0.5, 0)
    for _, v161 in u120:GetChildren() do
        local v162 = v161:GetAttribute("PointTo")
        if v162 then
            local v163 = u122
            local v164 = v135 - u29(v136.X - v162.X, v136.Z - v162.Z)
            if v164 > 3.141592653589793 then
                v164 = v164 - 6.283185307179586
            end
            if v164 < -3.141592653589793 then
                v164 = v164 + 6.283185307179586
            end
            v161.Position = v163(v164 * 0.5, 0.2)
        end
    end
    local v165 = u46
    if u42 then
        u133 = u133 + p134
        u19["UI.MapZoomOut"].Visible = true
        u19["UI.MapZoomIn"].Visible = true
        u46 = u46 - p134 * 5
    else
        u133 = 0
        u19["UI.MapZoomOut"].Visible = false
        u19["UI.MapZoomIn"].Visible = false
        u46 = u46 + p134 * 5
    end
    u46 = u31(u46, 0, 1)
    if v165 ~= u46 then
        for _, v166 in u18:GetDescendants() do
            if v166.Name ~= "_ignore" and v166.Parent ~= u18 then
                if v166:IsA("TextLabel") then
                    v166.TextTransparency = u46
                    v166.TextStrokeTransparency = u46 * 0.5 + 0.5
                elseif v166:IsA("ImageLabel") then
                    v166.ImageTransparency = u46
                elseif v166:IsA("GuiBase") then
                    v166.BackgroundTransparency = u46
                end
            end
        end
    end
    if u42 then
        local v167 = u20:FindFirstChild("LocalPlayer")
        if v167 then
            local v168 = u27.GetCFrame().Position
            local v169 = UDim2.fromScale((v168.X + u48) / u47, (v168.Z + u48) / u47)
            local v170 = Vector2.new(0.5, 0.5)
            local v171 = Vector2.new(v169.X.Scale, v169.Y.Scale)
            local v172 = u133 * 4
            local v173 = v170:Lerp(v171, (math.min(v172, 1)))
            v167.Position = UDim2.fromScale(v173.X, v173.Y)
            v167.Rotation = -u35(v135) - 90
            v167.ImageTransparency = u37((u121((u36(u34() * 4))))) - 0.5
        end
        if u34() - u119 > 0.2 then
            u119 = u34()
            u23.SendTCP(u22.PING_CLAN_MEMBERS)
        end
        local v174 = u44
        u44 = u6:IsMouseButtonPressed(u38)
        local v175 = u18
        v175.Position = v175.Position + u30(-u43.X * 10, u43.Y * 10)
        if u44 then
            if v174 then
                local v176 = u26.GetMousePos() - u45
                local v177 = u18
                v177.Position = v177.Position + u30(v176.X, v176.Y)
                u45 = u26.GetMousePos()
            else
                u45 = u26.GetMousePos()
            end
        end
        local v178 = workspace.CurrentCamera.ViewportSize
        local v179 = u18.AbsoluteSize
        if u31(u18.Position.X.Offset, -v179.X + 10, v178.X - 10) ~= u18.Position.X.Offset then
            u18.Position = u30(u31(u18.Position.X.Offset, -v179.X + 10, v178.X - 10), u18.Position.Y.Offset)
        end
        if u31(u18.Position.Y.Offset, -v179.Y + 10, v178.Y - 10) ~= u18.Position.Y.Offset then
            u18.Position = u30(u18.Position.X.Offset, (u31(u18.Position.Y.Offset, -v179.Y + 10, v178.Y - 10)))
        end
    end
end
local u180 = {
    Color3.fromHex("e6194B"),
    Color3.fromHex("3cb44b"),
    Color3.fromHex("ffe119"),
    Color3.fromHex("4363d8"),
    Color3.fromHex("f58231"),
    Color3.fromHex("42d4f4"),
    Color3.fromHex("f032e6"),
    Color3.fromHex("fabed4"),
    Color3.fromHex("469990"),
    Color3.fromHex("dcbeff"),
    Color3.fromHex("9A6324"),
    Color3.fromHex("fffac8"),
    Color3.fromHex("800000"),
    Color3.fromHex("aaffc3"),
    Color3.fromHex("000075")
}
function u1.FlagMapLocation(p181) --[[Anonymous function at line 564]]
    --[[
    Upvalues:
        [1] = u42
        [2] = u132
        [3] = u26
        [4] = u23
        [5] = u22
    --]]
    if p181 and u42 then
        local v182 = u132(u26.GetMousePos())
        u23.SendTCP(u22.PLACE_MAP_MARKER, v182.X, v182.Z)
    end
end
function u1.LoadMapMarkers(p183) --[[Anonymous function at line 571]]
    --[[
    Upvalues:
        [1] = u20
        [2] = u120
        [3] = u3
        [4] = u9
        [5] = u46
        [6] = u7
        [7] = u48
        [8] = u47
        [9] = u35
        [10] = u180
        [11] = u122
    --]]
    for _, v184 in u20:GetChildren() do
        local v185 = false
        for _, v186 in p183 do
            if v186.id == v184.Name then
                v185 = true
                break
            end
        end
        if not v185 then
            v184:Destroy()
        end
    end
    for _, v187 in u120:GetChildren() do
        if v187:GetAttribute("PointTo") then
            local v188 = false
            for _, v189 in p183 do
                if v189.id == v187.Name then
                    v188 = true
                    break
                end
            end
            if not v188 then
                v187:Destroy()
            end
        end
    end
    for _, v190 in p183 do
        local v191 = u20:FindFirstChild(v190.id) or u3.Markers[v190.type]:Clone()
        v191.Parent = u9.Map.Markers
        v191.ImageTransparency = u46
        if v190.id ~= u7 then
            local v192 = v190.pos
            v191.Position = UDim2.fromScale((v192.X + u48) / u47, (v192.Z + u48) / u47)
            if v190.rot then
                v191.Rotation = -u35(v190.rot) - 90
            else
                v191.Rotation = 0
            end
        end
        v191.Name = v190.id
        if v190.memberIndex then
            v191.ImageColor3 = u180[(v190.memberIndex - 1) % #u180 + 1]
        else
            v191.ImageColor3 = Color3.new(1, 1, 1)
        end
        if v190.type == "MapFlag" or v190.type == "ClaimTotem" then
            local v193 = u120:FindFirstChild(v190.id) or u3.Markers[v190.type]:Clone()
            v193.Parent = u120
            local v194 = v190.pos.X
            local v195 = v190.pos.Z
            v193:SetAttribute("PointTo", (Vector3.new(v194, 0, v195)))
            v193.Name = v190.id
            v193.Size = u122(1, 0.75)
            v193.AnchorPoint = Vector2.new(0, 0)
            v193.ImageTransparency = 0
            if v190.memberIndex then
                v193.ImageColor3 = u180[(v190.memberIndex - 1) % #u180 + 1]
            else
                v193.ImageColor3 = Color3.new(1, 1, 1)
            end
        end
    end
end
function u1.SetCenterScreenText(p196) --[[Anonymous function at line 639]]
    --[[
    Upvalues:
        [1] = u8
    --]]
    u8.CenterScreenText.Text = p196
end
function u1.SetMapEnabled(p197) --[[Anonymous function at line 643]]
    --[[
    Upvalues:
        [1] = u1
        [2] = u42
    --]]
    if u1.IsInventoryVisible() then
        u42 = false
    else
        u42 = p197
    end
end
function u1.MapZoomIn(p198) --[[Anonymous function at line 651]]
    --[[
    Upvalues:
        [1] = u42
        [2] = u18
        [3] = u30
    --]]
    local v199 = workspace.CurrentCamera.ViewportSize
    if u42 and (p198 and u18.Size.Y.Offset < 5 * v199.Y) then
        local v200 = u18
        v200.Size = v200.Size + u30(0.15 * v199.X, 0.15 * v199.Y)
        local v201 = u18
        v201.Position = v201.Position - u30(0.0375 * v199.X, 0.0375 * v199.Y)
    end
end
function u1.MapZoomOut(p202) --[[Anonymous function at line 659]]
    --[[
    Upvalues:
        [1] = u42
        [2] = u18
        [3] = u30
    --]]
    local v203 = workspace.CurrentCamera.ViewportSize
    if u42 and (p202 and u18.Size.Y.Offset > v203.Y / 5) then
        local v204 = workspace.CurrentCamera.ViewportSize
        local v205 = u18
        v205.Size = v205.Size - u30(0.15 * v204.X, 0.15 * v204.Y)
        local v206 = u18
        v206.Position = v206.Position + u30(0.0375 * v204.X, 0.0375 * v204.Y)
    end
end
function u1.Prompt(p207, p208, p209) --[[Anonymous function at line 669]]
    --[[
    Upvalues:
        [1] = u3
        [2] = u10
        [3] = u4
    --]]
    local u210 = p209 or #p207 / 30 + 1
    local u211 = u3.TextPrompt:Clone()
    u211.Parent = u10.Prompts
    u211.TextColor3 = p208 or Color3.fromRGB(214, 214, 214)
    u211.Text = p207
    local u212 = 0
    local u213 = nil
    u213 = u4.RenderStepped:Connect(function(p214) --[[Anonymous function at line 678]]
        --[[
        Upvalues:
            [1] = u212
            [2] = u210
            [3] = u211
            [4] = u213
        --]]
        u212 = u212 + p214
        local v215 = u212 - (u210 - 1)
        local v216 = math.max(v215, 0)
        u211.TextTransparency = v216
        u211.TextStrokeTransparency = v216 * 0.7 + 0.3
        if u210 < u212 then
            u213:Disconnect()
            u211:Destroy()
        end
    end)
end
u6.InputChanged:Connect(function(p217) --[[Anonymous function at line 693]]
    --[[
    Upvalues:
        [1] = u42
        [2] = u1
    --]]
    if u42 and p217.UserInputType == Enum.UserInputType.MouseWheel then
        if p217.Position.Z > 0 then
            u1.MapZoomIn(true)
            return
        end
        u1.MapZoomOut(true)
    end
end)
function u1.ToggleMap(p218) --[[Anonymous function at line 705]]
    --[[
    Upvalues:
        [1] = u1
        [2] = u42
    --]]
    if p218 and not u1.IsInventoryVisible() then
        u42 = not u42
    end
end
function u1.GetHotbar() --[[Anonymous function at line 711]]
    --[[
    Upvalues:
        [1] = u10
    --]]
    return u10.Hotbar
end
function u1.GetInventory() --[[Anonymous function at line 715]]
    --[[
    Upvalues:
        [1] = u16
    --]]
    return u16
end
function u1.GetContainer() --[[Anonymous function at line 719]]
    --[[
    Upvalues:
        [1] = u11
    --]]
    return u11.Container
end
function u1.GetArmor() --[[Anonymous function at line 723]]
    --[[
    Upvalues:
        [1] = u10
    --]]
    return u10.Armor
end
function u1.GetMobileControls() --[[Anonymous function at line 727]]
    --[[
    Upvalues:
        [1] = u9
    --]]
    return u9.MobileControls
end
function u1.GetFPSFrame() --[[Anonymous function at line 731]]
    --[[
    Upvalues:
        [1] = u9
    --]]
    return u9
end
function u1.GetUIObject() --[[Anonymous function at line 735]]
    --[[
    Upvalues:
        [1] = u8
    --]]
    return u8
end
function u1.ToggleCinematicMode(p219) --[[Anonymous function at line 739]]
    --[[
    Upvalues:
        [1] = u8
    --]]
    if p219 then
        u8.Enabled = not u8.Enabled
    end
end
u1.UIObject = u8
function u1.init() --[[Anonymous function at line 749]]
    --[[
    Upvalues:
        [1] = u5
        [2] = u41
        [3] = u3
        [4] = u26
        [5] = u8
        [6] = u42
        [7] = u15
        [8] = u7
        [9] = u18
        [10] = u32
        [11] = u4
        [12] = u65
        [13] = u6
        [14] = u43
    --]]
    for _, v220 in script:GetChildren() do
        if v220:IsA("ModuleScript") then
            require(v220)
        end
    end
    u5:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
    u5:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
    u5:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
    u5:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
    if u41 then
        u3.Particles.Blood.Texture = "rbxassetid://2070896802"
    end
    u26.ControllerMouse.Parent = u8
    u42 = false
    u15.Visible = true
    u8.Parent = u7.PlayerGui
    local v221 = {
        "A",
        "B",
        "C",
        "D",
        "E",
        "F",
        "G",
        "H",
        "I",
        "J",
        "K",
        "L",
        "M",
        "N",
        "O",
        "P",
        "Q",
        "R"
    }
    for v222 = 1, 64 do
        local v223 = u18.Grid.piece:Clone()
        v223.Name = "_ignore"
        local v224 = v222 % 8
        local v225 = v224 == 0 and 8 or v224
        v223.TextLabel.Text = v221[u32(v222 / 8)] .. v225
        v223.Parent = u18.Grid
    end
    u18.Grid.piece:Destroy()
    u18.Grid.Name = "_ignore"
    u18.Visible = true
    u4:BindToRenderStep("RadialMenu", Enum.RenderPriority.Input.Value, u65)
    u6.InputChanged:Connect(function(p226, _) --[[Anonymous function at line 789]]
        --[[
        Upvalues:
            [1] = u43
        --]]
        if p226.UserInputType == Enum.UserInputType.Gamepad1 and p226.KeyCode == Enum.KeyCode.Thumbstick2 then
            if p226.Position.Magnitude > 0.3 then
                u43 = Vector2.new(p226.Position.X, p226.Position.Y)
                return
            end
            u43 = Vector2.new(0, 0)
        end
    end)
end
return true
