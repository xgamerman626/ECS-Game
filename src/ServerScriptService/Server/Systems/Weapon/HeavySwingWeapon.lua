-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)
local Components = require(ReplicatedStorage.Source.Shared.Components)
local Stored_Data = require(ServerStorage.Source.Config.Stored_Data)

-- Locals
local Config_Folder = ReplicatedStorage.Source.Items.Config.Weapon
local Animations_Folder = ReplicatedStorage.Source.Assets.Animations

local Remotes_Folder = ReplicatedStorage.Source.Assets.Remotes
local Heavy_Swing_Weapon_Remote = Remotes_Folder.Heavy_Swing_Weapon

local Player = Components.Player
local Weapon = Components.Weapon

-- Main
local function PlaySwingAnimation(Player: Player, Weapon: table, World, ID)
    print(Weapon)

    local Anim_String = Weapon.WeaponTable.Type.."_Heavy_Swing"
    local Animation = Player.Character.Humanoid.Animator:LoadAnimation(Animations_Folder[Anim_String])
    
    local Connection
    Connection = Animation.Stopped:Connect(function()
        task.delay(require(Weapon.Config).HeavySwingCD, function()
            World:insert(ID, Weapon:patch({
                HeavySwinging = false
            }))
        end)

        Connection:Disconnect()
        Connection = nil
    end)
    
    Animation:Play()

end

local function HeavySwingWeapon(World)

    for _, Player_Instance in Matter.useEvent(Heavy_Swing_Weapon_Remote, "OnServerEvent") do

        for id, player, weapon in World:query(Player, Weapon) do

            -- Check if player has a weapon component if so check if it's equipped and not currently swinging
            if weapon.Equipped == true and weapon.Swinging == false and weapon.HeavySwinging == false then
                World:insert(id, weapon:patch({
                    HeavySwinging = true
                }))

                PlaySwingAnimation(player.Player, weapon, World, id)

                -- TODO: Hitbox stuff and damage.
            end

        end
        
    end

end

-- Return
return HeavySwingWeapon