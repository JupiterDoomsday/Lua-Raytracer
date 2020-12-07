--[[
AUTHOR: ISABELA HUTCHINGS
NETID: cssetton
CLASS: csc 372 fall 2020
DESC: this contains the Camera class object code
]]--
local RAYs = require "Ray" --have the program required to complie Ray.lua before it runs
--set up the CAMERA class varibables
CAMERA = {
eye=nil,
lens_radius = nil,
u=nil,
v=nil,
w=nil,
fov=nil,
horiz = nil,
vert = nil,
ll = nil}
--the constructor
function CAMERA:new(og,lookat,up,fov,aspect_ratio,focus)
	local o = o or {}
	setmetatable(o,self)
	self.__index = self
	o.aspectRatio = aspect_ratio
    o.eye = og
   	o.w = (og - lookat):normalize()
	o.u = (up:cross(o.w)):normalize()
	o.v = o.w:cross(o.u) * -1
	-- convert the view to perspective
	local h = math.tan((fov * math.pi / 180))
	local height = 2.0 * h
	local width = o.aspectRatio * height
	o.horiz = o.u * width * focus
    o.vert = o.v * height * focus
    o.ll =  o.eye - o.horiz/2 - o.vert/2 - o.w *focus
	
	return o
end
-- this function takes in (x,y) cordinates on a grid and generates the respective ray out of them
function CAMERA:generateRay(cordX,cordY)
	return RAY:new(self.eye, (self.ll + (self.horiz*cordX) + (self.vert*cordY) - self.eye))
end