-- @author xGamerman626

-- Services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Tween = game:GetService("TweenService")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)
local Buffs = require(ReplicatedStorage.Source.Config.Buffs)

-- Locals
local Remotes_Folder = ReplicatedStorage.Source.Assets.Remotes
local Play_Buff_Remote = Remotes_Folder.Play_Buff
local Play_Debuff_Remote = Remotes_Folder.Play_Debuff

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Buffs_UI = PlayerGui:WaitForChild("UIBuffs")
local Buffs_Frame = Buffs_UI.Buffs
local Template = Buffs_UI.Template

-- Main
local function CreateBuff(Name: string, Time: number, Frame_Name: string)

    local Buff = Template:Clone()
    local Buff_Info = Buffs[Name]

    Buff.Name = Frame_Name
    Buff.Icon.Image = Buff_Info.Image
    Buff.TextLabel.Text = Buff_Info.Text
    Buff.TextLabel.TextColor3 = Buff_Info.TextColor

    Buff.Visible = true
    Buff.Parent = Buffs_Frame

    -- Visual Countdown
    local Counting = Tween:Create(Buff.Countdown, TweenInfo.new(Time), {Size = UDim2.new(0, 50, 0, 0)})
    local Connection
    Connection = Counting.Completed:Connect(function()
        Buff:Destroy()

        Connection:Disconnect()
        Connection = nil
    end)
    Counting:Play()

end

local function DebuffHandler(World)

    for _, Debuff_Name, Debuff_Time in Matter.useEvent(Play_Debuff_Remote, "OnClientEvent") do
        CreateBuff(Debuff_Name, Debuff_Time, "Debuff")
    end

    for _, Buff_Name, Buff_Time in Matter.useEvent(Play_Buff_Remote, "OnClientEvent") do
        CreateBuff(Buff_Name, Buff_Time, "Buff")
    end


end

-- Return
return DebuffHandler