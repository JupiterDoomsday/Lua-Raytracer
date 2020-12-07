--[[
AUTHOR: ISABELA HUTCHINGS
NETID: cssetton
CLASS: csc 372 fall 2020
DESC: this contains ruins the main implementation of our Raytracer
]]--
--setup the required files for us to compile
local Camera   = require "Camera"
local Shape  = require "Shapes"
 
 -- a helper function to split the lines of a string based on a character
function split(str, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for word in string.gmatch(str, "([^"..sep.."]+)") do
                table.insert(t, word)
        end
        return t
end
--this function calculates the color and returns a vector the represents our color
function rayColor(light,list,ray,depth)
	local rec = SHAPE:new(nil,nil)
	--if we hit our depth than return a shadow
	if(depth == 0 ) then
			return VECTOR:new(0,0,0)
	end
	--check of the ray intersects with any object
	if(list:hit(ray,0.001,math.huge,rec)) then
		--setup the calculations for diffused shading
		local lightDir = rec.p - light
		local newDir = ray.dir:reflect(rec.normal):normalize()
		local newRay = RAY:new(rec.p,newDir)
		local h = rec.normal:dot(lightDir)
		--check if the object is a mirror, if so recursively call the raytracer if not return diffused lighting
		if(rec.mirror) then
			return  rayColor(light,list,newRay,depth-1) * rec.material * (0.25/math.pi) * math.max(0,h)
		else
			return  rec.material * (0.55/math.pi) * math.max(0,h)
		end
	end
	--ray doesn't intersect so calculate the default backgruond color
	local unitDir = ray.dir:normalize() 
	t = 0.5 * unitDir[2] + 1.0
	return  (VECTOR:new(1.0, 1.0, 1.0) * (1.0-t)) + (VECTOR:new(0.5, 0.7, 1.0) * t);
end
--this function renders our scene
function render(cam,list, light, height,width,file)
	local rand = math.random
	local file = io.open(file,"w") --set io to the file object
	--set up the window view 
	local sample_pix = 100
	local maxDepth = 3
	local viewport_height = 2.0;
	local  focal_length = 1.0;
    local viewport_width = cam.aspectRatio * viewport_height;
	local sample=10
	io.output(file)
	io.write("P3\n",width + 1,' ',height + 1,'\n',"256\n") --setup ppm header
	--iterate through each pixel of our camera
	for y = height, 0,-1 do
		for x = 0, width,1 do
			local vector = VECTOR:new(0,0,0)
			--calculate the sampling to do anti-alaising
			for s=0, sample,1 do
				local i = (x+rand()) / (width)
				local j = (y+rand()) / (height)
				local r = cam:generateRay(i,j)
				local color = rayColor(light,list,r,maxDepth)
				local tem = vector + color
				vector = tem
		end
			vector:writeColor(sample) --print the color to the file
		end
	end
	file:close()
end
--this is a helper function that sets up the static scene I made!
function makeStaticscene(world)
	local eye = VECTOR:new(0,0,0)
	local up = VECTOR:new(0,1,0)
	local lookAt = VECTOR:new(0,0,-1)
	local cam = CAMERA:new(eye,lookAt,up,65,(16.0 / 9.0),10)
	local w = 400
	local h = round(w/cam.aspectRatio)
	local light = VECTOR:new(-5,-10,-4)
	world:add(SPHERE:new(VECTOR:new(0,0,-1),.5,VECTOR:new(0,1,1),false))
	world:add(SPHERE:new(VECTOR:new(2,0,-3),.5,VECTOR:new(0,.5,1),false))
	world:add(SPHERE:new(VECTOR:new(0,-100.5,-1),100,VECTOR:new(.5,1,.5),true))
	render(cam,world,light, h - 1,w - 1 ,"static.ppm")
	print("completed output ppm file: static.ppm");
end
--this is a helper function that creates a sphere object from player input an adds it onto our
-- world SHAPE_LIST object
function makeSphere(world)
	--make the center of the cirlce form std:input
	print("what is the center? give the (x,y,z) location-- seperate by space");
	local input = io.read()
	local cords = split(input," ")
	if(#cords < 3) then
		print("ERROR: not enough values");
		return
	end
	local center = VECTOR:new(tonumber(cords[1]),tonumber(cords[2]),tonumber(cords[3]))
	--make the radius
	print("what is the radius?");
	input = io.read()
	--take the rgb values
	local rad = tonumber(input)
	print("what is the color? put rgb values");
	input = io.read()
	cords = split(input," ")
	if(#cords < 3) then
		print("ERROR: not enough values");
		return
	end
	local colors = VECTOR:new(tonumber(cords[1])/256,tonumber(cords[2])/256,tonumber(cords[3])/256)
	print("Is it a mirror? (y/n");
	f = io.read():lower()
	local reflective = false
	--check to see if the sphere is reflective
	if(f == 'yes' or f == 'y') then
		reflective=true
	end
	world:add(SPHERE:new(center,rad,colors,reflective))
end
--this is the main function that runs when we compile main it gives people the option
-- to customize their own scene or run the preset scene I created!
function main()
	local world = SHAPE_LIST:new()
	print("Would you like to print out my preset scene? (y/n):");
	local f = io.read():lower()
	if(f == 'yes' or f == 'y') then
		print("preparing scene please wait...");
		makeStaticscene(world)
		return
	elseif (f == "no" or f == 'n') then
		print(" the camera is at point (0,0,0)");
	else
		print("ERROR: does not recognize input");
		return
	end
--create the look at vector from user input for our camera
	print("where do we look at?: give the (x,y,z) location-- seperate by space");
	f = io.read()
	local cords = split(f," ")
	if(#cords < 3) then
		print("ERROR: not enough values");
		return
	end
	local lookAt = VECTOR:new(tonumber(cords[1]),tonumber(cords[2]),tonumber(cords[3]))
	local up = VECTOR:new(0,1,0)
--create the fov angle for our camera
	print("what is our field of view? type in number by degrees")
	print("WARNING: must be less than 180 degrees!")
	f = io.read()
	local fov = tonumber(f)
	local eye = VECTOR:new(0,0,0)
	local cam = CAMERA:new(eye,lookAt,up,fov,(16.0 / 9.0),10)
	print("Camera is made!")
	--create a light point
	print("where's the sun? give the (x,y,z) cordinates")
	f = io.read()
	cords = split(f," ")
	if(#cords < 3) then
		print("ERROR: not enough values");
		return
	end
	local lamp = VECTOR:new(tonumber(cords[1]),tonumber(cords[2]),tonumber(cords[3]))
	local str = nil
	local w = 400
	local h = round(w/cam.aspectRatio)
	--create a feedback loop that will ask for the players input until their done
	while(true) do
		print("input cmds: sphere, clear, draw, exit")
		str = io.read():lower()
		if(str =='sphere')then
			makeSphere(world)
		elseif( str == 'draw') then
			print("preparing scene please wait...");
			render(cam,world,lamp, h - 1,w - 1 ,"scene.ppm")
			print("scene.ppm has been made/updated!")
		elseif (str == 'clear') then
			world:clear()
		elseif (str == 'exit' or str == 'done') then
			world:clear()
			return
		else
			print("ERROR: does not recognize input");
		end
	end
end
--call the main function 
main()
