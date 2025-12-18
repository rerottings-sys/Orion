local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local window = library.CreateLib("Rivals Script", "DarkTheme")

local mainTab = window:NewTab("Main")
local aimbotSection = mainTab:NewSection("Aimbot")
local espSection = mainTab:NewSection("ESP")

-- Aimbot Settings
local aimbotEnabled = false
local teamCheck = true
local fov = 150
local smoothing = 0.2
local lockPart = "Head"
local showFov = true
local fovColor = Color3.fromRGB(255, 128, 128)

aimbotSection:NewToggle("Enabled", "Toggle Aimbot", function(state)
    aimbotEnabled = state
end)

aimbotSection:NewToggle("Team Check", "Ignore Teammates", function(state)
    teamCheck = state
end)

aimbotSection:NewSlider("FOV", "Field of View Radius", 500, 50, function(value)
    fov = value
end)

aimbotSection:NewSlider("Smoothing", "Aimbot Smoothness (0-1)", 100, 1, function(value)
    smoothing = value / 100
end)

aimbotSection:NewDropdown("Lock Part", "Target Body Part", {"Head", "HumanoidRootPart", "Torso"}, function(value)
    lockPart = value
end)

aimbotSection:NewToggle("Show FOV Circle", "Display FOV Circle", function(state)
    showFov = state
end)

aimbotSection:NewColorPicker("FOV Color", "Color of FOV Circle", fovColor, function(color)
    fovColor = color
end)

-- ESP Settings
local espEnabled = false
local espColor = Color3.fromRGB(255, 0, 0)
local espTeamCheck = true

espSection:NewToggle("Enabled", "Toggle ESP", function(state)
    espEnabled = state
end)

espSection:NewColorPicker("ESP Color", "Color for ESP", espColor, function(color)
    espColor = color
end)

espSection:NewToggle("Team Check", "Ignore Teammates in ESP", function(state)
    espTeamCheck = state
end)

-- FOV Circle
local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 1
FOVring.Radius = fov
FOVring.Transparency = 0.8
FOVring.Color = fovColor
FOVring.Position = workspace.CurrentCamera.ViewportSize / 2

-- ESP Drawings
local espDrawings = {}

-- Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Aimbot Logic
local currentTarget = nil
local toggleState = false
local ToggleKey = Enum.UserInputType.MouseButton2 -- Right Click

local UserInputService = game:GetService("UserInputService")

local function getClosest(cframe)
    local ray = Ray.new(cframe.Position, cframe.LookVector).Unit
    local target = nil
    local mag = math.huge
    local screenCenter = Camera.ViewportSize / 2
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(lockPart) and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and (not teamCheck or v.Team ~= LocalPlayer.Team) then
            local screenPoint, onScreen = Camera:WorldToViewportPoint(v.Character[lockPart].Position)
            local distanceFromCenter = (Vector2.new(screenPoint.X, screenPoint.Y) - screenCenter).Magnitude
            if onScreen and distanceFromCenter <= fov then
                local magBuf = (v.Character[lockPart].Position - ray:ClosestPoint(v.Character[lockPart].Position)).Magnitude
                if magBuf < mag then
                    mag = magBuf
                    target = v
                end
            end
        end
    end
    return target
end

local function updateFOVRing()
    FOVring.Position = Camera.ViewportSize / 2
    FOVring.Radius = fov
    FOVring.Color = fovColor
    FOVring.Visible = showFov and aimbotEnabled
end

RunService.RenderStepped:Connect(function()
    updateFOVRing()
    if aimbotEnabled then
        toggleState = UserInputService:IsMouseButtonPressed(ToggleKey)
        if toggleState then
            if not currentTarget then
                currentTarget = getClosest(Camera.CFrame)
            end
            if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild(lockPart) then
                local targetPos = currentTarget.Character[lockPart].Position
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), smoothing)
            end
        else
            currentTarget = nil
        end
    end
end)

-- ESP Logic
local function addESP(player)
    if player == LocalPlayer or (espTeamCheck and player.Team == LocalPlayer.Team) then return end
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = espColor
    box.Thickness = 1
    box.Transparency = 1
    
    local name = Drawing.new("Text")
    name.Visible = false
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Size = 16
    name.Transparency = 1
    
    espDrawings[player] = {box = box, name = name}
end

local function removeESP(player)
    if espDrawings[player] then
        espDrawings[player].box:Remove()
        espDrawings[player].name:Remove()
        espDrawings[player] = nil
    end
end

local function updateESP()
    for player, drawings in pairs(espDrawings) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
            local rootPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            local headPos = Camera:WorldToViewportPoint(player.Character.Head.Position + Vector3.new(0, 0.5, 0))
            local legPos = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
            
            if onScreen then
                drawings.box.Size = Vector2.new(1000 / rootPos.Z, headPos.Y - legPos.Y)
                drawings.box.Position = Vector2.new(rootPos.X - drawings.box.Size.X / 2, rootPos.Y - drawings.box.Size.Y / 2)
                drawings.box.Visible = true
                
                drawings.name.Text = player.Name
                drawings.name.Position = Vector2.new(rootPos.X, rootPos.Y - drawings.box.Size.Y / 2 - 16)
                drawings.name.Visible = true
            else
                drawings.box.Visible = false
                drawings.name.Visible = false
            end
        else
            drawings.box.Visible = false
            drawings.name.Visible = false
        end
    end
end

RunService.RenderStepped:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

-- Player Added/Removing
for _, player in pairs(Players:GetPlayers()) do
    addESP(player)
end

Players.PlayerAdded:Connect(addESP)
Players.PlayerRemoving:Connect(removeESP)

-- Make ESP smooth by using RenderStepped for updates
-- Loads instantly on execute
