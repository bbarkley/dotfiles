function moveTo(func)
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()
	win:setFrame(func(f, max))
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


local mainScreen = hs.screen.allScreens()[1]
local laptopScreen = hs.screen.allScreens()[2]
local portraitScreen = hs.screen.allScreens()[3]

local threeScreenLayout = {
    {"LinkedIn Gmail",  nil, portraitScreen, hs.geometry.rect(0, 0.5, 1.0, 0.5), nil, nil},
	{"Dash",            nil, portraitScreen, hs.geometry.rect(0.15, 0.02, 0.7, 0.35), nil, nil},	
	{"Adium",           nil, portraitScreen, hs.geometry.rect(0.2, 0.25, 0.6, 0.25), nil, nil},
	{"Adium",    "Contacts", portraitScreen, hs.geometry.rect(0.0, 0.0, 0.7, 0.35), nil, nil},
	{"TextMate",        nil, mainScreen, hs.geometry.rect(0.1, 0.1, 0.8, 0.8), nil, nil},
	{"Safari",          nil, mainScreen, hs.geometry.rect(0.05, 0.05, 0.8, 0.8), nil, nil},
}



local threeMash = {"cmd", "alt", "ctrl"}
hs.hotkey.bind(threeMash, "pad4", function() hs.window.focusedWindow():moveToUnit(hs.layout.left50) end)
hs.hotkey.bind(threeMash, "pad6", function() hs.window.focusedWindow():moveToUnit(hs.layout.right50) end)
hs.hotkey.bind(threeMash, "pad8", topHalf)
hs.hotkey.bind(threeMash, "pad2", bottomHalf)
hs.hotkey.bind(threeMash, "pad5", function() hs.window.focusedWindow():moveToUnit(hs.layout.maximized) end)

hs.hotkey.bind(threeMash, 'g', hs.grid.show)

hs.hotkey.bind(threeMash, 'padenter', function() hs.layout.apply(threeScreenLayout) end)

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
