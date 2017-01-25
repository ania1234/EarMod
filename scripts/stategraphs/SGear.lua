require("stategraphs/commonstates")
--[NEW] Stategraphs are used to present feedback to the player based on the state of the creature.  Here we setup two states,
--		one to handle when the creature is idle and one to handle when the creature is running.
local states=
{
	State{
        name = "death",
        tags = {"busy", "canrotate"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst) 
			inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition())) 	
			print("deathfin")
        end,
    },
	
	State{
        name = "attack",
        tags = {"attack", "busy", "canrotate"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("attack")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.components.combat:DoAttack() inst.sg:RemoveStateTag("attack") inst.sg:RemoveStateTag("busy")
			inst.components.combat:StartAttack()
			inst.sg:GoToState("idle") end),
        },
    },
	
}

	CommonStates.AddSimpleState(states, "hit", "attack", {"busy"})

	CommonStates.AddWalkStates(states,
	{
		walktimeline = {
			TimeEvent(0*FRAMES, PlayFootstep ),
			TimeEvent(12*FRAMES, PlayFootstep ),
	},
	})
	CommonStates.AddRunStates(states,
	{
		runtimeline = {
			TimeEvent(0*FRAMES, PlayFootstep ),
			TimeEvent(10*FRAMES, PlayFootstep ),
		},
	})
	CommonStates.AddIdle(states)
	
--[NEW] Event handlers are how stategraphs get told what happening with the prefab.  The stategraph then decides how it wants
--		to present that to the user which usually involves some combination of animation and audio.
local event_handlers=
{
	CommonHandlers.OnLocomote(true,true),
	CommonHandlers.OnDeath(),
	EventHandler("doattack", function(inst) inst.sg:GoToState("attack") end),
}

--[NEW] Register our new stategraph and set the default state to 'idle'.
return StateGraph("SGEar", states, event_handlers, "idle", {})