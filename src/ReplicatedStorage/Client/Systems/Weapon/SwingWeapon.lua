-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)

-- Locals
local Remotes_Folder = ReplicatedStorage.Source.Assets.Remotes
local Swing_Weapon_Remote = Remotes_Folder.Swing_Weapon

local Player = Players.LocalPlayer

-- Main
local function SwingWeapon(World)

    for _, Input, Processed in Matter.useEvent(game.UserInputService, "InputBegan") do
        if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Processed then

            if Player.Character.Humanoid.Health > 0 then
                Swing_Weapon_Remote:FireServer()
            end
            
        end
    end

end

-- Return
return SwingWeapon