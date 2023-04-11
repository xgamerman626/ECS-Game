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
local function Test(World)

    for id, health in World:query(Health) do
        print(id)
    end

end

-- Return
return Test