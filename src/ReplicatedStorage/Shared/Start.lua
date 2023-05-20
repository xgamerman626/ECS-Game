-- @author xGamerman626

-- Services
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requires
local Matter = require(ReplicatedStorage.Packages.matter)
local Plasma = require(ReplicatedStorage.Packages.plasma)
local HotReloader = require(ReplicatedStorage.Packages.rewire).HotReloader
local Components = require(script.Parent.Components)

local function Start(Containers)
	local World = Matter.World.new()
	local State = {}

	local Debugger = Matter.Debugger.new(Plasma)

	Debugger.findInstanceFromEntity = function(id)
		if not World:contains(id) then
			return
		end

		local Model = World:get(id, Components.Model)

		return Model and Model.Model or nil
	end

	local Loop = Matter.Loop.new(World, State, Debugger:getWidgets())

	-- Set up hot reloading

	local hotReloader = HotReloader.new()

	local firstRunSystems = {}
	local systemsByModule = {}

	local function loadModule(module, context)
		local originalModule = context.originalModule

		local ok, system = pcall(require, module)

		if not ok then
			warn("Error when hot-reloading system", module.name, system)
			return
		end

		if firstRunSystems then
			table.insert(firstRunSystems, system)
		elseif systemsByModule[originalModule] then
			Loop:replaceSystem(systemsByModule[originalModule], system)
			Debugger:replaceSystem(systemsByModule[originalModule], system)
		else
			Loop:scheduleSystem(system)
		end

		systemsByModule[originalModule] = system
	end

	local function unloadModule(_, context)
		if context.isReloading then
			return
		end

		local originalModule = context.originalModule
		if systemsByModule[originalModule] then
			Loop:evictSystem(systemsByModule[originalModule])
			systemsByModule[originalModule] = nil
		end
	end

	for _, Container in Containers do
		hotReloader:scan(Container, loadModule, unloadModule)
	end

	Loop:scheduleSystems(firstRunSystems)
	firstRunSystems = nil

	Debugger:autoInitialize(Loop)

	-- Begin running our systems

	Loop:begin({
		default = RunService.Heartbeat,
	})

	if RunService:IsClient() then
		UserInputService.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.F4 then
				Debugger:toggle()

				State.debugEnabled = Debugger.enabled
			end
		end)
	end

	return World, State
end

return Start