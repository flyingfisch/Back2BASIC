b2b={}
b2b.version="indev-version not released"
SCREEN_WIDTH = 384
SCREEN_HEIGHT = 216

b2b.menu = function (x, y, width, height, title, array, color1, color2)
	color1 = color1 or zmg.makeColor("black")
	color2 = color2 or zmg.makeColor("white")
	local continue=0
	local selected=1
	local max=height
	local j=1
	x=x*12-12
	y=y*18-18
	while continue==0 do
		--handle keys
		if key==28 then 
			if selected>1 then 
				selected=selected-1
				if selected<max-height+1 then max=selected+height-1 end
			else
				selected=#array
				max=#array
			end
		end
		
		if key==37 then
			if selected<#array then
				selected=selected+1
				if selected>height then max=selected end
			else
				selected=1
				max=height
			end
		end
		
		if zmg.keyMenuFast()==31 then
			continue=1
			--debounce
			while zmg.keyMenuFast()==31 do end
		end
		
		--draw menu
		zmg.drawRectFill(x+1, y+18, width*12, height*18, color2)
		zmg.drawText(x+1, y+1, title, color2, color1)
		
		j=1
		for i=max-height+1, max, 1 do
			if selected==i then
				zmg.drawText(x+1, y+(j*18), string.sub(array[i], 1, width), color2, color1)
				else
				zmg.drawText(x+1, y+(j*18), string.sub(array[i], 1, width), color1, color2)
			end
			j=j+1
		end
		
		
		--refresh screen
		zmg.fastCopy()
		--keyMenu
		if continue~=1 then key=zmg.keyMenu() end
	end

	return selected
end

b2b.printText = function (string, colorfg, colorbg)
	colorfg = colorfg or zmg.makeColor("black")
	colorbg = colorbg or zmg.makeColor("white")
	local substring={}
	local k=1
	--if string extends past screen end (x)
	if #string>31 then
		--split string into screen width sized portions
		for i=1, math.floor(#string/31)+1, 1 do
			substring[i] = string.sub(string, i*31-30, i*31)
		end
	end
	--display
	for j=1, math.floor(#substring/11)+1, 1 do
		k=1
		--clear screen
		zmg.drawRectFill(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, colorbg)
		for i=j*11-10, j*11, 1 do
			if substring[i] then zmg.drawText(1, k*18-18, substring[i], colorfg, colorbg) end
			k=k+1
		end
		zmg.drawText(1, 198, "Press a key (Page " .. j .. "/" .. math.floor(#substring/11)+1 .. ")", colorbg, colorfg)
		--refresh
		zmg.fastCopy()
		--wait
		zmg.keyMenu()
	end
end

b2b.locate = function (x, y, string, colorfg, colorbg)
	x = x*12-12
	y = y*18-18
	colorfg = colorfg or zmg.makeColor("black")
	colorbg = colorbg or zmg.makeColor("white")
	zmg.drawText(x, y, string, colorfg, colorbg)
end

b2b.ygraph = function(f, vwin, type, colorfg, colorbg)
	vwin = vwin or {xmin=-3,xmax=3,ymin=-6,ymax=6,step=0.1}
	type = type or "connect"
	colorfg = colorbg or zmg.makeColor("black")
	colorbg = colorbg or zmg.makeColor("white")
	zmg.clear()
	
	local xstep=SCREEN_WIDTH/(math.abs(vwin.xmin)+math.abs(vwin.xmax))
	local ystep=SCREEN_HEIGHT/(math.abs(vwin.ymin)+math.abs(vwin.ymax))
	
	for i = vwin.xmin, vwin.xmax, vwin.step do
		
		local x = (xstep*math.abs(vwin.xmin))+i*xstep
		local y = f(i)
		y = SCREEN_HEIGHT-((ystep*math.abs(vwin.ymin))+y*ystep)

		local oldx = (xstep*math.abs(vwin.xmin))+(i-vwin.step)*xstep
		local oldy = f(i-vwin.step)
		oldy = SCREEN_HEIGHT-((ystep*math.abs(vwin.ymin))+oldy*ystep)
		
		if type=="plot" then zmg.drawPoint(x, y, colorfg)
			else
				zmg.drawLine(oldx, oldy, x, y, colorfg)
		end
	end
    
	zmg.fastCopy()
	zmg.keyMenu()
end
