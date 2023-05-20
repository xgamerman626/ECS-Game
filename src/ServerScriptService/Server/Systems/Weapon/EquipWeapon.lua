-- @author xGamerman626

-- Services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)
local Components = require(ReplicatedStorage.Source.Shared.Components)
local Stored_Data = require(ServerStorage.Source.Config.Stored_Data)

-- Locals
local Remotes_Folder = ReplicatedStorage.Source.Assets.Remotes
local Equip_Weapon_Remote = Remotes_Folder.Equip_Weapon

local Player = Components.Player
local Weapon = Components.Weapon

-- Main
local function EquipWeapon(World)

    for _, Player_Instance in Matter.useEvent(Equip_Weapon_Remote, "OnServerEvent") do

        -- Check if player has a weapon component if so check if it's equipped
        for id, character, weapon in World:query(Player, Weapon) do

            if weapon.Equipped == false and weapon.Swinging == false then
                World:insert(id, weapon:patch({
                    Equipped = true
                }))
            elseif weapon.Equipped == true and weapon.Swinging == false then
                World:insert(id, weapon:patch({
                    Equipped = false
                }))
            end

        end
        
    end

end

-- Return
return EquipWeapon