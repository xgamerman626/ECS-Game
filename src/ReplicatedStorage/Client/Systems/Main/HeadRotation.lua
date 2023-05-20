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
local function IsCharacterAlive(Player)
    local Character = Player.Character
    if Character then
        local Humanoid = Character:FindFirstChild("Humanoid")
        return Humanoid and Humanoid.Health > 0 and Character.HumanoidRootPart:FindFirstChild("Root Hip")
    end
end


local function HeadRotation(World)

    if IsCharacterAlive(Player) then

        -- Locals
        local Character = Player.Character
        local Humanoid = Character.Humanoid
        local HumanoidRootPart = Character.HumanoidRootPart
        local Torso = Character.Torso
        local Neck = Torso.Neck

        local CameraDirection = HumanoidRootPart.CFrame:toObjectSpace(Camera.CFrame).lookVector

        -- Main
        if Neck then
            Neck.C0 = CFrame.new(0, Neck.C0.Y, 0) * CFrame.Angles(3 * math.pi/2, 0, math.pi) * CFrame.Angles(0, 0, -math.asin(CameraDirection.x)) * CFrame.Angles(-math.asin(CameraDirection.y), 0, 0)
        end
  
    end

end

-- Return
return HeadRotation