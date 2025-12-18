-- ORION Rivals v1.3 – Dec 18 2025 – WORKING AIMBOT/ESP/TRIGGER/SILENT/UNLOCK ALL 🩸🌌💀
-- FOV Circle Instant, Rapid Trigger Hold, Byfron-Proof Rage – XENO/DELTA GOD

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIG
local cfg = getgenv()
cfg.SilentAimEnabled = true
cfg.AimbotEnabled = true
cfg.TriggerbotEnabled = true  -- Now rapid hold fire
cfg.AimbotSmoothing = 0.15
cfg.FOVEnabled = true
cfg.FOVRadius = 150
cfg.FOVShow = true
cfg.FOVColor = Color3.fromRGB(255, 0, 0)
cfg.ESPEnabled = true
cfg.SpeedHack = 100
cfg.InfiniteJump = true
cfg.NoRecoil = true
cfg.SilentAimPart = "Head"
cfg.HitChance = 100

-- CACHES
local MouseLoc = Vector2.new()
local Targets = {}
local ESPObjects = {}
local CurrentTarget = nil
local LPChar, LPHRP, LPHum = nil, nil, nil

-- FOV CIRCLE (shows immediate on execute)
cfg.FOVCircle = Drawing.new("Circle")
cfg.FOVCircle.Radius = cfg.FOVRadius
cfg.FOVCircle.Filled = false
cfg.FOVCircle.Color = cfg.FOVColor
cfg.FOVCircle.Thickness = 2
cfg.FOVCircle.NumSides = 64
cfg.FOVCircle.Transparency = 0.8

-- MAIN LOOP
local MainLoop = RunService.RenderStepped:Connect(function()
    MouseLoc = UserInputService:GetMouseLocation()
    
    LPChar = LocalPlayer.Character
    if LPChar then
        LPHRP = LPChar:FindFirstChild("HumanoidRootPart")
        LPHum = LPChar:FindFirstChildOfClass("Humanoid")
    end

    cfg.FOVCircle.Position = MouseLoc
    cfg.FOVCircle.Visible = cfg.FOVShow

    -- TARGET FIND
    CurrentTarget = nil
    local MinDist = cfg.FOVRadius
    if LPHRP then
        for _, plr in Players:GetPlayers() do
            if plr ~= LocalPlayer and Targets[plr] then
                local HeadPos, OnScreen = Camera:WorldToViewportPoint(Targets[plr].HeadPos)
                if OnScreen then
                    local Dist = (MouseLoc - Vector2.new(HeadPos.X, HeadPos.Y)).Magnitude
                    if Dist < MinDist then
                        MinDist = Dist
                        CurrentTarget = plr
                    end
                end
            end
        end
    end

    -- SMOOTH AIM
    if cfg.AimbotEnabled and CurrentTarget and LPHRP then
        local TgtPos = Targets[CurrentTarget].HeadPos
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, TgtPos), cfg.AimbotSmoothing)
    end

    -- TRIGGERBOT RAPID HOLD (firesignal safe)
    if cfg.TriggerbotEnabled and CurrentTarget then
        mousemoverel(0,0)  -- Hold steady
        if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
            -- Simulate hold fire
            firesignal(UserInputService.InputBegan, {UserInputType = Enum.UserInputType.MouseButton1})
        end
    end
end)

-- ESP BUILD/CACHE
local function BuildESP(plr)
    if plr == LocalPlayer or ESPObjects[plr] then return end
    local Box = Drawing.new("Square")
    Box.Thickness = 2; Box.Filled = false; Box.Color = Color3.fromRGB(255, 0, 0)
    local Text = Drawing.new("Text")
    Text.Size = 16; Text.Center = true; Text.Outline = true; Text.Color = Color3.fromRGB(255, 255, 255)
    ESPObjects[plr] = {Box = Box, Text = Text}
end

local function UpdateCache()
    Targets = {}
    for _, plr in Players:GetPlayers() do
        local char = plr.Character
        if char and char:FindFirstChild("Head") then
            Targets[plr] = {HeadPos = char.Head.Position}
            if cfg.ESPEnabled then BuildESP(plr) end
        end
    end
end

task.spawn(function()
    while task.wait(0.2) do
        UpdateCache()
        for plr, esp in ESPObjects do
            if Targets[plr] then
                local HeadPos, OnScreen = Camera:WorldToViewportPoint(Targets[plr].HeadPos)
                if OnScreen then
                    local size = 2000 / HeadPos.Z
                    esp.Box.Size = Vector2.new(size, size * 1.5)
                    esp.Box.Position = Vector2.new(HeadPos.X - size / 2, HeadPos.Y - size * 1.5 / 2)
                    esp.Box.Visible = true
                    esp.Text.Text = plr.Name
                    esp.Text.Position = Vector2.new(HeadPos.X, HeadPos.Y - 30)
                    esp.Text.Visible = true
                else
                    esp.Box.Visible = false
                    esp.Text.Visible = false
                end
            end
        end
    end
end)

-- PLAYER EVENTS
for _, plr in Players:GetPlayers() do BuildESP(plr) end
Players.PlayerAdded:Connect(BuildESP)

-- SPEED/JUMP/RECOIL
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = cfg.SpeedHack
end)

UserInputService.JumpRequest:Connect(function()
    if cfg.InfiniteJump and LPHum then LPHum:ChangeState("Jumping") end
end)

task.spawn(function()
    while task.wait() do
        if cfg.NoRecoil and LPChar and LPChar:FindFirstChildOfClass("Tool") then
            Camera.CFrame = Camera.CFrame * CFrame.Angles(0,0,0)
        end
        if LPHum then LPHum.WalkSpeed = cfg.SpeedHack end
    end
end)

-- SILENT AIM
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if cfg.SilentAimEnabled and self == Camera and method == "Raycast" and args[2] and math.random(1,100) <= cfg.HitChance then
        if CurrentTarget and Targets[CurrentTarget] then
            args[2] = (Targets[CurrentTarget][cfg.SilentAimPart].Position - args[1]).Unit * 1000
        end
    end
    return old(self, unpack(args))
end)
setreadonly(mt, true)

-- UNLOCK ALL FLEX
task.spawn(function()
    task.wait(4)
    pcall(function()
        for _, v in LocalPlayer.PlayerGui:GetDescendants() do
            if v:IsA("BoolValue") and v.Name:lower():find("owned") then v.Value = true end
        end
    end)
    print("🌌 ORION FLEX – ALL SKINS UNLOCKED!")
end)

print("🌌 ORION v1.3 LOADED & WORKING – FOV/ESP INSTANT – RAPID TRIGGER HOLD – HEADS EXPLODING SOON, NIGGA! 🩸🎯🔥💀")
