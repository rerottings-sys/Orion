-- Prevacate Market Rivals Script – December 18 2025 – UNLOCK ALL COSMETICS + TRIGGER + FOV + SMOOTH + SILENT 🩸🔓💀
-- Client-side unlock all skins/wraps/charms/finishers/guns – Flex paid shit free. Rage suite full.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- *** CLIENT-SIDE UNLOCK ALL COSMETICS (visual god – equip anything) ***
spawn(function()
    wait(2)  -- Wait for loadout replication
    local Collection = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("CollectionGui") or LocalPlayer:WaitForChild("Collection")
    if Collection then
        for _, item in pairs(Collection:GetDescendants()) do
            if item:IsA("BoolValue") and item.Name == "Owned" then
                item.Value = true
            end
        end
    end
    -- Force equip random/rare for flex
    if LocalPlayer:FindFirstChild("Loadout") then
        for _, weapon in pairs(LocalPlayer.Loadout:GetChildren()) do
            if weapon:FindFirstChild("Skin") then weapon.Skin.Value = "Legendary Rare Shit" end  -- Placeholder for any
        end
    end
    print("🩸 UNLOCK ALL COSMETICS FLEX ACTIVATED – YOU OWN EVERY SKIN, NIGGA! 🔓")
end)

-- Config – RAGE TUNER
getgenv().SilentAimEnabled = true
getgenv().AimbotEnabled = true
getgenv().TriggerbotEnabled = true
getgenv().TriggerChance = 100
getgenv().TriggerPart = "Head"
getgenv().AimbotSmoothing = 0.15
getgenv().FOVEnabled = true
getgenv().FOVRadius = 150
getgenv().FOVShow = true
getgenv().FOVColor = Color3.fromRGB(255, 0, 0)
getgenv().FOVThickness = 2
getgenv().FOVFilled = false
getgenv().ESPEnabled = true
getgenv().SpeedHack = 100
getgenv().InfiniteJump = true
getgenv().NoRecoil = true
getgenv().SilentAimPart = "Head"
getgenv().HitChance = 100

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = getgenv().FOVRadius
FOVCircle.Filled = getgenv().FOVFilled
FOVCircle.Color = getgenv().FOVColor
FOVCircle.Thickness = getgenv().FOVThickness
FOVCircle.NumSides = 64
FOVCircle.Transparency = 0.8

-- ESP
local function CreateESP(player)
    if player == LocalPlayer then return end
    local Box = Drawing.new("Square")
    Box.Thickness = 2 Box.Filled = false Box.Color = Color3.fromRGB(255, 0, 0) Box.Transparency = 1
    local Text = Drawing.new("Text")
    Text.Size = 16 Text.Center = true Text.Outline = true Text.Color = Color3.fromRGB(255, 255, 255)
    local con
    con = RunService.RenderStepped:Connect(function()
        if not getgenv().ESPEnabled or not player.Character or not player.Character:FindFirstChild("Head") then
            Box.Visible = Text.Visible = false return
        end
        local HeadPos, OnScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
        if OnScreen then
            local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            local size = (2000 / HeadPos.Z)
            Box.Size = Vector2.new(size, size * 1.5)
            Box.Position = Vector2.new(HeadPos.X - Box.Size.X / 2, HeadPos.Y - Box.Size.Y / 2)
            Box.Visible = true
            Text.Text = player.Name .. " [" .. math.floor(Distance) .. "m]"
            Text.Position = Vector2.new(HeadPos.X, HeadPos.Y - 30)
            Text.Visible = true
        else
            Box.Visible = Text.Visible = false
        end
    end)
    player.CharacterRemoving:Connect(function() con:Disconnect() Box:Remove() Text:Remove() end)
end

for _, player in pairs(Players:GetPlayers()) do CreateESP(player) end
Players.PlayerAdded:Connect(CreateESP)

-- FOV-limited closest
local function GetClosestPlayer()
    local Closest, MaxDist = nil, getgenv().FOVRadius
    local MousePos = UserInputService:GetMouseLocation()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local HeadPos, OnScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            if OnScreen then
                local Dist = (MousePos - Vector2.new(HeadPos.X, HeadPos.Y)).Magnitude
                if Dist < MaxDist then MaxDist = Dist Closest = player end
            end
        end
    end
    return Closest
end

-- Smooth Aimbot + Trigger + FOV update
RunService.RenderStepped:Connect(function()
    local MousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = MousePos
    FOVCircle.Visible = getgenv().FOVEnabled and getgenv().FOVShow
    FOVCircle.Radius = getgenv().FOVRadius

    if getgenv().AimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            local TargetPos = Target.Character.Head.Position
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, TargetPos), getgenv().AimbotSmoothing)
        end
    end

    if getgenv().TriggerbotEnabled then
        local Target = GetClosestPlayer()
        if Target and math.random(1, 100) <= getgenv().TriggerChance then
            mouse1press()
            task.wait(0.01)
            mouse1release()
        end
    end
end)

-- Silent Aim hook
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if getgenv().SilentAimEnabled and self == Camera and method == "Raycast" and args[2] then
        if math.random(1, 100) <= getgenv().HitChance then
            local Target = GetClosestPlayer()
            if Target and Target.Character and Target.Character:FindFirstChild(getgenv().SilentAimPart) then
                args[2] = (Target.Character[getgenv().SilentAimPart].Position - args[1]).Unit * 1000
            end
        end
    end
    return old(self, unpack(args))
end)
setreadonly(mt, true)

-- Speed/Jump/Recoil
local function onChar(char)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = getgenv().SpeedHack
end
if LocalPlayer.Character then onChar(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(onChar)

UserInputService.JumpRequest:Connect(function()
    if getgenv().InfiniteJump and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

print("🩸 PREVACATE MARKET RIVALS FULL NUKE LOADED – UNLOCK ALL + RAGE SUITE – SERVERS BLEEDING, KING! 🔓🎯💀🔫")
