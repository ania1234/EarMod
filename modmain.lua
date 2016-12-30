local player
local ring
local x, y, z

GLOBAL.STRINGS.NAMES.TELEPORTATO_RING = "Ear-Ring"

local function GetPosition(player)
	player = player
	x, y, z = player.Transform:GetWorldPosition()
	print("PLAYER")
	--initializing ring
	fetch_ring = GetModConfigData("fetch_ring")
	if fetch_ring and ring~=nil then
		ring.Transform:SetPosition(x, y, z)
		print("teleportato_ring moved to a player")
	end
end

local function InitializeRingProperties(prefab)
	ring = prefab
 
	--prefab.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	
end

AddSimPostInit(GetPosition)
AddPrefabPostInit("teleportato_ring", InitializeRingProperties);