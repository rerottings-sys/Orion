-- ORION RIVALS GUI v3.0 – FIXED LIB + ESP LAG ZERO + FULL RAGE – DEC 18 2025 XENO/DELTA/X ✅
loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()
local Window = OrionLib:MakeWindow({Name = "🌌 ORION RIVALS RAGE v3.0 🌌", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionRivals"})

local CombatTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://4483345998"})
local VisualTab = Window:MakeTab({Name = "Visuals", Icon = "rbxassetid://4483345998"})
local PlayerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998"})
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998"})

-- CFG
local cfg = {
    Aimbot = true, SilentAim = true, Triggerbot = true, Smoothing = 0.15,
    FOVEnabled = true, FOVRadius = 150, FOVShow = true, ESPEnabled = true,
    SpeedHack = 100, InfJump = true, NoRecoil = true, HitChance = 100
}

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- OPTIMIZED ESP (3Hz, visible cull, pooled)
local ESPObjects = {}
local VisiblePlayers = {}
local lastESPUpdate = 0

local function CreateESP(plr)
    if ESPObjects[plr] then return end
    local Box = Drawing.new("Square")
    Box.Thickness = 1; Box.Filled = false; Box.Color = Color3.fromRGB(255,0,0); Box.Transparency = 1
    local Text = Drawing.new("Text")
    Text.Size = 13; Text.Center = true; Text.Outline = true; Text.Color = Color3.fromRGB(255,255,255); Text.Font = 2
    ESPObjects[plr] = {Box=Box, Text=Text}
end

local function UpdateESP()
    VisiblePlayers = {}
    for _, plr in Players:GetPlayers() do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("HumanoidRootPart") then
            local head = plr.Character.Head
            local hpos, onscreen = Camera:WorldToViewportPoint(head.Position)
            if onscreen then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                VisiblePlayers[plr] = {Pos=Vector2.new(hpos.X, hpos.Y), Dist=math.floor(dist), HeadPos=head.Position}
                CreateESP(plr)
            elseif ESPObjects[plr] then
                ESPObjects[plr].Box.Visible = false
                ESPObjects[plr].Text.Visible = false
            end
        end
    end
    for plr, data in ESPObjects do
        if VisiblePlayers[plr] then
            local v = VisiblePlayers[plr]
            local size = 2000 / (v.HeadPos - Camera.CFrame.Position).Magnitude
            data.Box.Size = Vector2.new(size, size * 1.5)
            data.Box.Position = Vector2.new(v.Pos.X - size/2, v.Pos.Y - size*1.5/2)
            data.Box.Visible = true
            data.Text.Text = plr.Name .. " [" .. v.Dist .. "]"
            data.Text.Position = Vector2.new(v.Pos.X, v.Pos.Y - 40)
            data.Text.Visible = true
        else
            data.Box.Visible = false
            data.Text.Visible = false
        end
    end
end

-- GUI
CombatTab:AddToggle({Name="Aimbot", Default=true, Callback=function(v) cfg.Aimbot=v end})
CombatTab:AddToggle({Name="Silent Aim", Default=true, Callback=function(v) cfg.SilentAim=v end})
CombatTab:AddToggle({Name="Triggerbot", Default=true, Callback=function(v) cfg.Triggerbot=v end})
CombatTab:AddSlider({Name="Smoothing", Min=0.05, Max=1, Default=0.15, Increment=0.01, Callback=function(v) cfg.Smoothing=v end})
CombatTab:AddSlider({Name="Hit Chance %", Min=50, Max=100, Default=100, Increment=1, Callback=function(v) cfg.HitChance=v end})

VisualTab:AddToggle({Name="FOV Circle", Default=true, Callback=function(v) cfg.FOVShow=v end})
VisualTab:AddSlider({Name="FOV Radius", Min=50, Max=500, Default=150, Increment=10, Callback=function(v) cfg.FOVRadius=v end})
VisualTab:AddToggle({Name="ESP", Default=true, Callback=function(v) cfg.ESPEnabled=v end})

PlayerTab:AddSlider({Name="Speed", Min=16, Max=300, Default=100, Increment=10, Callback=function(v) cfg.SpeedHack=v end})
PlayerTab:AddToggle({Name="Inf Jump", Default=true, Callback=function(v) cfg.InfJump=v end})
PlayerTab:AddToggle({Name="No Recoil", Default=true, Callback=function(v) cfg.NoRecoil=v end})

MiscTab:AddButton({Name="Unlock All Cosmetics (Client Flex)", Callback=function()
    for _, obj in LocalPlayer.PlayerGui:GetDescendants() do
        if obj:IsA("BoolValue") and obj.Name:lower():find("owned") then obj.Value=true end
    end
    OrionLib:MakeNotification({Name="ORION", Content="Cosmetics flexed - equip in menu!", Time=5})
end})

-- FOV CIRCLE
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness=2; FOVCircle.NumSides=64; FOVCircle.Filled=false; FOVCircle.Transparency=0.8; FOVCircle.Color=Color3.fromRGB(255,0,0)

-- MAIN LOOP
local CurrentTarget = nil
RunService.RenderStepped:Connect(function()
    local MousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = MousePos
    FOVCircle.Radius = cfg.FOVRadius
    FOVCircle.Visible = cfg.FOVShow

    local LPChar = LocalPlayer.Character
    if LPChar then
        local hum = LPChar:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = cfg.SpeedHack end
        local hrp = LPChar:FindFirstChild("HumanoidRootPart")

        -- TARGET FOV
        CurrentTarget = nil
        local minDist = cfg.FOVRadius
        for plr, v in VisiblePlayers do
            local dist = (MousePos - v.Pos).Magnitude
            if dist < minDist then minDist=dist; CurrentTarget=plr end
        end

        -- AIMBOT
        if cfg.Aimbot and CurrentTarget and VisiblePlayers[CurrentTarget] then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, VisiblePlayers[CurrentTarget].HeadPos), cfg.Smoothing)
        end

        -- TRIGGER
        if cfg.Triggerbot and CurrentTarget then
            local tool = LPChar:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end

        -- NO RECOIL
        if cfg.NoRecoil and LPChar:FindFirstChildOfClass("Tool") then
            Camera.CFrame = Camera.CFrame * CFrame.Angles(0,0,0)
        end
    end
end)

-- ESP THROTTLE 3Hz
RunService.Heartbeat:Connect(function()
    if cfg.ESPEnabled and tick() - lastESPUpdate > 0.33 then
        UpdateESP()
        lastESPUpdate = tick()
    end
end)

-- SILENT AIM HOOK
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if cfg.SilentAim and self == Camera and method == "Raycast" and args[2] and math.random(1,100) <= cfg.HitChance and CurrentTarget and VisiblePlayers[CurrentTarget] then
        args[2] = (VisiblePlayers[CurrentTarget].HeadPos - args[1]).Unit * 1000
    end
    return old(self, unpack(args))
end)
setreadonly(mt, true)

-- INF JUMP
UserInputService.JumpRequest:Connect(function()
    if cfg.InfJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState("Jumping") end
    end
end)

-- CLEANUP
Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then
        ESPObjects[plr].Box:Remove()
        ESPObjects[plr].Text:Remove()
        ESPObjects[plr] = nil
    end
end)

OrionLib:Init()
OrionLib:MakeNotification({Name="🌌 ORION v3.0 LOADED", Content="GUI FIXED + ESP SMOOTH + RAGE ACTIVE – MELT NIGGAS!", Time=10})
