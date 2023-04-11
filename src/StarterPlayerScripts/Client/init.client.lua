-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Run = game:GetService("RunService")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)
local Components = require(ReplicatedStorage.Source.Config.Components)

-- Locals
local Loop = Matter.Loop.new(Matter.World)

-- Schedule Systems
local Systems = {}

for _, v in pairs(ReplicatedStorage.Source.Systems:GetChildren()) do
    for _, Child in pairs(v:GetChildren()) do

        if Child:IsA("ModuleScript") then
            table.insert(Systems, require(Child))
        end

    end
end

Loop:scheduleSystems(Systems)

Loop:begin({
    default = Run.Heartbeat,
})