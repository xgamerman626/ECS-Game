-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)

-- Locals
local Remotes_Folder = ReplicatedStorage.Source.Assets.Remotes
local Equip_Weapon_Remote = Remotes_Folder.Equip_Weapon

-- Main
local function EquipWeapon(World)

    for _, Input, Processed in Matter.useEvent(game.UserInputService, "InputBegan") do
        if Input.KeyCode == Enum.KeyCode.Q and not Processed then
            Equip_Weapon_Remote:FireServer()
        end
    end

end

-- Return
return EquipWeapon