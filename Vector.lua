--[[
AUTHOR: ISABELA HUTCHINGS
NETID: cssetton
CLASS: csc 372 fall 2020
DESC: this script contains the VECTOR class object code
]]--

RANDOM = require "Random"
VECTOR = {nil,nil,nil}

-- class contructor 
function VECTOR:new(x,y,z)
	local o = o or {x,y,z};
    setmetatable(o,self)
    self.__index = self
    --these set up vectors to be applies to arithmatic symbols in LUA
    self.__add = VECTOR.add       
    self.__sub = VECTOR.sub      
    self.__mul = VECTOR.mult 
    self.__len = VECTOR.len 
    self.__div = VECTOR.div  
    self.__unm = VECTOR.negate 
    return o
end
--dot product of a vector
function VECTOR:dot(v2)
	return self[1]*v2[1] + self[2]*v2[2]+ self[3]*v2[3]
end
--cross product of a vector
function VECTOR:cross(v2)
return VECTOR:new(
        self[2] * v2[3] - self[3] * v2[2], 
        self[1] * v2[3] - self[3] * v2[1], 
        self[1] * v2[2] - self[2] * v2[1]) 
end
--inverts a vector
function VECTOR:negate(v2)
	return VECTOR:new( 
	self[1] * -1,
	self[2] * -1,
	self[3] * -1)
end
--this applies addiion to a vector
function VECTOR:add(v2)
	return VECTOR:new((self[1]+v2[1]), (self[2] + v2[2]), (self[3] + v2[3]))
end
--this applies subtraction to a vector
function VECTOR:sub(v2)
	return VECTOR:new((self[1]- v2[1]), (self[2] - v2[2]), (self[3] - v2[3]))
end
--this applies multiplication to a vector it applies to both numbers and vector objects
function VECTOR:mult(v2)
	--check to see if v2 is a number or another vector
	if (type(v2) == 'table') then
		return VECTOR:new((self[1]*v2[1]), (self[2] * v2[2]), (self[3] * v2[3]))
	elseif(type(v2) == 'number') then
		return VECTOR:new((self[1]*v2), (self[2] * v2), (self[3] * v2))
	else
		io.write("error: input not a number OR table!\n")
	end
end
--this applies vector length squared
function VECTOR:len()
	return self:dot(self)
end
--this applies divison to a vector it applies to both numbers and vector objects
function VECTOR:div(v2)
	--check to see if v2 is a number or another vector 
	if (type(v2) == 'table') then
		return VECTOR:new((self[1]/v2[1]), (self[2] / v2[2]), (self[3] / v2[3]))
	elseif(type(v2) == 'number') then
		return VECTOR:new((self[1]/v2), (self[2] / v2), (self[3] / v2))
	else
		io.write("error: input not a number OR table!\n")
	end
end
--helper function to get the magnitude of a vector
function VECTOR:magnitude()
	return math.sqrt( self[1]*self[1] + self[2]*self[2] + self[3]*self[3])
end
--helper function to normalize a vector
function VECTOR:normalize()
	local len = self:magnitude()
	return self / self:magnitude()
end
--the method generates a reflect vector based on the normal we give it
function VECTOR:reflect(n)
	return self - (n * self:dot(n) * 2)
end
--helper function that prints out the vectors x y z values it clamps the values to [0,1]
-- then scales it by the pixel sampling and then multiplies it by 256 to generate the rb values
-- it then write the values in ppm format into the file io should be set up the the ppm file at this point
function VECTOR:writeColor(pixel)
	local sqrt= math.sqrt
	local scale = 1/pixel
	local r = 256 * clamp(sqrt(self[1] *scale),0.0,1)
	local g = 256 * clamp(sqrt(self[2] *scale),0.0,1)
	local b = 256 * clamp(sqrt(self[3] *scale) ,0.0,1)
	io.write(round(r)," ",round(g)," ",round(b),"\n")
end