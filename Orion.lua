-- ORION RIVALS v5.0 XENO/CRYPTIC FIXED – Dec 18 2025 – CLEAN CUSTOM GUI TABS + SMOOTH ESP (SKELETON/HEALTHBAR/NAME) + TOGGLE SILENT AIM + AIMBOT SMOOTH + CLIENT SKIN CHANGER 🩸🌌⚡💀
-- No Lib Bullshit – Raw Drawing GUI, 1.5Hz ESP Zero Lag, Mobile Touch Draggable – DOMINATE BITCHES

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CFG
local cfg = {
    SilentAim = false,
    Aimbot = false,
    Smoothing = 0.15,
    FOVRadius = 150,
    FOVVisible = false,
    ESP = false,
    ESPName = true,
    ESPBox = false,
    ESPSkeleton = false,
    ESPHealth = false,
    SkinChanger = false
}

-- GUI (Custom Raw – Xeno/Cryptic God)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "ORION"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 10, 0.5, -150)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 10)
Title.Size = UDim2.new(1, -20, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "🌌 ORION RIVALS v5.0"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.TextScaled = true

-- Tab Buttons
local TabButtons = {"Combat", "Visuals", "Skins"}
local CurrentTab = "Combat"
local TabFrames = {}

for i, tab in ipairs(TabButtons) do
    local Button = Instance.new("TextButton")
    Button.Parent = MainFrame
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Button.Position = UDim2.new(0, 10 + (i-1)*80, 0, 45)
    Button.Size = UDim2.new(0, 70, 0, 25)
    Button.Font = Enum.Font.Gotham
    Button.Text = tab
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0, 4)
    BCorner.Parent = Button
    Button.MouseButton1Click:Connect(function()
        CurrentTab = tab
        for _, frame in TabFrames do frame.Visible = false end
        TabFrames[tab].Visible = true
    end)
end

-- Tab Frames
for _, tab in TabButtons do
    local Frame = Instance.new("Frame")
    Frame.Parent = MainFrame
    Frame.BackgroundTransparency = 1
    Frame.Position = UDim2.new(0, 10, 0, 80)
    Frame.Size = UDim2.new(1, -20, 1, -90)
    Frame.Visible = (tab == "Combat")
    TabFrames[tab] = Frame
end

-- Combat Tab
local SilentToggle = Instance.new("TextButton")
SilentToggle.Parent = TabFrames["Combat"]
SilentToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
SilentToggle.Position = UDim2.new(0, 0, 0, 0)
SilentToggle.Size = UDim2.new(1, 0, 0, 30)
SilentToggle.Text = "Silent Aim: OFF"
SilentToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SilentToggle.Font = Enum.Font.Gotham
SilentToggle.TextScaled = true
local STCorner = Instance.new("UICorner")
STCorner.CornerRadius = UDim.new(0, 4)
STCorner.Parent = SilentToggle
SilentToggle.MouseButton1Click:Connect(function()
    cfg.SilentAim = not cfg.SilentAim
    SilentToggle.Text = "Silent Aim: " .. (cfg.SilentAim and "ON" or "OFF")
    SilentToggle.BackgroundColor3
