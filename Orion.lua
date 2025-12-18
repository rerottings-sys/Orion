-- ORION CLEAN GUI v4.0 – Dec 18 2025 – ESP/Aimbot/FOV/Smoothing – DELTA/XENO INSTANT LOAD 🩸🌌⚡💀
-- Clean Rayfield UI, Optimized ESP, Smooth Aimbot, FOV Slider – Rivals Godmode

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🌌 ORION Rivals Rage",
   LoadingTitle = "ORION Loaded",
   LoadingSubtitle = "by Prevacate Market",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "OrionRivals",
      FileName = "OrionConfig"
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false
})

local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

local AimbotSection = CombatTab:CreateSection("Aimbot")
local TriggerSection = CombatTab:CreateSection("Trigger")

local cfg = {
   AimbotEnabled = true,
   Smoothing = 0.15,
   TriggerEnabled = false,
   FOVRadius = 150,
   FOVVisible = true,
   ESPEnabled = true
}

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.NumSides = 64
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 0.8
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Visible = false

-- ESP Pool
local ESPPool = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Create ESP
local function CreateESP(Player)
   if Player == LocalPlayer then return end
   local Box = Drawing.new("Square")
   Box.Size = Vector2.new(0,0)
   Box.Color = Color3.new(1,0,0)
   Box.Thickness = 1.5
   Box.Filled = false
   Box.Visible = false

   local Name = Drawing.new("Text")
   Name.Size = 14
   Name.Center = true
   Name.Outline = true
   Name.Color = Color3.new(1,1,1)
   Name.Visible = false

   ESPPool[Player] = {Box = Box, Name = Name}
end

-- Update ESP (3Hz optimized)
spawn(function()
   while task.wait(0.33) do
      if not cfg.ESPEnabled then
         for _, ESP in pairs(ESPPool) do
            ESP.Box.Visible = false
            ESP.Name.Visible = false
         end
         continue
      end

      for Player, ESP in pairs(ESPPool) do
         if Player.Character and Player.Character:FindFirstChild("Head") and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.Humanoid.Health > 0 then
            local HeadPos, OnScreen = Camera:WorldToViewportPoint(Player.Character.Head.Position)
            if OnScreen then
               local Size = (2000 / HeadPos.Z)
               ESP.Box.Size = Vector2.new(Size, Size * 1.5)
               ESP.Box.Position = Vector2.new(HeadPos.X - Size/2, HeadPos.Y - Size*1.5/2)
               ESP.Box.Visible = true

               ESP.Name.Text = Player.Name
               ESP.Name.Position = Vector2.new(HeadPos.X, HeadPos.Y - Size*1.5/2 - 16)
               ESP.Name.Visible = true
            else
               ESP.Box.Visible = false
               ESP.Name.Visible = false
            end
         else
            ESP.Box.Visible = false
            ESP.Name.Visible = false
         end
      end
   end
end)

-- Toggles/Sliders
CombatTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = true,
   Flag = "AimbotToggle",
   Callback = function(Value)
      cfg.AimbotEnabled = Value
   end,
})

CombatTab:CreateSlider({
   Name = "Smoothing",
   Range = {0.01, 1},
   Increment = 0.01,
   CurrentValue = 0.15,
   Flag = "SmoothingSlider",
   Callback = function(Value)
      cfg.Smoothing = Value
   end,
})

CombatTab:CreateToggle({
   Name = "Triggerbot",
   CurrentValue = false,
   Flag = "TriggerToggle",
   Callback = function(Value)
      cfg.TriggerEnabled = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "ESP",
   CurrentValue = true,
   Flag = "ESPToggle",
   Callback = function(Value)
      cfg.ESPEnabled = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "FOV Circle",
   CurrentValue = true,
   Flag = "FOVToggle",
   Callback = function(Value)
      cfg.FOVVisible = Value
      FOVCircle.Visible = Value
   end,
})

VisualsTab:CreateSlider({
   Name = "FOV Radius",
   Range = {50, 500},
   Increment = 10,
   CurrentValue = 150,
   Flag = "FOVSlider",
   Callback = function(Value)
      cfg.FOVRadius = Value
      FOVCircle.Radius = Value
   end,
})

-- Main Loop
local ClosestTarget = nil
RunService.RenderStepped:Connect(function()
   local MousePos = UserInputService:GetMouseLocation()
   FOVCircle.Position = MousePos
   FOVCircle.Visible = cfg.FOVVisible

   local LPChar = LocalPlayer.Character
   if not LPChar or not LPChar:FindFirstChild("HumanoidRootPart") then return end
   local LPHRP = LPChar.HumanoidRootPart

   ClosestTarget = nil
   local ShortestDistance = cfg.FOVRadius

   for _, Player in pairs(Players:GetPlayers()) do
      if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("Head") and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.Humanoid.Health > 0 then
         local HeadPos, OnScreen = Camera:WorldToViewportPoint(Player.Character.Head.Position)
         if OnScreen then
            local Distance = (MousePos - Vector2.new(HeadPos.X, HeadPos.Y)).Magnitude
            if Distance < ShortestDistance then
               ShortestDistance = Distance
               ClosestTarget = Player
            end
         end
      end
   end

   -- Aimbot Smooth
   if cfg.AimbotEnabled and ClosestTarget and ClosestTarget.Character and ClosestTarget.Character:FindFirstChild("Head") then
      local TargetPos = ClosestTarget.Character.Head.Position
      Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, TargetPos), cfg.Smoothing)
   end

   -- Triggerbot
   if cfg.TriggerEnabled and ClosestTarget then
      local Tool = LPChar:FindFirstChildOfClass("Tool")
      if Tool then
         Tool:Activate()
      end
   end
end)

-- Init ESP
for _, Player in pairs(Players:GetPlayers()) do
   CreateESP(Player)
end
Players.PlayerAdded:Connect(CreateESP)

Players.PlayerRemoving:Connect(function(Player)
   if ESPPool[Player] then
      ESPPool[Player].Box:Remove()
      ESPPool[Player].Name:Remove()
      ESPPool[Player] = nil
   end
end)

Rayfield:Notify({
   Title = "ORION Loaded",
   Content = "Clean GUI Active – Melt Niggas!",
   Duration = 5,
   Image = 4483362458
})
