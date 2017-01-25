Keepcircle = Class(BehaviourNode, function(self, inst)
    BehaviourNode._ctor(self, "KeepCircle")
    self.inst = inst
    
    self.times =
    {
		minwalktime = 2,
		randwalktime =  3,
		minwaittime = 1,
		randwaittime = 3,
    }
end)

local function SetAngle(inst)
	local leaderPos = inst.components.follower.leader:GetPosition()
	local initPos = inst:GetPosition()
	
	local offset = FindWalkableOffset(leaderPos, inst.Angle*DEGREES, 5, 10) or initPos - leaderPos
	leaderPos = leaderPos + offset
	
	return BufferedAction(inst, nil, ACTIONS.WALKTO, nil, leaderPos)
end

function Keepcircle:ShouldKeepMoving()
	local pt = self.inst.components.follower.leader:GetPosition()
	pt.x = pt.x + 6*math.sin(math.rad(self.inst.Angle))
	pt.z = pt.z+6*math.cos(math.rad(self.inst.Angle))
	local yourpt = self.inst:GetPosition()
	print(yourpt)
    return (distsq(yourpt, pt)>20)
end

function Keepcircle:Visit()

    if self.status == READY then
        self.inst.components.locomotor:Stop()
		self:Wait(self.times.minwaittime+math.random()*self.times.randwaittime)
        self.walking = false
        self.status = RUNNING
    elseif self.status == RUNNING then
    
		if not self.walking then
            self:PickNewDirection()
		end
    
        if GetTime() > self.waittime then
            self:PickNewDirection()
        else
            if not self.walking then
				self:Sleep(self.waittime - GetTime())
            end
        end
    end
    
    
end

function Keepcircle:Wait(t)
    self.waittime = t+GetTime()
    self:Sleep(t)
end

function Keepcircle:PickNewDirection()

    self.walking = not self.walking
    
    if self.walking and self:ShouldKeepMoving() then
        
		--print(self.inst, Point(self.inst.Transform:GetWorldPosition()), "FAR FROM HOME", self:GetHomePos())
		local pt = self.inst.components.follower.leader:GetPosition()
		local yourpt = self.inst:GetPosition()
		local angle = self.inst.Angle
		local radius = 6
		local attempts = 8
		local offset, check_angle, deflected = FindWalkableOffset(pt, angle*DEGREES, radius, attempts, true, false) -- try to avoid walls
		if not check_angle then
			offset, check_angle, deflected = FindWalkableOffset(pt, angle*DEGREES, radius, attempts, true, true) -- if we can't avoid walls, at least avoid water
		end
		if check_angle then
			angle = check_angle
		end

		if offset then
			print(pt+offset)
			self.inst.components.locomotor:GoToPoint(pt + offset)
		else
			self.inst.components.locomotor:WalkInDirection(angle/DEGREES)
		end
        self:Wait(self.times.minwalktime+math.random()*self.times.randwalktime)
    else
        self.inst.components.locomotor:Stop()
		self.inst:FacePoint(self.inst.components.follower.leader:GetPosition())
        self:Wait(self.times.minwaittime+math.random()*self.times.randwaittime)
    end
    
end


