local assets = {
    
}


local function fn()
    local inst = CreateEntity()
	inst.entity:AddTransform()
	
	inst:AddComponent("prefabholder")
	
	GUIDsHelper=inst
    return inst
end

return Prefab("guiddummy", fn, assets)