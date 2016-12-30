PrefabFiles = {
	"ear",
}

local player
local ring
local x, y, z

GLOBAL.STRINGS.NAMES.TELEPORTATO_RING = "Ear-Ring"

local function GetPlayer(prefab)
	player = prefab
	x, y, z = prefab.Transform:GetWorldPosition()
	print("PLAYER")
	fetch_ring = GetModConfigData("fetch_ring")
	if fetch_ring and ring~=nil then
		ring.Transform:SetPosition(x, y, z)
		print("teleportato_ring moved to a player")
	end
end

local function OnPutInInventory(prefab)
	print("OnPutInInventory")
	local creature = GLOBAL.SpawnPrefab("ear")
	print(creature)
	if creature~=nil then
		if player~=nil then
			print("spawning creature")
			x, y, z = player.Transform:GetWorldPosition()
			creature.Transform:SetPosition(x, y, z)	
			creature.components.follower.leader = prefab
		end
	end
end

local function InitializeRingProperties(prefab)
	ring = prefab
	prefab.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
end

AddSimPostInit(GetPlayer)
AddPrefabPostInit("teleportato_ring", InitializeRingProperties);