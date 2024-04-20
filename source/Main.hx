package source;

import sys.io.File;
import source.items.HurtPotion;
import source.items.Apple;

using StringTools;

class Main {
	static var prefix: String;
	static var prefix_input: String;
	static var player: Entity;
	static var commands: Array<Command>;

	// //////////////

	public function new () {
		logln("Text RPG :P");
		log("Username: ");
		var name = Sys.stdin().readLine();
		write('\n');

		player = new Entity(name, 125, 125, 10);
		player.pickup(new Apple(), true);
		player.pickup(new Apple(), true);
		player.pickup(new Apple(), true);
		player.pickup(new Apple(), true);
		player.pickup(new HurtPotion(), true);
		player.pickup(new HurtPotion(), true);
		player.pickup(new HurtPotion(), true);
		player.pickup(new HurtPotion(), true);

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
		loop();
	}

	// //////////////

	static public function log (...value: String) {
		for (s in value) {
			Sys.print('${prefix}${s}');
		}
	}
	
	static public function logln (...value: String) {
		for (s in value) {
			Sys.print('${prefix}${s}\n');
		}
	}

	static public function write (...value: String) {
		for (s in value) {
			Sys.print(s);
		}
	}

	static public function input () {
		var prefix_input: String = prefix_input;
		prefix_input = format(prefix_input);
		
		write(prefix_input);
		var input = Sys.stdin().readLine();
		return input;
	}

	// //////////////

	static public function loop () {
		var input = input();
		var cmd = CommandInput.parseFromString(input);

		for ( batch in commands ) {
			if ( batch.matches( cmd.name.toLowerCase() ) ) {
				batch.action (player, cmd.args);
			}
		}

		loop();
	}

	// //////////////

	static public function getHealthColor () {
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

	static public function format (str: String) {
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

	static public function loadAssets () {
		var file = File.getContent("assets/prefix.txt");
		prefix = file;

		file = File.getContent("assets/prefix_input.txt");
		prefix_input = file;
	}

	static public function loadCommands () {
		commands = [];

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
			var healthStr = 'Health: ' + healthColor + str_healthRange + Colors.RESET + " - " + healthColor + str_healthPerc + Colors.RESET;

			logln("STATS");
			logln("///////////////////");
			logln('Name: ${Colors.YELLOW}${user.name}${Colors.RESET}');
			logln(healthStr);
			logln('Inventory: ${Colors.BLUE}${user.invent.length}/${user.inventSize}${Colors.RESET} items');
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

			if (args[0] == null) {
				logln("Type in the index of the item in your inventory");
				logln("(q or c to cancel)");
				log("");

				var input = Sys.stdin().readLine();
				var input_lc = input.toLowerCase();

				if (input_lc != "q" && input_lc != "c") {
					input_n = Std.parseInt(input);
				}
			}

			if (input_n == null) {
				input_n = Std.parseInt(args[0]);
			}

			var index = input_n - 1;

			if (input_n < 1 || input_n > player.inventSize) {
				logln('Index out of bounds! Only 1-${player.inventSize}');
				return;
			} else if (player.invent[index] == null) {
				logln('The slot at index ${input_n} is empty');
				return;
			}

			player.invent[index].use(player, player);
			player.invent.splice(index, 1);
		}) );

		commands.push( new Command ("reload", [], (user: Entity, args: Array<String>) -> {
			loadAssets();
			logln("Reloaded assets");
		}) );
	}

	static public function main () {
		loadAssets();
		loadCommands();

		new Main();
	}
}