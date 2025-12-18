-- ORION CLEAN GUI v4.3 – Dec 18 2025 – ESP CHECKBOXES FIXED + HEALTH BARS ✓ + SKELETON ✓ + BOXES ✓ – ZERO LAG 🩸🌌⚡💀
-- All Toggles Live, Pooled Draws, 2Hz Cull – Rivals ESP Godmode

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🌌 ORION Rivals Rage v4.3",
   LoadingTitle = "ESP OPTIONS FIXED",
   LoadingSubtitle = "Checkboxes + Health Bars Loaded",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "OrionRivals",
      FileName = "OrionConfig"
   },
   KeySystem = false
})

local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

CombatTab:CreateSection("Aimbot")
VisualsTab:CreateSection("ESP Options")

local cfg = {
   AimbotEnabled = true,
   Smoothing = 0.15,
   TriggerEnabled = false,
   FOVRadius = 150,
   FOVVisible = true,
   ESPEnabled = true,
   ESPBoxes = true,
   ESPSkeleton = false,
   ESPHealthBar = false,
   ESPHealthSide = "Left",
   ESPColor = Color3.fromRGB(255, 0, 0),
   ESPThickness = 1.5
}

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.NumSides = 64
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 0.8
FOVCircle.Color = Color3.fromRGB(255, 0, 0)

-- ESP Pool
local ESPPool = {}

local JOINTS = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}

-- Create ESP
local function CreateESP(Player)
   if Player == LocalPlayer or ESPPool[Player] then return end
   
   local Box = Drawing.new("Square")
   Box.Size = Vector2.new(0,0)
   Box.Color = cfg.ESPColor
   Box.Thickness = cfg.ESPThickness
   Box.Filled = false
   Box.Visible = false

   local Name = Drawing.new("Text")
   Name.Size = 14
   Name.Center = true
   Name.Outline =
