function moveTo(func)
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()
	win:setFrame(func(f, max))
end

function leftHalf()
	moveTo(function(f, max)
		f.x = max.x
		f.y = max.y
		f.w = max.w / 2
		f.h = max.h
		return f
	end)
end

function rightHalf()
	moveTo(function(f, max)
		f.x = max.w / 2
		f.y = max.y
		f.w = max.w / 2
		f.h = max.h
		return f
	end)
end

function topHalf()
	moveTo(function(f, max)
		f.x = max.x
		f.y = max.y
		f.w = max.w
		f.h = max.h / 2
		return f
	end)
end

function bottomHalf()
	moveTo(function(f, max)
		f.x = max.x
		f.y = max.h / 2
		f.w = max.w
		f.h = max.h / 2
		return f
	end)
end

function fullScreen()
	moveTo(function(f, max)
		f.x = max.x
		f.y = max.y
		f.w = max.w
		f.h = max.h
		return f
	end)
end


hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad4", leftHalf)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad6", rightHalf)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad8", topHalf)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad2", bottomHalf)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad5", fullScreen)


function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")
