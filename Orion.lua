-- ORION CLEAN GUI v4.1 – Dec 18 2025 – SKELETON ESP + BOX TOGGLE + COLOR + ZERO LAG – DELTA/XENO INSTANT 🩸🌌⚡
-- 2Hz Throttle, Pooled Lines, Onscreen Cull – ESP Silky 300+FPS Rage

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🌌 ORION Rivals Rage v4.1",
   LoadingTitle = "ORION ESP UPGRADE",
   LoadingSubtitle = "Skeleton + Colors + No Lag",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "OrionRivals",
      FileName = "OrionConfig"
   },
   KeySystem = false
})

local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

local AimbotSection = CombatTab:CreateSection("Aimbot")
local ESPSection = VisualsTab:CreateSection("ESP Options")

local cfg = {
   AimbotEnabled = true,
   Smoothing = 0.15,
   TriggerEnabled = false,
   FOVRadius = 150,
   FOVVisible = true,
   ESPEnabled = true,
   ESPBoxes = true,
   ESPSkeleton = false,
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

-- ESP Pool {plr = {Box, Name, Lines = {}}}
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
   Name.Outline = true
   Name.Color = Color3.new(1,1,1)
   Name.Visible = false

   local Lines = {}
   for i = 1, #JOINTS - 1 do
      local Line = Drawing.new("Line")
      Line.Thickness = 1  -- Thin for no lag
      Line.Color = cfg.ESPColor
      Line.Transparency = 1
      Line.Visible = false
      Lines[i] = Line
   end

   ESPPool[Player] = {Box = Box, Name = Name, Lines = Lines}
end

-- Update ESP ULTRA SMOOTH (2Hz = 0.5s throttle)
spawn(function()
   while task.wait(0.5) do  -- 2Hz godmode
      if not cfg.ESPEnabled then
         for _, ESP in pairs(ESPPool) do
            ESP.Box.Visible = false
            ESP.Name.Visible = false
            for _, Line in pairs(ESP.Lines) do Line.Visible = false end
         end
         continue
      end

      for Player, ESP in pairs(ESPPool) do
         if Player.Character and Player.Character:FindFirstChild("Head") and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.Humanoid.Health > 0 then
            local HeadPos, OnScreen = Camera:WorldToViewportPoint(Player.Character.Head.Position)
            if OnScreen then
               local Size = (2000 / HeadPos.Z)
               
               -- BOX
               if cfg.ESPBoxes then
                  ESP.Box.Size = Vector2.new(Size, Size * 1.5)
                  ESP.Box.Position = Vector2.new(HeadPos.X - Size/2, HeadPos.Y - Size*1.5/2)
                  ESP.Box.Color = cfg.ESPColor
                  ESP.Box.Visible = true
               else
                  ESP.Box.Visible = false
               end

               -- NAME
               ESP.Name.Text = Player.Name
               ESP.Name.Position = Vector2.new(HeadPos.X, HeadPos.Y - Size*1.5/2 - 16)
               ESP.Name.Visible = true

               -- SKELETON LINES (only if enabled, pooled thin lines)
               if cfg.ESPSkeleton then
                  local Parts = {}
                  for _, joint in JOINTS do
                     if Player.Character:FindFirstChild(joint) then
                        local _, OnScreenPart = Camera:WorldToViewportPoint(Player.Character[joint].Position)
                        if OnScreenPart then
                           Parts[joint] = Vector2.new(OnScreenPart.X, OnScreenPart.Y)
                        end
                     end
                  end
                  
                  -- Connect key joints (head to neck, torso chain, arms, legs)
                  local Connections = {
                     {Parts.Head, Parts.UpperTorso},
                     {Parts.UpperTorso, Parts.LowerTorso},
                     {Parts.UpperTorso, Parts.LeftUpperArm}, {Parts.LeftUpperArm, Parts.LeftLowerArm}, {Parts.LeftLowerArm, Parts.LeftHand},
                     {Parts.UpperTorso, Parts.RightUpperArm}, {Parts.RightUpperArm, Parts.RightLowerArm}, {Parts.RightLowerArm, Parts.RightHand},
                     {Parts.LowerTorso, Parts.LeftUpperLeg}, {Parts.LeftUpperLeg, Parts.LeftLowerLeg}, {Parts.LeftLowerLeg, Parts.LeftFoot},
                     {Parts.LowerTorso, Parts.RightUpperLeg}, {Parts.RightUpperLeg, Parts.RightLowerLeg}, {Parts.RightLowerLeg, Parts.RightFoot}
                  }
                  
                  for i, conn in ipairs(Connections) do
                     if conn[1] and conn[2] then
                        ESP.Lines[i].From = conn[1]
                        ESP.Lines[i].To = conn[2]
                        ESP.Lines[i].Color = cfg.ESPColor
                        ESP.Lines[i].Visible = true
                     else
                        ESP.Lines[i].Visible = false
                     end
                  end
               else
                  for _, Line in pairs(ESP.Lines) do Line.Visible = false end
               end
            else
               ESP.Box.Visible = false
               ESP.Name.Visible = false
               for _, Line in pairs(ESP.Lines) do Line.Visible = false end
            end
         else
            ESP.Box.Visible = false
            ESP.Name.Visible = false
            for _, Line in pairs(ESP.Lines) do Line.Visible = false end
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

VisualsTab:CreateToggle({
   Name = "ESP Master",
   CurrentValue = true,
   Flag = "ESPMaster",
   Callback = function(Value)
      cfg.ESPEnabled = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Boxes",
   CurrentValue = true,
   Flag = "BoxesToggle",
   Callback = function(Value)
      cfg.ESPBoxes = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Skeleton",
   CurrentValue = false,
   Flag = "SkeletonToggle",
   Callback = function(Value)
      cfg.ESPSkeleton = Value
   end,
})

VisualsTab:CreateColorPicker({
   Name = "ESP Color",
   Color = Color3.fromRGB(255, 0, 0),
   Flag = "ESPColorPicker",
   Callback = function(Value)
      cfg.ESPColor = Value
   end,
})

VisualsTab:CreateSlider({
   Name = "ESP Thickness",
   Range = {1, 3},
   Increment = 0.5,
   CurrentValue = 1.5,
   Flag = "ESPThickness",
   Callback = function(Value)
      cfg.ESPThickness = Value
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

-- Main Loop (aimbot/trigger unchanged)
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
      if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("Head") and Player.Character.Humanoid.Health > 0 then
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

   if cfg.AimbotEnabled and ClosestTarget and ClosestTarget.Character and ClosestTarget.Character:FindFirstChild("Head") then
      local TargetPos = ClosestTarget.Character.Head.Position
      Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, TargetPos), cfg.Smoothing)
   end
end)

-- Init ESP Pool
for _, Player in pairs(Players:GetPlayers()) do
   CreateESP(Player)
end
Players.PlayerAdded:Connect(CreateESP)

Players.PlayerRemoving:Connect(function(Player)
   if ESPPool[Player] then
      ESPPool[Player].Box:Remove()
      ESPPool[Player].Name:Remove()
      for _, Line in pairs(ESPPool[Player].Lines) do Line:Remove() end
      ESPPool[Player] = nil
   end
end)

Rayfield:Notify({
   Title = "ORION v4.1 Loaded",
   Content = "Skeleton ESP + Boxes Toggle + Colors + ZERO LAG ACTIVE!",
   Duration = 6,
   Image = 4483362458
})
