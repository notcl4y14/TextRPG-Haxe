package source;

import source.items.*;
import sys.io.File;

using StringTools;

class Game {
	public var prefix: String;
	public var prefixInput: String;
	public var player: Entity;
	public var enemies: Array<Entity> = [];
	public var commands: Array<Command>;

	public var lastInput: String;

	// //////////////

	public function new () {
		this.loadAssets();
		this.loadCommands();

		this.init();
		this.loop();
	}

	// //////////////

	public function log (...value: String) {
		for (s in value) {
			Sys.print('${this.prefix}${s}');
		}
	}
	
	public function logln (...value: String) {
		for (s in value) {
			Sys.print('${this.prefix}${s}\n');
		}
	}

	public function write (...value: String) {
		for (s in value) {
			Sys.print(s);
		}
	}

	public function input () {
		var prefixInput: String = this.prefixInput;
		prefixInput = format(prefixInput);
		
		write(prefixInput);
		var input = Sys.stdin().readLine();

		return input;
	}

	// //////////////

	public function loadAssets () {
		var file = File.getContent("assets/prefix.txt");
		this.prefix = file;

		file = File.getContent("assets/prefix_input.txt");
		this.prefixInput = file;
	}

	public function loadCommands () {
		commands = [];
		
		commands.push( new Command ("help", ["commands"], (user: Entity, args: Array<String>) -> {
			var str1: String = 'Text RPG\n\tMade by notcl4y14\n\thttps://github.com/notcl4y14/TextRPG\n\tMade in Haxe: https://haxe.org/\n';
			var str2: String = 'Commands:\n\thelp (commands) - Shows this list\n\tquit (q) - Quits the game (requires confirmation)\n\tstats - Shows player\'s stats\n\tinventory (inv, invent, items, backpack) - Shows a list of items the player has\n\tuse (item) [index] - Uses an item at a given index in the inventory\n\treload - Reloads the assets';

			var spaces: String = "";
			for ( char in prefix.split("") ) {
				if (char == "\n") {
					break;
				}
				
				spaces += " ";
			}

			str1 = str1.replace('\t', spaces);
			str2 = str2.replace('\t', spaces);
			
			logln(str1);
			logln(str2);
		}) );

		commands.push( new Command ("quit", ["q"], (user: Entity, args: Array<String>) -> {
			logln("Are you sure? (Y/n)");
			log("");

			var input = Sys.stdin().readLine();
			var input_lc = input.toLowerCase();

			if (input_lc == "y") {
				Sys.exit(0);
			} else if (input_lc == "nuh uh" || input_lc == "nuh-uh") {
				logln("THE HECK DO YOU MEAN NUH-UH!?");
			}
		}) );

		commands.push( new Command ("stats", [], (user: Entity, args: Array<String>) -> {
			var healthPerc: Float = (user.health / user.healthMax) * 100;
			var healthColor: String = getHealthColor();

			var str_healthRange = '${user.health}/${user.healthMax}';
			var str_healthPerc = '${healthPerc}%';

			var nameStr = 'Name: ${Colors.YELLOW}${user.name}${Colors.RESET}';
			var healthStr = 'Health: ' + healthColor + str_healthRange + Colors.RESET + " - " + healthColor + str_healthPerc + Colors.RESET;
			var invStr = 'Inventory: ${Colors.BLUE}${user.invent.length}/${user.inventSize}${Colors.RESET} items';

			logln("STATS");
			logln("///////////////////");
			logln(nameStr);
			logln(healthStr);
			logln(invStr);
			logln("///////////////////");
		}) );

		commands.push( new Command ("inventory", ["inv", "invent", "backpack", "items"], (user: Entity, args: Array<String>) -> {
			logln("INVENTORY");
			logln("///////////////////");

			for ( i in 0...user.inventSize ) {

				var item = user.invent[i];
				var name = item is Item ? item.name : "...";
				var str = !(item is Item) ? name : '${name}:\t${item.info}';

				logln('${i+1} - ${str}');

			}

			logln("///////////////////");
		}) );

		commands.push( new Command ("use", ["item"], (user: Entity, args: Array<String>) -> {
			var input_n: Int = null;

			// No args
			if (args[0] == null) {
				logln("Type in the index of the item in your inventory");
				logln("(q or c to cancel)");
				log("");

				var input = Sys.stdin().readLine();
				var input_lc = input.toLowerCase();

				if (input_lc == "q" || input_lc == "c") {
					return;
				}
				
				input_n = Std.parseInt(input);
			}
			
			// First item with a given name
			else if (args[0] is String) {

				for ( i in 0...player.invent.length ) {

					var item = player.invent[i];

					if (item.name.toLowerCase() == args[0].toLowerCase()) {
						input_n = i + 1;
					}

				}

			}

			// Default
			if (input_n == null) {
				input_n = Std.parseInt(args[0]);
			}

			var index = input_n == null ? null : input_n - 1;
			var item = index == null ? null : player.invent[index];
			var targetIndex: Int = Std.parseInt(args[1]) == null ? null : Std.parseInt(args[1]) - 1;
			var target: Entity = Std.parseInt(args[1]) == null ? player : enemies[targetIndex];

			if (item == null) {
				logln('Unknown item index given');
				return;
			}

			if (target == null) {
				logln('Unknown target at index ${targetIndex + 1}');
				return;
			}

			if (input_n < 1 || input_n > player.inventSize) {
				logln('Index out of bounds! Only 1-${player.inventSize}');
				return;
			} else if (item == null) {
				logln('The slot at index ${input_n} is empty');
				return;
			}

			item.use(player, target);

			if (item.consumable) {
				player.invent.splice(index, 1);
			}
		}) );

		commands.push( new Command ("enemies", [], (user: Entity, args: Array<String>) -> {

			for ( i in 0...enemies.length ) {
				
				var enemy = enemies[i];
				logln('${i + 1}. ${enemy.name}: ${enemy.health}/${enemy.healthMax} - ${enemy.healthPercent}%');

			}

		}) );

		commands.push( new Command ("last", ["l"], (user: Entity, args: Array<String>) -> {
			if (lastInput == null) return;
			var cmd = CommandInput.parseFromString(lastInput);
			
			for ( batch in commands ) {
				if ( batch.matches( cmd.name.toLowerCase() ) ) {
					batch.action (player, cmd.args);
				}
			}
		}) );

		commands.push( new Command ("reload", [], (user: Entity, args: Array<String>) -> {
			loadAssets();
			logln("Reloaded assets");
		}) );
	}

