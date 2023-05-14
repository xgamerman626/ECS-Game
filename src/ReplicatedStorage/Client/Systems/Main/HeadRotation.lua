-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)

-- Locals
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Main
local function HeadRotation(World)

    if Player.Character then

        -- Locals
        local Character = Player.Character
        local HumanoidRootPart = Character.HumanoidRootPart
        local Humanoid = Character.Humanoid
        local Torso = Character.Torso

        local Neck = Torso.Neck

        -- Main
        if Humanoid.Health <= 0 then
            return
        end
        
        local CameraDirection = HumanoidRootPart.CFrame:toObjectSpace(Camera.CFrame).lookVector
        if Neck then
            Neck.C0 = CFrame.new(0, Neck.C0.Y, 0) * CFrame.Angles(3 * math.pi/2, 0, math.pi) * CFrame.Angles(0, 0, -math.asin(CameraDirection.x)) * CFrame.Angles(-math.asin(CameraDirection.y), 0, 0)
        end
  
    end

end

-- Return
return HeadRotation