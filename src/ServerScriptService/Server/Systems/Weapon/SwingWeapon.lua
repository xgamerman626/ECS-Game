-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)
local Components = require(ReplicatedStorage.Source.Shared.Components)
local Stored_Data = require(ServerStorage.Source.Config.Stored_Data)

-- Locals
local Animations_Folder = ReplicatedStorage.Source.Assets.Animations

local Remotes_Folder = ReplicatedStorage.Source.Assets.Remotes
local Swing_Weapon_Remote = Remotes_Folder.Swing_Weapon
local Character_Died_Bindable = Remotes_Folder.Character_Died_S

local Player = Components.Player
local Weapon = Components.Weapon

-- Main
local function AddPlayerToComboTable(Player: Player)
    if Stored_Data.Player_Combos[Player] == nil then
        Stored_Data.Player_Combos[Player] = 1
    end
end

local function ResetPlayerCombo(Player: Player)
    Stored_Data.Player_Combos[Player] = 1
end

local function GetPlayerCombo(Player: Player)
    return Stored_Data.Player_Combos[Player]
end

local function IncrementPlayerCombo(Player: Player, Weapon: table)
    Stored_Data.Player_Combos[Player] += 1

    if GetPlayerCombo(Player) > require(ReplicatedStorage.Source.Items.Config.Weapon[Weapon.WeaponTable.Type][Weapon.WeaponTable.Name]).MaxCombo then
        ResetPlayerCombo(Player)
    end
    
end

local function TrailStuff(Character: Model, Weapon: table, Bool)

    if Weapon.WeaponTable.WeaponRange == "Melee" then
        local Weapon_Model = Character:FindFirstChild("Weapon")

        if Weapon_Model then
            Weapon_Model.BodyAttachMain.Trail.Enabled = Bool
        end
    end

end

local function PlaySwingAnimation(Player: Player, Weapon: table, World, ID)

    local Anim_String = Weapon.WeaponTable.Type.."_Swing_"..GetPlayerCombo(Player)
    local Animation = Player.Character.Humanoid.Animator:LoadAnimation(Animations_Folder[Anim_String])

    task.delay(0.2, function()
        TrailStuff(Player.Character, Weapon, true)
    end)

    local Connection
    Connection = Animation.Stopped:Connect(function()
        if GetPlayerCombo(Player) == require(Weapon.Config).MaxCombo then
            task.delay(0.5, function()
                World:insert(ID, Weapon:patch({
                    Swinging = false
                }))
            end)
        else
            World:insert(ID, Weapon:patch({
                Swinging = false
            }))
        end

        TrailStuff(Player.Character, Weapon, false)

        Connection:Disconnect()
        Connection = nil
    end)
    
    Animation:Play()

end

local function SwingWeapon(World)

    for _, Player_Instance in Matter.useEvent(Swing_Weapon_Remote, "OnServerEvent") do

        for id, player, weapon in World:query(Player, Weapon) do

            -- Check if player has a weapon component if so check if it's equipped and not currently swinging
            if weapon.Equipped == true and weapon.Swinging == false and weapon.HeavySwinging == false then
                World:insert(id, weapon:patch({
                    Swinging = true
                }))

                AddPlayerToComboTable(player.Player)
                PlaySwingAnimation(player.Player, weapon, World, id)
                IncrementPlayerCombo(player.Player, weapon)

                -- TODO: Hitbox stuff and damage.
                -- TODO: Trails and sound effects.

            end

        end
        
    end

end

-- Return
return SwingWeapon