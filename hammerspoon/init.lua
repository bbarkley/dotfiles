hs.window.animationDuration = 0

local screenWatcher = nil

local lastNumberOfScreens = #hs.screen.allScreens()

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

function scrollUp()
	hs.eventtap.scrollWheel({0,1}, {})
end

function scrollDown()
	hs.eventtap.scrollWheel({0,-1}, {})
end

function scrollLeft()
	hs.eventtap.scrollWheel({2,0}, {})
end

function scrollRight()
	hs.eventtap.scrollWheel({-2,0}, {})
end

function mouseHighlight()
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    mousepoint = hs.mouse.getAbsolutePosition()
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-20, mousepoint.y-20, 40, 40))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:bringToFront(true)
    mouseCircle:show()

    mouseCircleTimer = hs.timer.doAfter(1, function() mouseCircle:delete() end)
end

function mouseUp()
  local pos = hs.mouse.getAbsolutePosition()
  hs.mouse.setAbsolutePosition(hs.geometry.point(pos["x"], pos["y"] - 5))
  mouseHighlight()
end

function mouseDown()
  local pos = hs.mouse.getAbsolutePosition()
  hs.mouse.setAbsolutePosition(hs.geometry.point(pos["x"], pos["y"] + 5))
  mouseHighlight()
end

function mouseLeft()
  local pos = hs.mouse.getAbsolutePosition()
  hs.mouse.setAbsolutePosition(hs.geometry.point(pos["x"] - 5, pos["y"]))
  mouseHighlight()
end

function mouseRight()
  local pos = hs.mouse.getAbsolutePosition()
  hs.mouse.setAbsolutePosition(hs.geometry.point(pos["x"] + 5, pos["y"]))
  mouseHighlight()
end

-- Screens
local mainScreen = hs.screen.allScreens()[1]
local laptopScreen = hs.screen.allScreens()[2]
local portraitScreen = hs.screen.allScreens()[3]

local iTunesMiniPlayerLayout = {"iTunes", "MiniPlayer", portraitScreen, hs.geometry.rect(0, 0.922, 0.1, 0.1), nil, nil}

local threeScreenLayout = {
  {"IntelliJ IDEA",   nil, mainScreen, hs.geometry.rect(0.0, 0.0, 1.0, 1.0), nil, nil},
	iTunesMiniPlayerLayout,
}

local threeScreenLayout = {
  {"LinkedIn Gmail",  nil, portraitScreen, hs.geometry.rect(0, 0.5, 1.0, 0.5), nil, nil},
	{"Dash",            nil, portraitScreen, hs.geometry.rect(0.15, 0.02, 0.8, 0.35), nil, nil},	
	{"Adium",           nil, portraitScreen, hs.geometry.rect(0.2, 0.25, 0.6, 0.25), nil, nil},
	{"Adium",    "Contacts", portraitScreen, hs.geometry.rect(0.0, 0.0, 0.7, 0.35), nil, nil},
	{"TextMate",        nil, mainScreen, hs.geometry.rect(0.1, 0.1, 0.8, 0.8), nil, nil},
	{"Safari",          nil, mainScreen, hs.geometry.rect(0.05, 0.05, 0.8, 0.8), nil, nil},
  {"IntelliJ IDEA",   nil, mainScreen, hs.geometry.rect(0.0, 0.0, 1.0, 1.0), nil, nil},
	iTunesMiniPlayerLayout,
}


-- Callback function for changes in screen layout
function screensChangedCallback()
    newNumberOfScreens = #hs.screen.allScreens()
    if lastNumberOfScreens ~= newNumberOfScreens then
        if newNumberOfScreens == 1 then
            hs.layout.apply(singleScreenLayout)
        elseif newNumberOfScreens == 3 then
            hs.layout.apply(threeScreenLayout)
        end
    end

    lastNumberOfScreens = newNumberOfScreens
end



local threeMash = {"cmd", "alt", "ctrl"}
local fourMash = {"cmd", "alt", "ctrl", "shift"}
local triangleMash = {"cmd", "ctrl", "shift"}

-- scrolling
hs.hotkey.bind(triangleMash, "up", scrollUp, nil, scrollUp)
hs.hotkey.bind(triangleMash, "down", scrollDown, nil, scrollDown)
hs.hotkey.bind(triangleMash, "left", scrollLeft, nil, scrollLeft)
hs.hotkey.bind(triangleMash, "right", scrollRight, nil, scrollRight)

-- mouse movement
hs.hotkey.bind(fourMash, "up", mouseUp, nil, mouseUp)
hs.hotkey.bind(fourMash, "down", mouseDown, nil, mouseDown)
hs.hotkey.bind(fourMash, "left", mouseLeft, nil, mouseLeft)
hs.hotkey.bind(fourMash, "right", mouseRight, nil, mouseRight)

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



screenWatcher = hs.screen.watcher.new(screensChangedCallback)
screenWatcher:start()


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
