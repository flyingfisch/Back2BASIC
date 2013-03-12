b2b={}
b2b.version="indev-version not released"
SCREEN_WIDTH = 384
SCREEN_HEIGHT = 216

b2b.autoFastCopy = function (option)
	if option==1 then b2b.fastCopy = function() b2b.fastCopy() end
		else b2b.fastCopy = function() end
	end
end

b2b.autoFastCopy(1)

b2b.getkey = zmg.keyMenuFast

b2b.menu = function (x, y, width, height, title, array, color1, color2)
	color1 = color1 or zmg.makeColor("black")
	color2 = color2 or zmg.makeColor("white")
	local continue=0
	local selected=1
	if height>#array then height=#array end
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
		b2b.fastCopy()
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
		b2b.fastCopy()
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
	b2b.fastCopy()
end

b2b.ygraph = function (f, vwin, type, colorfg, colorbg)
	vwin = vwin or {xmin=-6,xmax=6,ymin=-3,ymax=3,step=0.1}
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
    
	b2b.fastCopy()
end

b2b.inputString = function (prompt, colorfg, colorbg, blinkspeed)
	colorfg = colorfg or zmg.makeColor("black")
	colorbg = colorbg or zmg.makeColor("white")
	local blinkspeed=blinkspeed or 60
	local blink=1
	local blinktimer=zmg.ticks()
	local cursor=1
	local cursorstyle={norm=" ",alpha="A",shift="s"}
	local char=""
	local string=""
	local keyset="norm"
	local key={norm={},alpha={},shift={}}
	key.norm[41]="-" key.norm[51]="EXP" key.norm[61]="." key.norm[71]="0" key.norm[32]="-" key.norm[42]="+" key.norm[52]="3" key.norm[62]="2" key.norm[72]="1" key.norm[33]="/" key.norm[43]="*" key.norm[53]="6" key.norm[63]="5" key.norm[73]="4" key.norm[54]="9" key.norm[64]="8" key.norm[74]="7" key.norm[25]="->" key.norm[35]="," key.norm[45]=")" key.norm[55]="(" key.norm[26]="tan(" key.norm[36]="cos(" key.norm[46]="sin(" key.norm[56]="ln(" key.norm[66]="log(" key.norm[57]="^" key.norm[67]="^2"
	key.alpha[51]=[["]] key.alpha[61]=" " key.alpha[71]="Z" key.alpha[32]="Y" key.alpha[42]="X" key.alpha[52]="W" key.alpha[62]="V" key.alpha[72]="U" key.alpha[33]="T" key.alpha[43]="S" key.alpha[53]="R" key.alpha[63]="Q" key.alpha[73]="P" key.alpha[54]="O" key.alpha[64]="N" key.alpha[74]="M" key.alpha[25]="L" key.alpha[35]="K" key.alpha[45]="J" key.alpha[55]="I" key.alpha[65]="H" key.alpha[75]="G" key.alpha[26]="F" key.alpha[36]="E" key.alpha[46]="D" key.alpha[56]="C" key.alpha[66]="B" key.alpha[76]="A"
	key.shift[51]="pi" key.shift[61]="=" key.shift[71]="i" key.shift[32]="]" key.shift[42]="[" key.shift[62]="Mat(" key.shift[72]="List(" key.shift[33]="}" key.shift[43]="{" key.shift[45]="x^-1" key.shift[26]="atan(" key.shift[36]="acos(" key.shift[46]="asin(" key.shift[56]="e(" key.shift[66]="10^" key.shift[76]="angle(" key.shift[67]="sqrt(" 
	
	b2b.locate(1,1,prompt,colorfg,colorbg)

	while zmg.keyMenuFast()~=31 do
		
		char = key[keyset][zmg.keyMenuFast()] or ""
		
		if char~="" then 
			string = string.sub(string,1,cursor) .. char .. string.sub(string,cursor+1,#string)
			if #string>1 then cursor=cursor+#char end
			char=""
			while zmg.keyMenuFast()>0 do end
		end
		
		if #string>31 then string = string.sub(string,1,31) cursor=31 end
		if zmg.keyMenuFast()==44 and cursor>0 then
			string = string.sub(string,1,cursor-1) .. string.sub(string,cursor+1,#string)
			cursor = cursor-1
			b2b.locate(1,2,"                               ",colorfg,colorbg)
			elseif zmg.keyMenuFast()==27 and cursor<#string then cursor=cursor+1
			elseif zmg.keyMenuFast()==38 and cursor>0 then cursor=cursor-1
		end

		if zmg.keyMenuFast()==78 and keyset=="norm" then keyset="shift" while zmg.keyMenuFast()==78 do end
			elseif zmg.keyMenuFast()==78 then keyset="norm" while zmg.keyMenuFast()==78 do end
		end
		
		if zmg.keyMenuFast()==77 and keyset=="norm" then keyset="alpha" while zmg.keyMenuFast()==77 do end
			elseif zmg.keyMenuFast()==77 then keyset="norm" while zmg.keyMenuFast()==77 do end
		end
		
		if cursor<1 then cursor=1 elseif cursor>31 then cursor=31 end
		zmg.drawText(1*12-12,2*18-18,string,colorfg,colorbg)
		if blink>0 then b2b.locate(cursor,2,cursorstyle[keyset],colorbg,colorfg)
			else b2b.fastCopy()
		end
		if zmg.ticks()-blinktimer>blinkspeed then blink=blink*-1 blinktimer=zmg.ticks() end
		
	end
	return string
end

b2b.fline = function (x1, y1, x2, y2, color)
	color = color or zmg.makeColor("black")
	zmg.drawLine(x1, y1, x2, y2, color)
end
