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

local function ShouldKeepTarget(inst, target)
    return true
end

local function OnSave(inst, data)
	print("ear - OnSave") 
    data.Angle = inst.Angle
end

local function OnPreLoad(inst, data)
	print("ear - OnPreLoad") 
    if not data then return end
	inst.Angle = data.Angle 
end

--[NEW] This function creates a new entity based on a prefab.
local function init_prefab()

	--[NEW] First we create an entity.
	local inst = CreateEntity()

	    
    inst:AddTag("companion")
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

    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize( 2, 1.5 )
	
    MakeCharacterPhysics(inst, 10, .5)
	    --print("   Collision")
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	
	inst.Transform:SetTwoFaced()

	--print("   combat")
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "chester_body"
    inst.components.combat:SetKeepTargetFunction(ShouldKeepTarget)
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


    --print("   sg")
    inst:SetStateGraph("SGear")
    inst.sg:GoToState("idle")

    --print("   brain")
    inst:SetBrain(brain)

    inst.OnSave = OnSave
    inst.OnPreLoad = OnPreLoad

    return inst
end

--[NEW] Here we register our new prefab so that it can be used in game.
return Prefab( "ear", init_prefab, assets, nil)
