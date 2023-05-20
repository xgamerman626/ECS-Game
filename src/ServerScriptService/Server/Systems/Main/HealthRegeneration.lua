-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requires
local Components = require(ReplicatedStorage.Source.Shared.Components)

-- Locals
local Player = Components.Player
local Health = Components.Health
local Debuffs = Components.Debuffs

-- Main
local function HealthRegenration(World)

    for id, health, player, debuffs in World:query(Health, Player, Debuffs) do
        if player.States.InCombat == true then
            return
        end

        local Bleeding = debuffs["Bleeding"]
        if Bleeding then
            return
        end

        if health.Current < health.Max and player.States.SittingAtCampfire == false then
            
            World:insert(id, health:patch({
                Current = math.min(health.Max, health.Current + (health.Max * 0.001 / 3))
            }))
            
        elseif health.Current < health.Max and player.States.SittingAtCampfire == true then

            World:insert(id, health:patch({
                Current = math.min(health.Max, health.Current + (health.Max * 0.001))
            }))

        end
    end

end

-- Return
return HealthRegenration