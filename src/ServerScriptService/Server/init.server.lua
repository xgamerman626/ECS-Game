-- @author xGamerman626

-- Services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Run = game:GetService("RunService")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)
local Components = require(ReplicatedStorage.Source.Config.Components)
local ProfileService = require(ServerStorage.Source.Util.Data)

local Stored_Data = require(ServerStorage.Source.Config.Stored_Data)
local Data_Structure = require(ServerStorage.Source.Config.Data_Structure)

-- Locals
local World = Matter.World.new()
local Loop = Matter.Loop.new(World)

local Player_Profile_Store = ProfileService.GetProfileStore(Data_Structure.ProfileStoreName, Data_Structure.Main)

-- Local Functions
local function DeepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = DeepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

local function MergeDataWithTemplate(data: table, template: table)
	for k, v in pairs(template) do
		if type(k) == "string" then -- Only string keys will be merged
			if data[k] == nil then
				if type(v) == "table" then
					data[k] = DeepCopy(v)
				else
					data[k] = v
				end
			elseif type(data[k]) == "table" and type(v) == "table" then
				MergeDataWithTemplate(data[k], v)
			end
		end
	end
end

local function Load_Player_Data(Player: Player, Slot)
	local Profile = Player_Profile_Store:LoadProfileAsync(tostring(Player.UserId..Slot), "ForceLoad")

	if Profile ~= nil then
		Profile:ListenToRelease(function()
			Stored_Data.Players[Player] = nil
			Player:Kick()
		end)

		if Player:IsDescendantOf(Players) then
			Stored_Data.Players[Player] = Profile
			Profile:Reconcile()
			Profile:AddUserId(Player.UserId)

			if Profile.Data.New == nil then
				Profile.Data.New = false
			end

			MergeDataWithTemplate(Profile.Data, Data_Structure)

			print(script.Name, "PlayerDataLoaded", Player.Name)
			Player:LoadCharacter()
		else
			Profile:Release()
		end
	else
		Player:Kick()
	end
end

local function Unload_Player_Data(Player: Player)
	local Profile = Stored_Data.Players[Player]
	if Profile ~= nil then
		print(script.Name, "PlayerDataSaved", Player.Name)
		Profile:Release()
	end
end

-- Schedule Systems
local Systems = {}

for _, v in pairs(ServerStorage.Source.Systems:GetChildren()) do
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

Players.PlayerAdded:Connect(function(Player)
    Load_Player_Data(Player, "Slot1")
end)

Players.PlayerRemoving:Connect(function(Player)
    Unload_Player_Data(Player)
end)