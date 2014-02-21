// Configs
S.cfga({
  "defaultToCurrentScreen" : true,
  "secondsBetweenRepeat" : 0.1,
  "checkDefaultsOnLoad" : true,
  "focusCheckWidthMax" : 3000,
  "orderScreensLeftToRight" : true
});

// Monitors
var monPortrait = "1200x1920";
var monMain = "1920x1200";
var monLaptop = "1680x1050";


// Operations
var fullScreen = S.op("move", {
  "x" : "screenOriginX",
  "y" : "screenOriginY",
  "width" : "screenSizeX",
  "height" : "screenSizeY"
});

var mainFull = fullScreen.dup({"screen" : monMain});
var lappyFull = fullScreen.dup({"screen" : monLaptop});
var portraitFull = fullScreen.dup({"screen" : monPortrait});

var portraitLeft = portraitFull.dup({ "width" : "screenSizeX/3" });
var portraitMid = portraitLeft.dup({ "x" : "screenOriginX+screenSizeX/3" });
var portraitRight = portraitLeft.dup({ "x" : "screenOriginX+(screenSizeX*2/3)" });
var portraitLeftTop = portraitLeft.dup({ "height" : "screenSizeY/2" });
var portraitLeftBot = portraitLeftTop.dup({ "y" : "screenOriginY+screenSizeY/2" });
var portraitMidTop = portraitMid.dup({ "height" : "screenSizeY/2" });
var portraitMidBot = portraitMidTop.dup({ "y" : "screenOriginY+screenSizeY/2" });
var portraitRightTop = portraitRight.dup({ "height" : "screenSizeY/2" });
var portraitRightBot = portraitRightTop.dup({ "y" : "screenOriginY+screenSizeY/2" });
var portraitBottomFull = portraitLeftBot.dup({ "width" : "screenSizeX"});


var portraitChat = S.op("move", {
  "screen" : monPortrait,
  "x": "screenOriginX+screenSizeX/5",
  "y": "screenOriginY",
  "width": "screenSizeX/1.5",
  "height": "screenSizeY/3"
});

// 3 monitor layout
var threeMonitorLayout = S.layout("threeMonitor", {
  "Adium" : {
    "operations" : [portraitLeftTop.dup({"x" : "screenOriginX-4"}), portraitChat],
    "ignore-fail" : true,
    "title-order" : ["Contacts"],
    "repeat-last" : true
  },
  "Mail" : {
    "operations" : [portraitBottomFull],
    "ignore-fail" : true,
    "repeat-last" : true
  },
  "TextMate" : {
    "operations" : [mainFull.dup({"x" : "screenOriginX+screenSizeX/8", "width" : "screenSizeX/1.4", "y" : "screenOriginY+50", "height" : "screenSizeY/1.2"})],
    "ignore-fail" : true,
    "repeat-last" : true
  },
  "Eclipse" : {
    "operations" : [mainFull],
    "ignore-fail" : true,
    "repeat-last" : true
  },
  "Twitter" : {
    "operations" : [lappyFull.dup({"x" : "screenOriginX+screenSizeX/3", "y" : "screenOriginY+100", "height" : "screenSizeY/1.3"})],
    "ignore-fail" : true,
    "repeat-last" : true
  },
  "iTerm" : {
    "operations" : [mainFull.dup({"width": "screenSizeX/2.2"}), mainFull.dup({"height" : "screenSizeY/1.2"})],
    "ignore-fail" : true,
    "title-order-regex" : [".*Scala-ld.*"],
    "repeat-last" : true
  },
  "Dash" : {
    "operations" : [portraitFull.dup({"x" : "screenOriginX+140", "y" : "screenOriginY+250", "width" : "1045", "height" : "675"})],
    "ignore-fail" : true,
    "repeat-last" : true
  }
});

// Layout Operations
var threeMonitor = S.op("layout", { "name" : threeMonitorLayout });
// var twoMonitor = S.op("layout", { "name" : twoMonitorLayout });
// var oneMonitor = S.op("layout", { "name" : oneMonitorLayout });
var universalLayout = function() {
  S.log("SCREEN COUNT: "+S.screenCount());
  if (S.screenCount() === 3) {
    threeMonitor.run();
  }
   // else if (S.screenCount() === 2) {
 //    twoMonitor.run();
 //  } else if (S.screenCount() === 1) {
 //    oneMonitor.run();
 //  }
};


// Defaults
S.def(3, threeMonitorLayout);


// Bindings
S.bindAll({
  // push to edges
  "pad6:cmd;alt;ctrl" : S.op("push", { "direction" : "right", "style" : "bar-resize:screenSizeX/2" }),
  "pad4:cmd;alt;ctrl" : S.op("push", { "direction" : "left", "style" : "bar-resize:screenSizeX/2" }),
  "pad8:cmd;alt;ctrl" : S.op("push", { "direction" : "up", "style" : "bar-resize:screenSizeY/2" }),
  "pad2:cmd;alt;ctrl" : S.op("push", { "direction" : "down", "style" : "bar-resize:screenSizeY/2" }),
  
  // Nudge/Move Bindings
  "right:cmd;alt;ctrl;shift" : S.op("nudge", { "x" : "+5%", "y" : "+0" }),
  "left:cmd;alt;ctrl;shift" : S.op("nudge", { "x" : "-5%", "y" : "+0" }),
  "up:cmd;alt;ctrl;shift" : S.op("nudge", { "x" : "+0", "y" : "-5%" }),
  "down:cmd;alt;ctrl;shift" : S.op("nudge", { "x" : "+0", "y" : "+5%" }),
  
  
  
  // center
  "pad5:cmd;alt;ctrl" : S.op("move", {"x" : "screenOriginX+screenSizeX/8", "y" : "screenOriginY+screenSizeY*0.075", "width" : "screenSizeX*0.75", "height" : "screenSizeY*0.85"}),
  
  
  "f:cmd;alt;ctrl" : fullScreen,
  
  "padEnter:cmd;alt;ctrl" : universalLayout,

  // Relaunch for quick config work
  "r:cmd;alt;ctrl" : S.op("relaunch"),
  
  // Window Hints
  "esc:cmd;alt;ctrl" : S.op("hint"),
  
  // Grid
  "return:cmd;alt;ctrl" : S.op("grid")
  
});