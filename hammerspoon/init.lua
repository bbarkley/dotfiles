hs.window.animationDuration = 0

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

-- Toggle an application between being the frontmost app, and being hidden
function toggle_application(_app, mayHide)
	if mayHide == nil then
		mayHide = true
	end
    local app = hs.appfinder.appFromName(_app)
    if not app then
        return
    end
    local mainwin = app:mainWindow()
    if mainwin then
        if mainwin == hs.window.focusedWindow() and mayHide then
            mainwin:application():hide()
        else
            mainwin:application():activate(true)
            mainwin:application():unhide()
            mainwin:focus()
        end
    end
end

function toFront(_app)
	local app = hs.appfinder.appFromName(_app)
	if not app then
		return
	end
	local mainwin = app:mainWindow()
    mainwin:application():activate(true)
    mainwin:application():unhide()
    mainwin:focus()
end


local mainScreen = hs.screen.allScreens()[1]
local laptopScreen = hs.screen.allScreens()[2]
local portraitScreen = hs.screen.allScreens()[3]

local iTunesMiniPlayerLayout = {"iTunes", "MiniPlayer", portraitScreen, hs.geometry.rect(0, 0.922, 0.1, 0.1), nil, nil}

local threeScreenLayout = {
    {"LinkedIn Gmail",  nil, portraitScreen, hs.geometry.rect(0, 0.5, 1.0, 0.5), nil, nil},
	{"Dash",            nil, portraitScreen, hs.geometry.rect(0.15, 0.02, 0.7, 0.35), nil, nil},	
	{"Adium",           nil, portraitScreen, hs.geometry.rect(0.2, 0.25, 0.6, 0.25), nil, nil},
	{"Adium",    "Contacts", portraitScreen, hs.geometry.rect(0.0, 0.0, 0.7, 0.35), nil, nil},
	{"TextMate",        nil, mainScreen, hs.geometry.rect(0.1, 0.1, 0.8, 0.8), nil, nil},
	{"Safari",          nil, mainScreen, hs.geometry.rect(0.05, 0.05, 0.8, 0.8), nil, nil},
	iTunesMiniPlayerLayout,
}



local threeMash = {"cmd", "alt", "ctrl"}

-- window movement
hs.hotkey.bind(threeMash, "pad4", function() hs.window.focusedWindow():moveToUnit(hs.layout.left50) end)
hs.hotkey.bind(threeMash, "pad6", function() hs.window.focusedWindow():moveToUnit(hs.layout.right50) end)
hs.hotkey.bind(threeMash, "pad8", topHalf)
hs.hotkey.bind(threeMash, "pad2", bottomHalf)
hs.hotkey.bind(threeMash, "pad5", function() hs.window.focusedWindow():moveToUnit(hs.layout.maximized) end)

-- grid
hs.hotkey.bind(threeMash, 'g', hs.grid.show)


-- layout reset
hs.hotkey.bind(threeMash, 'padenter', function() hs.layout.apply(threeScreenLayout) end)

-- app show/hide
hs.hotkey.bind(threeMash, 'j', function() toggle_application("IntelliJ IDEA") end)
hs.hotkey.bind(threeMash, 't', function() toggle_application("iTerm") end)
hs.hotkey.bind(threeMash, 'c', function() 
	toggle_application("LinkedIn Gmail", false) 
	hs.eventtap.keyStroke({'cmd'}, '2')
end)

hs.hotkey.bind(threeMash, 'm', function() 
	toggle_application("LinkedIn Gmail", false) 
	hs.eventtap.keyStroke({'cmd'}, '1')
end)

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
