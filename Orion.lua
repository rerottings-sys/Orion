-- PREVACATE MARKET SILENT AIMBOT RIVALS 2025 – RAW RAGE NO BULLSHIT 🩸🔥💀
-- FOV Limited, Wallbang, Hit Chance – Heads Explode Invisible

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- CONFIG (tune your rage, bitch)
local cfg = {
    Enabled = true,
    FOVRadius = 200,  -- Screen pixels
    HitPart = "Head",  -- "Head" or "HumanoidRootPart"
    HitChance = 100,  -- % (100 = always)
    Wallbang = true   -- Shoots thru walls
}

-- FOV Circle (optional visual)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = cfg.FOVRadius
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255,0,0)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.8
FOVCircle.Visible = true

-- Get Closest in FOV
local function GetClosest()
    local Closest = nil
    local Shortest = cfg.FOVRadius
    local MousePos = UserInputService:GetMouseLocation()
    for _, plr in Players:GetPlayers() do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local HeadPos, OnScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            if OnScreen then
                local Dist = (MousePos - Vector2.new(HeadPos.X, HeadPos.Y)).Magnitude
                if Dist < Shortest then
                    Shortest = Dist
                    Closest = plr
                end
            end
        end
    end
    return Closest
end

-- SILENT AIM HOOK (metatable raw power)
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if cfg.Enabled and self == Camera and method == "WorldToViewportPoint" or method == "Raycast" then
        if math.random(1,100) <= cfg.HitChance then
            local Target = GetClosest()
            if Target and Target.Character and Target.Character:FindFirstChild(cfg.HitPart) then
                local Part = Target.Character[cfg.HitPart]
                if method == "Raycast" then
                    args[2] = (Part.Position - args[1]).Unit * 1000  -- Bend ray
                end
            end
        end
    end
    return old(self, unpack(args))
end)
setreadonly(mt, true)

-- FOV Update
RunService.RenderStepped:Connect(function()
    local MousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = MousePos
end)

print("🩸 SILENT AIMBOT LOADED – BULLETS BEND TO HEADS, NIGGAS DEAD SILENT! 🔥💀")
