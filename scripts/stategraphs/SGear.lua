require("stategraphs/commonstates")
--[NEW] Stategraphs are used to present feedback to the player based on the state of the creature.  Here we setup two states,
--		one to handle when the creature is idle and one to handle when the creature is running.
local states=
{
	--[NEW] This handles the idle state.
    State{

        name = "idle",

        --[NEW] Tags are how we can classify states.  The 'canrotate' tag tells the animation system that these animations can
		--   	be flipped based on which way the creature is facing which means we don't have to create multiple animations.
        tags = {"idle", "canrotate"},

        --[NEW] Here is how we define what happens when we enter this state.
        onenter = function(inst, playanim)

        	--[NEW] In this case, all we want to do is play a looping version of the idle animation.
            inst.AnimState:PlayAnimation("idle", true)
        end,

    },

	--[NEW] This handles the running state.
    State{

        name = "run",

        --[NEW] Our running animation is also safe to be rotated.
        tags = {"run", "canrotate", "moving" },

        onenter = function(inst, playanim)

        	--[NEW] When entering this state, we now play a looping run animation.
            inst.AnimState:PlayAnimation("run", true)

    		--[NEW] Tell the locomotor that it's ok to start running.
    		inst.components.locomotor:RunForward()            
        end,
    }, 

	State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
        end,
    },
	
}

	CommonStates.AddSimpleState(states, "hit", "hit", {"busy"})

--[NEW] Event handlers are how stategraphs get told what happening with the prefab.  The stategraph then decides how it wants
--		to present that to the user which usually involves some combination of animation and audio.
local event_handlers=
{

	--[NEW] The locomotor sends events to the state graph called 'locomote'.  Here we setup how we're going to handle the event.
    EventHandler("locomote", 
        function(inst) 

        	--[NEW] First we check to see if the locomotor is trying to move our creature.
            if inst.components.locomotor:WantsToMoveForward() then

            	--[NEW] Next we check to see if we're not already in a moving state.
                if not inst.sg:HasStateTag("moving") then

                	--[NEW] If we've gotten here, we know we want to transition to the running state.
                    inst.sg:GoToState("run")
                end

           --[NEW] If we're not trying to move forward, then all we want to do is stand still.
            else

            	--[NEW] So if we're not already standing still.
                if not inst.sg:HasStateTag("idle") then
                	
                	--[NEW] Let's start standing still.
                    inst.sg:GoToState("idle")
                end
            end
        end),
	EventHandler("attacked", function(inst)
        if inst.components.health and not inst.components.health:IsDead() then
            inst.sg:GoToState("hit")
        end
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
}

--[NEW] Register our new stategraph and set the default state to 'idle'.
return StateGraph("SGEar", states, event_handlers, "idle", {})