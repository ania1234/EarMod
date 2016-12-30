local player
local x, y, z

local function GetPosition(player)
	player = player
	x, y, z = player.Transform:GetWorldPosition()
	print("PLAYER")
end

AddSimPostInit(GetPosition)