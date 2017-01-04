require "behaviours/follow"
require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/panic"
require "behaviours/chattynode"


local MIN_FOLLOW_DIST = 0
local MAX_FOLLOW_DIST = 7
local TARGET_FOLLOW_DIST = 6

local MAX_WANDER_DIST = 3


local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

local function FindFoodAction(inst)
	return nil
end

local EarBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function SetAngle(inst)
	inst.components.locomotor:GoToPoint(inst.components.follower.leader:GetPosition())
end

function EarBrain:OnStart()
    local root = 
    PriorityNode({
		--SetAngle(self.inst),
		Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
		ChattyNode(self.inst, STRINGS.EAR_TALK_CASUAL_CONVERSATION, Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)),
    }, .25)
    self.bt = BT(self.inst, root)
end

return EarBrain