-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requires
local Components = require(ReplicatedStorage.Source.Shared.Components)

-- Locals
local Remotes_Folder = ReplicatedStorage.Source.Assets.Remotes
local Character_Died_Bindable = Remotes_Folder.Character_Died_S
local Character_Died_Remote = Remotes_Folder.Character_Died

local Player = Components.Player
local Health = Components.Health

-- Main
local function CharacterDeath(World)

    for id, health, player in World:query(Health, Player) do

        if health.Current <= 0 then
            Character_Died_Bindable:Fire(player.Player)
            Character_Died_Remote:FireClient(player.Player)
            World:despawn(id)
            player.Player:LoadCharacter()
            print("[Server]", "CharacterDied", player.Player.Name)
        end

    end

end

-- Return
return CharacterDeath