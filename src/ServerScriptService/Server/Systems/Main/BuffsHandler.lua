-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)
local Components = require(ReplicatedStorage.Source.Shared.Components)

-- Locals
local Remotes_Folder = ReplicatedStorage.Source.Assets.Remotes
local Play_Debuff_Remote = Remotes_Folder.Play_Debuff
local Play_Buff_Remote = Remotes_Folder.Play_Buff

local Player = Components.Player
local Health = Components.Health
local Buffs = Components.Buffs
local Debuffs = Components.Debuffs

-- Main
local function BuffsHandler(World)

    for id, health, player, buffs, debuffs in World:query(Health, Player, Buffs, Debuffs) do

        if Matter.useThrottle(1) then
            for Debuff_Name, Debuff_Table in pairs(debuffs) do
                
                if Debuff_Table.Start == true then
                    -- Send to user interface
                    Play_Debuff_Remote:FireClient(player.Player, Debuff_Name, Debuff_Table.Time)
                    Debuff_Table.Start = false
                end

                Debuff_Table.Time -= 1

                -- Remove debuff if ran out of time.
                if Debuff_Table.Time == 0 then
                    World:insert(id, debuffs:patch({
                        [Debuff_Name] = Matter.None
                    }))
                end

            end

            for Buff_Name, Buff_Table in pairs(buffs) do
                
                if Buff_Table.Start == true then
                    -- Send to user interface
                    Play_Buff_Remote:FireClient(player.Player, Buff_Name, Buff_Table.Time)
                    Buff_Table.Start = false
                end

                Buff_Table.Time -= 1

                -- Remove debuff if ran out of time.
                if Buff_Table.Time == 0 then
                    World:insert(id, buffs:patch({
                        [Buff_Name] = Matter.None
                    }))
                end

            end
        end

    end

end

-- Return
return BuffsHandler