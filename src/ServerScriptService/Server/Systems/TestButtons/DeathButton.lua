-- @author xGamerman626

-- Services
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)
local Components = require(ReplicatedStorage.Source.Shared.Components)

-- Locals
local Player = Components.Player
local Health = Components.Health

-- Main
local function DeathButton(World)

    for _, Hit in Matter.useEvent(Workspace.Map.Testing.Death, "Touched") do
        if Hit.Parent:IsA("Model") and Hit.Parent:FindFirstChild("Humanoid") then

            local Hit_Player = Players[Hit.Parent.Name]
            
            for id, player, health in World:query(Player, Health) do
                if player.Player == Hit_Player then

                    World:insert(id, health:patch({
                        Current = 0
                    }))

                end
            end

        end
    end

end

-- Return
return DeathButton