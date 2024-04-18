package source;

import sys.io.File;
import source.items.HurtPotion;
import source.items.Apple;

using StringTools;

class Main {
	static var prefix: String;
	static var player: Entity;

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
		message = message.replace("${player_name}", '${player.name}');
		message = message.replace("${player_name_uppercase}", '${player.name.toUpperCase()}');
		message = message.replace("${reset}", '${Colors.RESET}');
		message = message.replace("${yellow}", '${Colors.YELLOW}');
		
		log(message);
		
		// switch (rand) {
		// 	case 0:
		// 		logln('Hi, ${Colors.YELLOW}${name}${Colors.RESET}!');
		// 	case 1:
		// 		logln('Sup, ${Colors.YELLOW}${name}${Colors.RESET}!');
		// 	case 2:
		// 		logln('Yooooo, it\'s ${Colors.YELLOW}${name}${Colors.RESET}!');
		// 	case 3:
		// 		logln('${Colors.YELLOW}${name}${Colors.RESET} has joined the chat');
		// 	case 4:
		// 		logln('Meet the ${Colors.YELLOW}${name.toUpperCase()}${Colors.RESET}');
		// 		if (name.toUpperCase() == "MEDIC") {
		// 			logln("Dun, dun, du-duuuun!");
		// 		}
		// }

		write('\n');
		loop();
	}

	static public function loop () {
		log("");
		var input = Sys.stdin().readLine();
		var cmd = CommandInput.parseFromString(input);

		switch (cmd.name.toLowerCase()) {
			case "quit":
				logln("Are you sure? (Y/n)");
				log("");

				var input = Sys.stdin().readLine();
				var input_lc = input.toLowerCase();

				if (input_lc == "y") {
					Sys.exit(0);
				}
			
			case "stats":
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

				var str_healthRange = '${player.health}/${player.healthMax}';
				var str_healthPerc = '${healthPerc}%';
				var healthStr = 'Health: ' + healthColor + str_healthRange + Colors.RESET + " - " + healthColor + str_healthPerc + Colors.RESET;

				logln("STATS");
				logln("///////////////////");
				logln('Name: ${Colors.YELLOW}${player.name}${Colors.RESET}');
				logln(healthStr);
				logln('Inventory: ${Colors.BLUE}${player.invent.length}/${player.inventSize}${Colors.RESET} items');
				logln("///////////////////");
			
			case "invent":
				logln("INVENTORY");
				logln("///////////////////");
				for (i in 0...player.inventSize) {
					var item = player.invent[i];
					var name = item is Item ? item.name : "...";
					var str = !(item is Item) ? name : '${name}:\t${item.info}';
					logln('${i+1} - ${str}');
				}
				logln("///////////////////");
			
			case "use":
				if (cmd.args[0] == null) {
					logln("Type in the index of the item in your inventory");
					logln("(q or c to cancel)");
					log("");

					var input = Sys.stdin().readLine();
					var input_lc = input.toLowerCase();

					if (input_lc != "q" && input_lc != "c") {
						var input_n = Std.parseInt(input);

						if (input_n < 1 || input_n > player.inventSize) {
							logln('Index out of bounds! Only 1-${player.inventSize}');
						} else if (player.invent[input_n - 1] == null) {
							logln('The slot at index ${input_n} is empty');
						} else {
							player.invent[input_n - 1].use(player);
							player.invent.splice(input_n - 1, 1);
						}
					}
				} else {
					var input_n = Std.parseInt(cmd.args[0]);

					if (input_n < 1 || input_n > player.inventSize) {
						logln('Index out of bounds! Only 1-${player.inventSize}');
					} else if (player.invent[input_n - 1] == null) {
						logln('The slot at index ${input_n} is empty');
					} else {
						player.invent[input_n - 1].use(player);
						player.invent.splice(input_n - 1, 1);
					}
				}
			
			case "reload":
				loadAssets();
				logln("Reloaded assets");
		}

		loop();
	}
	
	// //////////////

	static public function loadAssets () {
		final file = File.getContent("assets/prefix.txt");
		prefix = file;
	}

	static public function main () {
		loadAssets();

		new Main();
	}
}