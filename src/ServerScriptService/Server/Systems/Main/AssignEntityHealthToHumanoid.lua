-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requires
local Components = require(ReplicatedStorage.Source.Shared.Components)

-- Locals
local Player = Components.Player
local Enemy = Components.Enemy
local Health = Components.Health

-- Main
local function AssignEntityHealthToHumanoid(World)

    for id, health, player in World:query(Health, Player) do
        player.Model.Humanoid.Health = health.Current
    end

    for id, health, enemy in World:query(Health, Enemy) do
        enemy.Model.Humanoid.Health = health.Current
    end

end

-- Return
return AssignEntityHealthToHumanoid