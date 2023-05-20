-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)

-- Locals
local Remotes_Folder = ReplicatedStorage.Source.Assets.Remotes
local Heavy_Swing_Weapon_Remote = Remotes_Folder.Heavy_Swing_Weapon

local Player = Players.LocalPlayer

-- Main
local function HeavySwingWeapon(World)

    for _, Input, Processed in Matter.useEvent(game.UserInputService, "InputBegan") do
        if Input.UserInputType == Enum.UserInputType.MouseButton2 and game.UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter and not Processed then

            if Player.Character.Humanoid.Health > 0 then
                Heavy_Swing_Weapon_Remote:FireServer()
            end
            
        end
    end

end

-- Return
return HeavySwingWeapon