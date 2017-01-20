require "prefabutil"
local brain = require "brains/earbrain"
require "stategraphs/SGear"

--[NEW] Here we list any assets required by our prefab.
local assets=
{
	--[NEW] this is the name of the Spriter file.
	Asset("ANIM", "anim/ear.zip"),
}

local Angle=0

local function OnStopFollowing(inst) 
    print("ear - OnStopFollowing")
    inst:RemoveTag("companion") 
end

local function OnStartFollowing(inst) 
    print("ear - OnStartFollowing")
    inst:AddTag("companion") 
end

local function NormalRetargetFn(inst)
    return FindEntity(inst, TUNING.PIG_TARGET_DIST,
        function(guy)
            if not guy.LightWatcher or guy.LightWatcher:IsInLight() then
                return guy:HasTag("monster") and guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy) and not 
                (inst.components.follower.leader ~= nil and guy:HasTag("abigail"))
            end
        end)
end
local function NormalKeepTargetFn(inst, target)
    --give up on dead guys, or guys in the dark, or werepigs
    return inst.components.combat:CanTarget(target)
           and (not target.LightWatcher or target.LightWatcher:IsInLight())
           and not (target.sg and target.sg:HasStateTag("transform") )
end

local function OnSave(inst, data)
	print("ear - OnSave") 
    data.Angle = inst.Angle
end


local function OnLoad(inst, data)
	print("ear - OnLoad") 
    if not data then return end
	inst.Angle = data.Angle 
end

--[NEW] This function creates a new entity based on a prefab.
local function init_prefab()

	--[NEW] First we create an entity.
	local inst = CreateEntity()
  
    inst:AddTag("character")
    inst:AddTag("scarytoprey")
    inst:AddTag("notraptrigger")
    inst:AddTag("cattoy")
	
	--[NEW] Then we add a transform component se we can place this entity in the world.
	local trans = inst.entity:AddTransform()

	--[NEW] Then we add an animation component which allows us to animate our entity.
	local anim = inst.entity:AddAnimState()
	
    anim:SetBank("ear")
    anim:SetBuild("ear")

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.5, .75 )
	
    MakeCharacterPhysics(inst, 10, .5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	
	inst.Transform:SetTwoFaced()

	--print("   combat")
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "ear_middle"
    inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
    --inst:ListenForEvent("attacked", OnAttacked)
	
    --print("   health")
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.SPIDER_HEALTH)
    inst:AddTag("noauradamage")
	
    --print("   locomotor")
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 3
    inst.components.locomotor.runspeed = 7
	
	--print("   knownlocations")
    inst:AddComponent("knownlocations")
	
	--print("   follower")
    inst:AddComponent("follower")
    inst:ListenForEvent("stopfollowing", OnStopFollowing)
    inst:ListenForEvent("startfollowing", OnStartFollowing)

	--print("	inspectable")
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = function(inst)
			return "EAR"
    end
	inst.components.inspectable:SetDescription("It's just a normal ear!");
	
	--print("	lootdropper")
	inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({})
    inst.components.lootdropper:AddRandomLoot("meat",1)
    inst.components.lootdropper:AddRandomLoot("pigskin",1)
    inst.components.lootdropper.numrandomloot = 1
	
	--print("	talker")
	inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0,-700,0)
	
    --print("   sg")
    inst:SetStateGraph("SGear")
    inst.sg:GoToState("idle")

    --print("   brain")
    inst:SetBrain(brain)

	 inst.OnSave = OnSave
	inst.OnLoad = OnLoad

    return inst
end

--[NEW] Here we register our new prefab so that it can be used in game.
return Prefab( "ear", init_prefab, assets, nil)
