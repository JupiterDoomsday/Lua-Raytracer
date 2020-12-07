--[[
AUTHOR: ISABELA HUTCHINGS
NETID: cssetton
CLASS: csc 372 fall 2020
DESC: this is a helper function that provides math based helper functions
]]--

 --this function provides a random double between the max and min values
function randDouble(min,max)
	return min + (max-min)* math.random()
end
--this rounds a number
function round(num) 
        if num >= 0 then return math.floor(num+.5) 
        else return math.ceil(num-.5) end
 end
-- this clamps a number to make sure its between the min and max values
 function clamp(x,min,max)
 	if(x < min) then 
 		return min
 	elseif (x > max) then 
 		return max
 	else
 		return x
 	end
 end
