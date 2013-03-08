run([[lib\b2b.lua]])
zmg.clear()

while test~=4 do
	zmg.clear()
	--debounce EXE key
	while zmg.keyMenuFast()==31 do end
	test = b2b.menu(1, 1, 16, 5, "Demo", {"printText demo","ygraph demo","inputString demo","exit"})
	zmg.clear()
	if test==1 then b2b.printText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed porttitor, sapien quis sagittis sodales, metus felis faucibus sem, eget mollis erat dolor non elit. Cras id nibh vel massa auctor euismod. Fusce semper rutrum neque, ut faucibus lacus egestas at. Donec velit augue, pulvinar sit amet vulputate et, consectetur iaculis neque. Donec et risus nisi, non pulvinar nunc. Duis quis sem neque. Ut eu dignissim nisl. Suspendisse potenti. In urna est, viverra id hendrerit vel, pulvinar eget felis. Donec suscipit, dui ac molestie molestie, mi orci scelerisque mi, quis cursus mi metus eget nibh. Aliquam commodo mi at eros sagittis dictum. Nunc ultrices turpis eu urna luctus dictum.")
		elseif test==2 then b2b.ygraph(function (x) return math.sin(x) end) zmg.keyMenu()
		elseif test==3 then b2b.inputString("Demo:")
	end
end
