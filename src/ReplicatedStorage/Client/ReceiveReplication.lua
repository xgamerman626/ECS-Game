-- @author xGamerman626

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requires
local Components = require(ReplicatedStorage.Source.Shared.Components)

-- Locals
local RemoteEvent = ReplicatedStorage.Source.Assets.Remotes:WaitForChild("Matter")

local function SetupReplication(World, State)
	local function debugPrint(...)
		if State.debugEnabled then
			print("Replication>", ...)
		end
	end

	local entityIdMap = {}

	RemoteEvent.OnClientEvent:Connect(function(entities)
		for serverEntityId, componentMap in entities do
			local clientEntityId = entityIdMap[serverEntityId]

			if clientEntityId and next(componentMap) == nil then
				World:despawn(clientEntityId)
				entityIdMap[serverEntityId] = nil
				debugPrint(string.format("Despawn %ds%d", clientEntityId, serverEntityId))
				continue
			end

			local componentsToInsert = {}
			local componentsToRemove = {}

			local insertNames = {}
			local removeNames = {}

			for name, container in componentMap do
				if container.data then
					table.insert(componentsToInsert, Components[name](container.data))
					table.insert(insertNames, name)
				else
					table.insert(componentsToRemove, Components[name])
					table.insert(removeNames, name)
				end
			end

			if clientEntityId == nil then
				clientEntityId = world:spawn(unpack(componentsToInsert))

				entityIdMap[serverEntityId] = clientEntityId

				debugPrint(
					string.format("Spawn %ds%d with %s", clientEntityId, serverEntityId, table.concat(insertNames, ","))
				)
			else
				if #componentsToInsert > 0 then
					World:insert(clientEntityId, unpack(componentsToInsert))
				end

				if #componentsToRemove > 0 then
					World:remove(clientEntityId, unpack(componentsToRemove))
				end

				debugPrint(
					string.format(
						"Modify %ds%d adding %s, removing %s",
						clientEntityId,
						serverEntityId,
						if #insertNames > 0 then table.concat(insertNames, ", ") else "nothing",
						if #removeNames > 0 then table.concat(removeNames, ", ") else "nothing"
					)
				)
			end
		end
	end)
end

return SetupReplication