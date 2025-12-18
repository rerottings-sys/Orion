-- ORION RIVALS GUI v2.0 – Dec 18 2025 – ORION LIB MENU + FULL RAGE + CLIENT UNLOCK ALL 🩸🌌⚡
-- Draggable Orion UI - Toggles/Sliders - Dominate with Style

loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()  -- Orion Lib Load

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

local Window = OrionLib:MakeWindow({Name = "ORION RIVALS RAGE", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionRivals"})

-- Tabs
local CombatTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local VisualTab = Window:MakeTab({Name = "Visuals", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local PlayerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- Vars
local cfg = {
    Aimbot = true,
    SilentAim = true,
    Triggerbot = true,
    Smoothing = 0.15,
    FOVEnabled = true,
    FOVRadius = 150,
    FOVShow = true,
    ESPEnabled = true,
    SpeedHack = 100,
    InfJump = true,
    NoRecoil = true,
    SilentPart = "Head",
    HitChance = 100
}

-- Core Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Caches
local Targets = {}
local CurrentTarget = nil
local LPChar, LPHRP, LPHum = nil, nil, nil

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Transparency = 0.8
FOVCircle.Color = Color3.fromRGB(255,0,0)

-- GUI Toggles/Sliders
CombatTab:AddToggle({
    Name = "Aimbot",
    Default = true,
    Callback = function(v) cfg.Aimbot = v end
})

CombatTab:AddToggle({
    Name = "Silent Aim",
    Default = true,
    Callback = function(v) cfg.SilentAim = v end
})

CombatTab:AddToggle({
    Name = "Triggerbot",
    Default = true,
    Callback = function(v) cfg.Triggerbot = v end
})

CombatTab:AddSlider({
    Name = "Aimbot Smoothing",
    Min = 0.05,
    Max = 1,
    Default = 0.15,
    Increment = 0.01,
    Callback = function(v) cfg.Smoothing = v end
})

CombatTab:AddSlider({
    Name = "Hit Chance %",
    Min = 50,
    Max = 100,
    Default = 100,
    Increment = 1,
    Callback = function(v) cfg.HitChance = v end
})

VisualTab:AddToggle({
    Name = "FOV Circle",
    Default = true,
    Callback = function(v) cfg.FOVShow = v end
})

VisualTab:AddSlider({
    Name = "FOV Radius",
    Min = 50,
    Max = 500,
    Default = 150,
    Increment = 10,
    Callback = function(v) cfg.FOVRadius = v end
})

VisualTab:AddToggle({
    Name = "ESP Boxes",
    Default = true,
    Callback = function(v) cfg.ESPEnabled = v end
})

PlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 300,
    Default = 100,
    Increment = 10,
    Callback = function(v) cfg.SpeedHack = v if LPHum then LPHum.WalkSpeed = v end end
})

PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = true,
    Callback = function(v) cfg.InfJump = v end
})

PlayerTab:AddToggle({
    Name = "No Recoil",
    Default = true,
    Callback = function(v) cfg.NoRecoil = v end
})

MiscTab:AddButton({
    Name = "Client Unlock All Cosmetics",
    Callback = function()
        pcall(function()
            for _, obj in LocalPlayer.PlayerGui:GetDescendants() do
                if obj:IsA("BoolValue") and obj.Name:lower():find("owned") then obj.Value = true end
            end
            if LocalPlayer:FindFirstChild("Loadout") then
                for _, w in LocalPlayer.Loadout:GetChildren() do
                    if w:FindFirstChild("Skin") then w.Skin.Value = 999999 end
                end
            end
            OrionLib:MakeNotification({Name = "ORION FLEX", Content = "All cosmetics unlocked client-side - open menu to equip!", Time = 5})
        end)
    end
})

-- Main Rage Loop
RunService.RenderStepped:Connect(function()
    local MousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = MousePos
    FOVCircle.Radius = cfg.FOVRadius
    FOVCircle.Visible = cfg.FOVShow

    LPChar = LocalPlayer.Character
    if LPChar then
        LPHRP = LPChar:FindFirstChild("HumanoidRootPart")
        LPHum = LPChar:FindFirstChildOfClass("Humanoid")
        if LPHum then LPHum.WalkSpeed = cfg.SpeedHack end
    end

    -- Target Find
    CurrentTarget = nil
    local MinDist = cfg.FOVRadius
    for _, plr in Players:GetPlayers() do
        if plr ~= LocalPlayer and Targets[plr] then
            local HeadPos, OnScreen = Camera:WorldToViewportPoint(Targets[plr].HeadPos)
            if OnScreen then
                local Dist = (MousePos - Vector2.new(HeadPos.X, HeadPos.Y)).Magnitude
                if Dist < MinDist then MinDist = Dist CurrentTarget = plr end
            end
        end
    end

    -- Aimbot
    if cfg.Aimbot and CurrentTarget and Targets[CurrentTarget] then
        local TgtPos = Targets[CurrentTarget].HeadPos
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, TgtPos), cfg.Smoothing)
    end

    -- Trigger
    if cfg.Triggerbot and CurrentTarget then
        local tool = LPChar and LPChar:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    end

    -- No Recoil
    if cfg.NoRecoil and LPChar and LPChar:FindFirstChildOfClass("Tool") then
        Camera.CFrame = Camera.CFrame * CFrame.Angles(0,0,0)
    end
end)

-- ESP & Cache Update
task.spawn(function()
    while task.wait(0.1) do
        Targets = {}
        for _, plr in Players:GetPlayers() do
            local char = plr.Character
            if char and char:FindFirstChild("Head") then Targets[plr] = {HeadPos = char.Head.Position} end
        end
        -- Simple ESP Drawing (add more if wanted)
    end
end)

-- Silent Aim Hook
local mt = getrawmetatable(game)
local oldnc = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if cfg.SilentAim and self == Camera and method == "Raycast" and args[2] and math.random(1,100) <= cfg.HitChance then
        if CurrentTarget and Targets[CurrentTarget] then
            args[2] = (Targets[CurrentTarget][cfg.SilentPart].Position - args[1]).Unit * 1000
        end
    end
    return oldnc(self, unpack(args))
end)
setreadonly(mt, true)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if cfg.InfJump and LPHum then LPHum:ChangeState("Jumping") end
end)

OrionLib:MakeNotification({Name = "ORION LOADED", Content = "Rage menu ready - dominate niggas!", Image = "rbxassetid://4483345998", Time = 8})

OrionLib:Init()
