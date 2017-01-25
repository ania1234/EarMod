PrefabFiles = {
	"ear",
	"guiddummy"
}

local player
local ring
local x, y, z

GLOBAL.STRINGS.NAMES.TELEPORTATO_RING = "Ear-Ring"
GLOBAL.STRINGS.NAMES.EAR = "Ear"
GLOBAL.STRINGS.EAR_TALK_CASUAL_CONVERSATION = {"Hi!", "Do you believe \n in life after love?", "The weather is nice", "I disagree", "How about a quick workout?", "Would you like a lunch?", "I once fucked my uncle", "Have you seen his shoes?", "No Way!", "SERIOUSLY??!!??", "I would never do that!", "I'm not sure about this topic", "Her career is in the gutter", "How are you?", "Desperate times call for desperate measures", "I try to keep\n a healthy lifestyle", "Hi Mom!", "How is Maggie doing?", "That does not go\n with this dress", "Perfect topic for\n a gardenparty conversation", "Never!", "Maybe, maybe...", "...and a bit of garlic olive oil..", "Were the effects visible?", "You can fight poverty\n with private investment", "Comrade!", "Is Tom on vacation?", "Vegan and gluten free", "Is there any dessert left?", "Yes", "No", "How are you holding up, my dear?", "Oh my...", "Can I help you?", "How was your day off?", "Can you imagine that?", "That is kind of offensive.", "I guess you can call me conservative", "I made love.", "That was\n a terrible mistake.", "Would you like it?", "Awesome!", "Pardon?", "Disembodied and left in the canals", "Yeah, but was the carrot used?", "I would rather not", "Maybe tomorrow","I would love to try!", "The rumor is he got a promotion", "He seems interesting enough", "Two at the price of one", "I like to watch you cry", "Tell me where\n did you sleep last night?", "I'm telling you,\n it is the best!", "Her new research\n is highly acclaimed", "She self-published", "Was it any good?"}
GLOBAL.STRINGS.EAR_TALK_NIGHT_CONVERSATION = {
"Have mercy on me, sir", 
"Allow me to impose on you", 
"I have no place to stay", 
"And my bones are cold right through", 
"I will tell you a story", 
"Of a man and his family", 
"And I swear that it is true", 
"Ten years ago I met a girl named Joy", 
"She was a sweet and happy thing", 
"Her eyes were bright blue jewels", 
"And we were married in the spring", 
"I had no idea what happiness and little love could bring", 
"Or what life had in store", 
"But all things move toward their end", 
"All things move toward their their end", 
"On that you can be sure", 
"La la la la la la la la la la", 
"La la la la la la la la la la", 
"Then one morning I awoke to find her weeping", 
"And for many days to follow", 
"She grew so sad and lonely", 
"Became Joy in name only", 
"Within her breast there launched an unnamed sorrow", 
"And a dark and grim force set sail", 
"Farewell happy fields", 
"Where joy forever dwells", 
"* Hail horrors hail *", 
"Was it an act of contrition\n or some awful premonition", 
"As if she saw into the heart\n of her final blood-soaked night", 
"Those lunatic eyes, that hungry kitchen knife", 
"Ah, I see sir, that I have your attention!", 
"Well, could it be?", 
"How often I've asked that question", 
"Well, then in quick succession", 
"We had babies, one, two, three", 
"We called them Hilda, Hattie and Holly", 
"They were their mother's children", 
"Their eyes were bright blue jewels", 
"And they were quiet as a mouse", 
"There was no laughter in the house", 
"No, not from Hilda, Hattie or Holly", 
"No wonder", 
"people said", 
"poor mother Joy's so melancholy", 
"Well, one night there came a visitor to our little home", 
"I was visiting a sick friend", 
"I was a doctor then", 
"Joy and the girls were on their own", 
"La la la la la la la la la la", 
"La la la la la la la la la la", 
"Joy had been bound with electrical tape", 
"In her mouth a gag", 
"She'd been stabbed repeatedly", 
"And stuffed into a sleeping bag", 
"In their very cots my girls were robbed of their lives", 
"Method of murder much the same as my wife's", 
"Method of murder much the same as my wife's", 
"It was midnight when I arrived home", 
"Said to the police on the telephone", 
"Someone's taken four innocent lives", 
"They never caught the man", 
"He's still on the loose", 
"It seems he has done many many more", 
"Quotes John Milton on the walls in the victim's blood", 
"The police are investigating at tremendous cost", 
"In my house he wrote 'his red right hand'", 
"That, I'm told is from Paradise Lost", 
"The wind round here gets wicked cold", 
"But my story is nearly told", 
"I fear the morning will bring quite a frost", 
"And so I've left my home", 
"I drift from land to land", 
"I am upon your step and you are a family man", 
"Outside the vultures wheel", 
"The wolves howl, the serpents hiss", 
"And to extend this small favour, friend", 
"Would be the sum of earthly bliss", 
"Do you reckon me a friend?", 
"The sun to me is dark", 
"And silent as the moon", 
"Do you, sir, have a room?", 
"Are you beckoning me in?", 
"La la la la la la la la la la"
}
GLOBAL.GUIDsHelper=nil



local function GetPlayer(prefab)
	player = prefab
	x, y, z = prefab.Transform:GetWorldPosition()
	print("PLAYER")
	fetch_ring = GetModConfigData("fetch_ring")
	if fetch_ring and ring~=nil and not ring.inlimbo then
		ring.Transform:SetPosition(x, y, z)
		print("teleportato_ring moved to a player")
	end
	if not GLOBAL.GUIDsHelper then
		GLOBAL.GUIDsHelper=GLOBAL.SpawnPrefab("guiddummy")
		print(GLOBAL.GUIDsHelper)
	end
	if ring and GLOBAL.GUIDsHelper then
		for k, v in pairs(GLOBAL.GUIDsHelper.components.prefabholder.followers) do
			ring.components.leader:AddFollower(k)
		end
	end
end


local function OnRingSave(inst, data)
	print(OnRingSave)
    data.Used = inst.Used
	return inst.components.leader:OnSave()
end

local function OnRingLoad(inst, data)
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
					print("spawning creature because of pick up")
					x, y, z = player.Transform:GetWorldPosition()
					creature.Transform:SetPosition(x+6*math.sin(math.rad(i)), y, z+6*math.cos(math.rad(i)))	
					creature.Angle = i
					prefab.components.leader:AddFollower(creature)
					print(creature.components.follower.leader)
					GLOBAL.GUIDsHelper.components.prefabholder:AddFollower(creature)
				end
			end
		end
	end
end

local function InitializeRingProperties(prefab)
    prefab.OnSave = OnRingSave
	prefab.OnLoad = OnRingLoad
	prefab:AddComponent("leader")
	ring = prefab
	prefab.ears = {}
	prefab.components.inventoryitem:SetOnPutInInventoryFn(OnRingPutInInventory)
end

AddSimPostInit(GetPlayer)
AddPrefabPostInit("teleportato_ring", InitializeRingProperties);