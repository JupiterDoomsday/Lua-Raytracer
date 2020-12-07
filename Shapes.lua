--[[
AUTHOR: ISABELA HUTCHINGS
NETID: cssetton
CLASS: csc 372 fall 2020
DESC: this contains the Shape class object code
]]--
local Rays = require "Ray" --tell the script that it must compile Ray.lua before it runs
--setting up class variables
SHAPE = { point= nil, normal = nil, t = nil, front=nil, material = nil, mirror=false}
SPHERE = {center = nil, radius = nil, color=nil, mirror=false}
SHAPE_LIST = {}
--this is the prototype class for hittable objects
function SHAPE:new(p,normal)
	local o = o or {}
	setmetatable(o,self)
    self.__index = self
    o.p = p
    o.normal = normal
    return o
end
--this function check to see if the ray is inside of our sphere or not
--it then alters the normal vector to either be pointing outward of the objects surface
-- IF we're looking at the front of the surface or
-- turns the normal inward if we're inside the shape object
function SHAPE:setFaceNormal(r, outNorm)
	self.front = r.dir:dot(outNorm) < 0 
	if (self.front) then
		self.normal = outNorm
	else
		self.normal = (outNorm * -1)	
	end
end
--our shape constructor
function SPHERE:new(cent,rad,mat,is)
	local o = SHAPE:new(nil,nil) --set sphere to inherit the SHAPE prototype
	setmetatable(o,self)
    self.__index = self
    o.center= cent
    o.radius = rad
    o.material = mat
   	o.mirror = is

	return o
end
--this creates a new list of shapes we can use this to iterate through all the spheres!
function SHAPE_LIST:new()
	local o = o or {}
	setmetatable(o,self)
	self.__index=self
	return o
end
--this adds a new shape object into our list, doing this make the syntax of my script consistent
--for OO programing
function SHAPE_LIST:add(shape)
	table.insert(self,shape)
end
--this funciton clears the entire shape list ot be empty
function SHAPE_LIST:clear()
	--for each object in the list turn it into nil
	for i in pairs(self) do
    self[i] = nil
	end
end
--this function runs when we are checking to see if a viewing Ray from the camera hits an object
-- the SHAPE_LIST object iterates throuhg each shape object and check to see if it intersects
-- if it intersects then is updates the rec varible which keeps track of the current closest object
-- in our view.
function SHAPE_LIST:hit(ray, tmin, tmax, rec)
	local hasHit = false
	local closest = tmax
	for k,v in pairs(self) do
		if(v:hit(ray,tmin,closest,rec)) then
			hasHit = true;
			closest=rec.t
		end
	end
	return hasHit
end

--this function returns true t is in range of min and max
-- if it is then it DID hit our target and we're going to update rec to hold the new
-- objects data, we then return a boolean that we intersected with an object in range!
function SPHERE:hitSphere(ray,rec,t,tmin,tmax)
	if(t < tmax and t > tmin) then
		rec.t = t --store the t value
		rec.p = ray:point(t) --convert ray into point with ray equation
		rec.mirror = self.mirror --apply mirror effect
		rec:setFaceNormal(ray, (rec.p - self.center)/self.radius) --set the normal for our object
		rec.material = self.material --store the sphere color
		return true
	else 
		return false
	end
end

--basic hit ray they calculates IF the ray hits the sphere in the first place
function SPHERE:hit(ray, tmin, tmax, rec)
	local oc = ray.eye - self.center
	local a = ray.dir:dot(ray.dir)
	local bHalf = oc:dot(ray.dir)
	local c = oc:dot(oc) - (self.radius * self.radius)
	local discriminant = bHalf*bHalf - a*c
	if discriminant < 0 then --if discriminant is zero then it didn't hit
		return false
	else
		--check to see which point the ray touched the sphere and which point is the closest to us
		local root  = math.sqrt(discriminant)
		local p1 = (-bHalf - root) / a
		local p2 = (-bHalf + root) / a
		return self:hitSphere(ray,rec,p1,tmin,tmax) or self:hitSphere(ray,rec,p2,tmin,tmax)
	end
end

--this function takes a point where the Ray intersects with the object and returns the normal vector
function SPHERE:normal(point)
	return (point - self.center):normalize()
end