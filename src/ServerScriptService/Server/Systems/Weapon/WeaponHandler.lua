-- @author xGamerman626

-- Services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)
local Components = require(ReplicatedStorage.Source.Shared.Components)
local Stored_Data = require(ServerStorage.Source.Config.Stored_Data)
local Items = require(ReplicatedStorage.Source.Config.Items)

-- Locals
local Weapon_Config_Folder = ReplicatedStorage.Source.Items.Config.Weapon
local Animations_Folder = ReplicatedStorage.Source.Assets.Animations
local Remotes_Folder = ReplicatedStorage.Source.Assets.Remotes
local Equip_Weapon_Remote = Remotes_Folder.Equip_Weapon
local Play_Animation_Remote = Remotes_Folder.Play_Animation
local Stop_Animation_Remote = Remotes_Folder.Stop_Animation

local Player = Components.Player
local Weapon = Components.Weapon

-- Main
local function PutWeaponOnBack(Player: Player, Parent: Model, Weapon: table)

    -- Delete Previous Weapon
    if Parent:FindFirstChild("Weapon") then
        Parent.Weapon:Destroy()
    end
    if Parent:FindFirstChild("Weapon2") then
        Parent.Weapon2:Destroy()
    end

    -- Locals
    local Weapon_Model = ReplicatedStorage.Source.Items.Models.Weapon[Weapon.WeaponTable.Type][Weapon.WeaponTable.Name]:Clone()
    local Weapon_Config = require(ReplicatedStorage.Source.Items.Config.Weapon[Weapon.WeaponTable.Type][Weapon.WeaponTable.Name])

    local Torso_Weld = Parent.Torso.Sheathe1

    -- Main
    if Weapon.WeaponTable.Type == "Dagger" then

        -- Locals
        local Weapon_Model2 = Weapon_Model:Clone()
        local Torso_Weld2 = Parent.Torso.Sheathe2
        
        -- Main
        Weapon_Model2.BodyAttachMain.Name = "BodyAttachSide"
        Torso_Weld.C0 = Weapon_Config[1].C0
        Torso_Weld.C1 = Weapon_Config[1].C1
        Torso_Weld.Part1 = Weapon_Model.BodyAttachMain

        Torso_Weld2.C0 = Weapon_Config[2].C0
        Torso_Weld2.C1 = Weapon_Config[2].C1
        Torso_Weld2.Part1 = Weapon_Model2.BodyAttachSide
    
        Weapon_Model.Name = "Weapon"
        Weapon_Model2.Name = "Weapon2"
        Weapon_Model.Parent = Parent
        Weapon_Model2.Parent = Parent

    else

        -- Main
        Torso_Weld.C0 = Weapon_Config.C0
        Torso_Weld.C1 = Weapon_Config.C1
        Torso_Weld.Part1 = Weapon_Model.BodyAttachMain
    
        Weapon_Model.Name = "Weapon"
        Weapon_Model.Parent = Parent

    end

    -- Stop Idle Anim
    Stop_Animation_Remote:FireClient(Player, Weapon.WeaponTable.Type.."_Idle")

end

local function PutWeaponInHands(Player: Player, Parent: Model, Weapon: table)

    -- Locals
    local Weapon_Model = Parent:FindFirstChild("Weapon")
    local Weapon_Model2 = Parent:FindFirstChild("Weapon2")

    -- Main
    if Weapon_Model and Weapon_Model2 then
        Parent.Torso.Sheathe1.Part1 = nil
        Parent.Torso.Sheathe2.Part1 = nil

        Parent["Right Arm"].BodyAttachMain.Part1 = Weapon_Model.BodyAttachMain
        Parent["Left Arm"].BodyAttachSide.Part1 = Weapon_Model2.BodyAttachSide
    elseif Weapon_Model then
        Parent.Torso.Sheathe1.Part1 = nil
        Parent["Right Arm"].BodyAttachMain.Part1 = Weapon_Model.BodyAttachMain
    end

    -- Play Idle Anim
    Play_Animation_Remote:FireClient(Player, Weapon.WeaponTable.Type.."_Idle")

end

local function DeleteWeaponModel(Parent: Model)
    local Weapon_Model = Parent:FindFirstChild("Weapon")
    local Weapon_Model2 = Parent:FindFirstChild("Weapon2")

    if Weapon_Model then Weapon_Model:Destroy() end
    if Weapon_Model2 then Weapon_Model2:Destroy() end
end

local function WeaponHandler(World)

    for id, player, weapon in World:query(Player, Weapon) do

        local PreviousWeaponTable = weapon.WeaponTable
        local Player_Data

        -- Checks if their data exists
        if Stored_Data.Players[player.Player] ~= nil then
            Player_Data = Stored_Data.Players[player.Player].Data
        else
            return
        end

        -- Change WeaponTable incase they equipped a new weapon
        World:insert(id, weapon:patch({
            WeaponTable = Items[Player_Data.Inventory.Equipped.Weapon]
        }))

        -- Change Config incase they equipped a new weapon
        if weapon.WeaponTable ~= nil then
            World:insert(id, weapon:patch({
                Config = Weapon_Config_Folder[weapon.WeaponTable.Type][weapon.WeaponTable.Name]
            }))
        end

        -- WeaponTable was changed meaning a new weapon was equipped so delete previous model and stop idle anim.
        if PreviousWeaponTable ~= weapon.WeaponTable then
            DeleteWeaponModel(player.Model)
        end

        -- Model Handling
        if weapon.Equipped == false and weapon.OnBack == false then
            -- If Weapon doesn't exist then dont do this
            if weapon.WeaponTable == nil then
                return
            end

            -- Update Debounce
            World:insert(id, weapon:patch({
                OnBack = true
            }))

            -- Call Function
            PutWeaponOnBack(player.Player, player.Model, weapon)
        elseif weapon.Equipped == true and weapon.OnBack == true then
            -- If Weapon doesn't exist then dont do this
            if weapon.WeaponTable == nil then
                return
            end

            -- Update Debounce
            World:insert(id, weapon:patch({
                OnBack = false
            }))

            -- Call Function
            PutWeaponInHands(player.Player, player.Model, weapon)
        end

    end

end

-- Return
return WeaponHandler