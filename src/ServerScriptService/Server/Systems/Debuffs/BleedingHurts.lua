-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)
local Components = require(ReplicatedStorage.Source.Shared.Components)

-- Locals
local Player = Components.Player
local Enemy = Components.Enemy
local Health = Components.Health
local Debuffs = Components.Debuffs

-- Main
local function BleedingHurts(World)

    -- Players
    for id, health, player, debuffs in World:query(Health, Player, Debuffs) do
        if health.Current > 0 then

            local Bleeding = debuffs["Bleeding"]
            if Matter.useThrottle(1) and Bleeding then
                World:insert(id, health:patch({
                    Current = health.Current - Bleeding.DamagePerTick
                }))
            end

        end
    end

    -- Entities
    for id, health, enemy, debuffs in World:query(Health, Enemy, Debuffs) do
        if health.Current > 0 then

            local Bleeding = debuffs["Bleeding"]
            if Matter.useThrottle(1) and Bleeding then
                World:insert(id, health:patch({
                    Current = health.Current - Bleeding.DamagePerTick
                }))
            end

        end
    end

end

-- Return
return BleedingHurts