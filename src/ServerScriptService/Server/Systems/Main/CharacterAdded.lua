-- @author xGamerman626

-- Services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)
local Components = require(ReplicatedStorage.Source.Shared.Components)
local Entity_States = require(ReplicatedStorage.Source.Shared.Entity_States)
local Stored_Data = require(ServerStorage.Source.Config.Stored_Data)
local Items = require(ReplicatedStorage.Source.Config.Items)

-- Main
local function CharacterAdded(World)

    for _, Player_Instance in ipairs(Players:GetPlayers()) do

        for _, Character in Matter.useEvent(Player_Instance, "CharacterAdded") do
            -- Locals
            local Player_Data = Stored_Data.Players[Player_Instance].Data
            Player_Data.Inventory.Equipped.Weapon = "Training Greatsword"

            -- Main
            World:spawn(
                Components.Player({
                    Player = Player_Instance,
                    Model = Character,
                    -- States = States_M.NewPlayerStates(),
                    States = Entity_States.Player,
                }),
                Components.Health({
                    Current = 100,
                    Max = 100,
                }),
                Components.Weapon({
                    Config = nil,
                    WeaponTable = nil,
                    Equipped = false,
                    Swinging = false,
                    HeavySwinging = false,
                    OnBack = false,
                }),
                Components.Buffs({
                    Acceleration = {SpeedBonus = 5, Time = 30, Start = true, Activated = false},
                }),
                Components.Debuffs({
                    Bleeding = {DamagePerTick = 2.5, Time = 10, Start = true},
                })
            )

            print("[Server]", "SpawnedEntity", Character.Name)
        end
    end

end

-- Return
return CharacterAdded