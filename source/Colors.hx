package source;

// https://git.team-prism.rocks/FryingPan/godot-manager/-/blob/master/src/ANSI.hx
enum abstract Colors(String) from String to String {
	var BLACK = '\x1b[30m';
	var RED = '\x1b[31m';
	var GREEN = '\x1b[32m';
	var YELLOW = '\x1b[33m';
	var BLUE = '\x1b[34m';
	var MAGENTA = '\x1b[35m';
	var CYAN = '\x1b[36m';
	var GRAY = '\x1b[37m';
	var GREY = '\x1b[37m';
 
	var BLACK_BG = '\x1b[40m';
	var RED_BG = '\x1b[41m';
	var GREEN_BG = '\x1b[42m';
	var YELLOW_BG = '\x1b[43m';
	var BLUE_BG = '\x1b[44m';
	var MAGENTA_BG = '\x1b[45m';
	var CYAN_BG = '\x1b[46m';
	var GRAY_BG = '\x1b[47m';
	var GREY_BG = '\x1b[47m';
 
	var RESET = '\x1b[0m';
 
	var BOLD = '\x1b[1m';
	var FAINT = '\x1b[2m';
	var NORMAL_WEIGHT = '\x1b[22m';
 
	var UNDERLINED = '\x1b[4m';
	var NOT_UNDERLINED = '\x1b[24m';
 
	var INVERTED = '\x1b[7m';
	var NOT_INVERTED = '\x1b[27m';
 }
 