-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)

-- Return
return {
    Player = Matter.component(),
    Character = Matter.component(),
    Enemy = Matter.component(),

    Model = Matter.component(),
    Transform = Matter.component(),

    Health = Matter.component(),
    Poisoned = Matter.component(),

    Weapon = Matter.component(),
    Hitbox = Matter.component(),
}