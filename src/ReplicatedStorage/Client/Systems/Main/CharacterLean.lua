-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)

-- Locals
local Player = Players.LocalPlayer

local Force = nil
local Direction = nil
local Value1 = 0
local Value2 = 0

local RootJointC0 = nil
local LeftHipJointC0 = nil
local RightHipJointC0 = nil

-- Main
local function CharacterLean(World)

    if Player.Character then

        -- Locals
        local Character = Player.Character
        local HumanoidRootPart = Character.HumanoidRootPart
        local Torso	= Character.Torso

        local RootJoint = HumanoidRootPart["Root Hip"]
        local LeftHipJoint = Torso["Left Hip"]
        local RightHipJoint = Torso["Right Hip"]

        if RootJointC0 == nil then -- Only want to set this once.
            RootJointC0 = RootJoint.C0
            LeftHipJointC0 = LeftHipJoint.C0
            RightHipJointC0 = RightHipJoint.C0
        end

        -- Main
        if Character.Humanoid.Health <= 0 then
            return
        end

        Force = HumanoidRootPart.Velocity * Vector3.new(1,0,1)
        if Force.Magnitude > 2 then
            Direction = Force.Unit	
            Value1 = HumanoidRootPart.CFrame.RightVector:Dot(Direction)
            Value2 = HumanoidRootPart.CFrame.LookVector:Dot(Direction)
        else
            Value1 = 0
            Value2 = 0
        end

        RootJoint.C0 = RootJoint.C0:Lerp(RootJointC0 * CFrame.Angles(math.rad(Value2 * 10), math.rad(-Value1 * 10), 0), 0.2)
        LeftHipJoint.C0 = LeftHipJoint.C0:Lerp(LeftHipJointC0 * CFrame.Angles(math.rad(Value1 * 10), 0, 0), 0.2)
        RightHipJoint.C0 = RightHipJoint.C0:Lerp(RightHipJointC0 * CFrame.Angles(math.rad(-Value1 * 10), 0, 0), 0.2)
    
    end

end

-- Return
return CharacterLean