-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requires
local Start = require(ReplicatedStorage.Source.Shared.Start)
local ReceiveReplication = require(ReplicatedStorage.Source.Client.ReceiveReplication)

-- Locas
local World, State = Start({
	ReplicatedStorage.Source.Shared.Systems,
	ReplicatedStorage.Source.Client.Systems,
})

-- Main
ReceiveReplication(World, State)