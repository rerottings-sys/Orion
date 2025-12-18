-- ORION RIVALS v5.0 – Dec 18 2025 – CLEAN GUI TABS + SMOOTH ESP (SKELETON/HEALTHBAR/NAME) + SILENT AIM TOGGLE + AIMBOT SMOOTH + CLIENT SKIN CHANGER 🩸🌌⚡💀
-- Rayfield Tabs: Combat/Visuals/Skins – Delta/Xeno/Mobile/PC God – ZERO LAG RAGE

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()<grok-card data-id="e7e7b0" data-type="citation_card"></grok-card>

local Window = Rayfield:CreateWindow({
   Name = "🌌 ORION RIVALS v5.0",
   LoadingTitle = "ORION RAGE LOADED",
   LoadingSubtitle = "Tabs: Combat | Visuals | Skins",
   ConfigurationSaving = {Enabled = true, FolderName = "OrionRivals", FileName = "Orion.v5"},
   KeySystem = false
})

local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local SkinsTab = Window:CreateTab("Skins", 4483362458)

CombatTab:CreateSection("Aimbot & Silent")
VisualsTab:CreateSection("ESP Options")
SkinsTab:CreateSection("Skin Changer")

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
   ESPHealth = false
}

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.NumSides = 64
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 0.8
FOVCircle.Color = Color3.fromRGB(255,0,0)

-- ESP POOL
local ESPPool = {}

-- GUI CONTROLS
CombatTab:CreateToggle({
   Name = "Silent Aim",
   CurrentValue = false,
   Flag = "SilentToggle",
   Callback = function(v) cfg.SilentAim = v end
})

CombatTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(v) cfg.Aimbot = v end
})

CombatTab:CreateSlider({
   Name = "Smoothing",
   Range = {0.01, 1},
   Increment = 0.01,
   CurrentValue = 0.15,
   Flag = "SmoothSlider",
   Callback = function(v) cfg.Smoothing = v end
})

VisualsTab:CreateToggle({
   Name = "ESP Master",
   CurrentValue = false,
   Flag = "ESPMaster",
   Callback = function(v) cfg.ESP = v end
})

VisualsTab:CreateToggle({
   Name = "Name",
   CurrentValue = true,
   Flag = "NameToggle",
   Callback = function(v) cfg.ESPName = v end
})

VisualsTab:CreateToggle({
   Name = "Box",
   CurrentValue = false,
   Flag = "BoxToggle",
   Callback = function(v) cfg.ESPBox = v end
})

VisualsTab:CreateToggle({
   Name = "Skeleton",
   CurrentValue = false,
   Flag = "SkeletonToggle",
   Callback = function(v) cfg.ESPSkeleton = v end
})

VisualsTab:CreateToggle({
   Name = "Health Bar",
   CurrentValue = false,
   Flag = "HealthToggle",
   Callback = function(v) cfg.ESPHealth = v end
})

VisualsTab:CreateToggle({
   Name = "FOV Circle",
   CurrentValue = false,
   Flag = "FOVToggle
