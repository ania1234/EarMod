require "behaviours/follow"
require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/panic"
require "behaviours/chattynode"
require "behaviours/doaction"
require "behaviours/keepcircle"
require "behaviours/chaseandattack"
require "behaviours/runaway"

local MIN_FOLLOW_DIST = 0
local MAX_FOLLOW_DIST = 9
local TARGET_FOLLOW_DIST = 6

local MAX_WANDER_DIST = 3
local START_RUN_DIST = 3
local STOP_RUN_DIST = 5
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 30

local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8


local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

local EarBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)


function EarBrain:OnStart()
	local clock = GetClock()
	local day = WhileNode( function() return clock and not clock:IsNight() end, "IsDay",
    PriorityNode{
		Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
		--ChattyNode(self.inst, STRINGS.EAR_TALK_NIGHT_CONVERSATION, Keepcircle(self.inst)),
		ChattyNode(self.inst, STRINGS.EAR_TALK_CASUAL_CONVERSATION, Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)),
    }, 0.5)
	local night = WhileNode( function() return clock and clock:IsNight() end, "IsNight",
    PriorityNode{
		Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
		ChattyNode(self.inst, STRINGS.EAR_TALK_NIGHT_CONVERSATION, Keepcircle(self.inst)),
    }, 1)
    local root = 
    PriorityNode({
		ChattyNode(self.inst, STRINGS.PIG_TALK_FIGHT,
                WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
                    ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST) )),
        ChattyNode(self.inst, STRINGS.PIG_TALK_FIGHT,
                WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
                    RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST) )),
        RunAway(self.inst, function(guy) return guy:HasTag("pig") and guy.components.combat and guy.components.combat.target == self.inst end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST ),
		day,
		night
    }, .5)
    self.bt = BT(self.inst, root)
end

return EarBrain