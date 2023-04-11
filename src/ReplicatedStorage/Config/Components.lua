-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)

-- Return
return {
    Player = Matter.component(),
    Model = Matter.component(),
    Name = Matter.component(),
    Enemy = Matter.component(),
    Health = Matter.component(),
    Poisoned = Matter.component(),
}