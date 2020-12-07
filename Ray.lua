--[[
AUTHOR: ISABELA HUTCHINGS
NETID: cssetton
CLASS: csc 372 fall 2020
DESC: this is a function that contains the Ray class object
]]-- 

local vectors  = require "Vector"
RAY = {eye = nil, dir = nil}
--ray object contructor
function RAY:new(og,dirr)
	local o = o or {}
	setmetatable(o,self)
	self.__index = self
	o.eye = og
	o.dir = dirr
	return o
end
-- this returns the point of the ray based on the ray equation
function RAY:point(t)
	return self.eye + (self.dir *t)
end