	// //////////////

	public function getHealthColor () {
		var healthPerc: Float = (player.health / player.healthMax) * 100;
		var healthColor: String = "";

		if (healthPerc < 20) {
			healthColor = Colors.RED;
		} else if (healthPerc <= 50) {
			healthColor = Colors.YELLOW;
		} else if (healthPerc <= 100) {
			healthColor = Colors.GREEN;
		} else if (healthPerc > 100) {
			healthColor = Colors.BLUE;
		}

		return healthColor;
	}

	public function format (str: String) {
		var str: String = str;
		// Variables
		str = str.replace("${player_name}", '${player.name}');
		str = str.replace("${player_name_uppercase}", '${player.name.toUpperCase()}');
		str = str.replace("${player_name_lowercase}", '${player.name.toLowerCase()}');
		str = str.replace("${player_health}", '${player.health}');
		str = str.replace("${player_healthMax}", '${player.healthMax}');
		// Colors
		str = str.replace("${health_color}", getHealthColor());
		str = str.replace("${reset}", '${Colors.RESET}');
		str = str.replace("${black}", '${Colors.BLACK}');
		str = str.replace("${red}", '${Colors.RED}');
		str = str.replace("${green}", '${Colors.GREEN}');
		str = str.replace("${yellow}", '${Colors.YELLOW}');
		str = str.replace("${blue}", '${Colors.BLUE}');
		str = str.replace("${magenta}", '${Colors.MAGENTA}');
		str = str.replace("${cyan}", '${Colors.CYAN}');
		str = str.replace("${gray}", '${Colors.GRAY}');
		return str;
	}

	// //////////////
	
	public function init () {
		var name: String;
		logln("Text RPG :P");
		log("Username: ");
		name = Sys.stdin().readLine();
		write('\n');

		player = new Entity(name, 125, 125, 10, this);
		player.pickup(new Apple(), true);
		player.pickup(new Apple(), true);
		player.pickup(new Apple(), true);
		player.pickup(new Apple(), true);
		player.pickup(new HurtPotion(), true);
		player.pickup(new HurtPotion(), true);
		player.pickup(new HurtPotion(), true);
		player.pickup(new HurtPotion(), true);
		player.pickup(new HealthPotion(), true);
		player.pickup(new Sword(), true);

		enemies.push( new Entity("Enemy", 125, 125, 10, this) );
		enemies[0].destroyWhenDead = true;

		var messages = File.getContent("assets/welcomeMessages.txt");
		var lines: Array<String> = [];
		var line: String = "";

		for (char in messages.split("")) {
			line += char;

			if (char == "\n") {
				lines.push(line);
				line = "";
			}
		}

		lines.push(line);

		var rand: Int = Math.floor(Math.random() * lines.length);
		var message = lines[rand];
		message = format(message);
		
		log(message);

		write('\n');
	}

	// //////////////
	
	public function loop () {
		var input = input();
		var cmd = CommandInput.parseFromString(input);

		for ( batch in commands ) {
			if ( batch.matches( cmd.name.toLowerCase() ) ) {
				batch.action (player, cmd.args);
			}
		}

		if (cmd.name != "last")
			lastInput = input;

		loop();
	}
}