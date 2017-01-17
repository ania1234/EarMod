local PrefabHolder = Class(function(self, inst)
    self.inst = inst
    self.followers = {}
end)

function PrefabHolder:RemoveFollower(follower)
    if follower and self.followers[follower] then
        self.followers[follower] = nil
    end
end

function PrefabHolder:AddFollower(follower)
    if self.followers[follower] == nil and follower.components.follower then
        self.followers[follower] = true
        follower:ListenForEvent("death", function(inst, data) self:RemoveFollower(follower) end, self.inst)
	end
end

function PrefabHolder:OnSave()
    local saved = false
    local followers = {}
    for k,v in pairs(self.followers) do
        saved = true
        table.insert(followers, k.GUID)
    end
    
    if saved then
        return {followers = followers}, followers
    end
    
end

function PrefabHolder:LoadPostPass(newents, savedata)
    if savedata and savedata.followers then
        for k,v in pairs(savedata.followers) do
			print(k)
			print(v)
            local targ = newents[v]
            if targ and targ.entity.components.follower then
                self:AddFollower(targ.entity)
            end
        end
    end
end

return PrefabHolder
