PrefabFiles = {
	"ear",
}

local player
local ring
local x, y, z

local ears

GLOBAL.STRINGS.NAMES.TELEPORTATO_RING = "Ear-Ring"
GLOBAL.STRINGS.NAMES.EAR = "Ear"
GLOBAL.STRINGS.EAR_TALK_CASUAL_CONVERSATION = {"Hi!", "Do you believe \n in life after love?", "The weather is nice", "I disagree", "How about a quick workout?", "Would you like a lunch?", "I once fucked my uncle", "Have you seen his shoes?", "No Way!", "SERIOUSLY??!!??", "I would never do that!", "I'm not sure about this topic", "Her career is in the gutter", "How are you?", "Desperate times call for desperate measures", "I try to keep\n a healthy lifestyle", "Hi Mom!", "How is Maggie doing?", "That does not go\n with this dress", "Perfect topic for\n a gardenparty conversation", "Never!", "Maybe, maybe...", "...and a bit of garlic olive oil..", "Were the effects visible?", "You can fight poverty\n with private investment", "Comrade!", "Is Tom on vacation?", "Vegan and gluten free", "Is there any dessert left?", "Yes", "No", "How are you holding up, my dear?", "Oh my...", "Can I help you?", "How was your day off?", "Can you imagine that?", "That is kind of offensive.", "I guess you can call me conservative", "I made love.", "That was\n a terrible mistake.", "Would you like it?", "Awesome!", "Pardon?", "Disembodied and left in the canals", "Yeah, but was the carrot used?", "I would rather not", "Maybe tomorrow","I would love to try!", "The rumor is he got a promotion", "He seems interesting enough", "Two at the price of one", "I like to watch you cry", "Tell me where\n did you sleep last night?", "I'm telling you,\n it is the best!", "Her new research\n is highly acclaimed", "She self-published", "Was it any good?"}



local function GetPlayer(prefab)
	player = prefab
	x, y, z = prefab.Transform:GetWorldPosition()
	print("PLAYER")
	fetch_ring = GetModConfigData("fetch_ring")
	if fetch_ring and ring~=nil then
		ring.Transform:SetPosition(x, y, z)
		print("teleportato_ring moved to a player")
	end
	--for i=0, #ears do
    --  ears[i].components.follower.leader = ring
	--  print(ears[i].components.follower.leader)
    --end
end

local function OnRingSave(inst, data)
	print("Ring - OnSave") 
    data.Used = inst.Used
end

local function OnRingLoadPostPass(inst, newents, data)
    print("Ring - OnLoadPostPass")
	if data~=nil and data.Used ~= nil then
		inst.Used = data.Used
	else
		inst.Used = false
	end
end

local function OnRingPutInInventory(prefab)
	print("OnRingPutInInventory")
	print(prefab.Used)
	if not prefab.Used then
		prefab.Used = true
		for i = 0,359,60
		do
			local creature = GLOBAL.SpawnPrefab("ear")
			print(creature)
			if creature~=nil then
				if player~=nil then
					print("spawning creature")
					x, y, z = player.Transform:GetWorldPosition()
					creature.Transform:SetPosition(x+5*math.sin(math.rad(i)), y, z+10*math.cos(math.rad(i)))	
					creature.components.follower.leader = prefab
					creature.Angle = i
				end
			end
		end
	end
end

local function InitializeRingProperties(prefab)
    prefab.OnSave = OnRingSave
    prefab.OnLoadPostPass = OnRingLoadPostPass
	ring = prefab
	prefab.components.inventoryitem:SetOnPutInInventoryFn(OnRingPutInInventory)
end

--local function OnEarLoadPostPass(inst, newents, data)
--	if inst.components.follower.leader == nil then
--		inst.components.follower.leader = ring
--		print(inst.components.follower.leader)
--	end
--end
local function OnEarPostInit(inst)
--	inst.OnLoadPostPass = OnEarLoadPostPass
	print(#ears)
	ears[#ears+1] = inst
end

AddSimPostInit(GetPlayer)
AddPrefabPostInit("teleportato_ring", InitializeRingProperties);
AddPrefabPostInit("ear", OnEarPostInit)