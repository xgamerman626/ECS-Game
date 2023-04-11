-- @author xGamerman626

-- Services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)
local Components = require(ReplicatedStorage.Source.Config.Components)
local Entity_States = require(ReplicatedStorage.Source.Config.Entity_States)

-- Main
local function CharacterAdded(World)

    for _, Player in ipairs(Players:GetPlayers()) do
        for _, Character in Matter.useEvent(Player, "CharacterAdded") do
            World:spawn(
                Components.Player({
                    Player = Player,
                    Model = Character,
                    -- States = States_M.NewPlayerStates(),
                    States = Entity_States.Player,
                }),
                Components.Health({
                    Current = 100,
                    Max = 100,
                })
            )
            print(script.Name, "SpawnedEntity4Character", Character.Name)
        end
    end

end

-- Return
return CharacterAdded