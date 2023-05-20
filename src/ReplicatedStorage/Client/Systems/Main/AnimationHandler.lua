-- @author xGamerman626

-- Services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)

-- Locals
local Animations_Folder = ReplicatedStorage.Source.Assets.Animations
local Remotes_Folder = ReplicatedStorage.Source.Assets.Remotes
local Play_Animation_Remote = Remotes_Folder.Play_Animation
local Stop_Animation_Remote = Remotes_Folder.Stop_Animation
local Character_Died_Remote = Remotes_Folder.Character_Died

local Player = Players.LocalPlayer

local Loaded_Animations = {}

-- Main
local function AnimationHandler(World)

    for _, Animation_Name in Matter.useEvent(Play_Animation_Remote, "OnClientEvent") do
        if Loaded_Animations[Animation_Name] then -- If already loadded then play it from table
            Loaded_Animations[Animation_Name]:Play()
        else -- If not load it and append to table
            local Loaded_Animation = Player.Character.Humanoid.Animator:LoadAnimation(Animations_Folder[Animation_Name])
            Loaded_Animation:Play()
            Loaded_Animations[Animation_Name] = Loaded_Animation
        end
    end

    for _, Animation_Name in Matter.useEvent(Stop_Animation_Remote, "OnClientEvent") do
        if Loaded_Animations[Animation_Name] then -- If already loadded then play it from table
            Loaded_Animations[Animation_Name]:Stop()
        end
    end

    for _ in Matter.useEvent(Character_Died_Remote, "OnClientEvent") do
        Loaded_Animations = {}
    end

end

-- Return
return AnimationHandler