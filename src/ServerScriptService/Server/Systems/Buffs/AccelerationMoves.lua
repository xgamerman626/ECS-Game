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
local Buffs = Components.Buffs

-- Main
local function AccelerationMoves(World)

    -- Players
    for id, health, player, buffs in World:query(Health, Player, Buffs) do
        if health.Current > 0 then

            local Acceleration = buffs["Acceleration"]
            if Matter.useThrottle(1) and Acceleration then
                if Acceleration.Time == 1 then
                    player.Model.Humanoid.WalkSpeed -= Acceleration.SpeedBonus
                end

                if Acceleration.Activated == true then
                    return
                end

                Acceleration.Activated = true
                player.Model.Humanoid.WalkSpeed += Acceleration.SpeedBonus
            
            end

        end
    end

    -- Entities

end

-- Return
return AccelerationMoves