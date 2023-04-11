-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)
local Components = require(ReplicatedStorage.Source.Config.Components)

-- Locals
local Player = Components.Player
local Health = Components.Health
local Poisoned = Components.Poisoned

-- Main
local function PoisonHurts(World)

    for id, health, player, poisoned in World:query(Health, Player, Poisoned) do
        if health.Current > 0 and poisoned.Time > 0 then

            if Matter.useThrottle(1) then
                World:insert(id, poisoned:patch({
                    Time = poisoned.Time - 1
                }))
                World:insert(id, health:patch({
                    Current = math.min(health.Max, health.Current - poisoned.DPS)
                }))
            end

        end
    end

end

-- Return
return PoisonHurts