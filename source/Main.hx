package source;

class Main {
	static var prefix: String;
	static var name: String;

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
		name = Sys.stdin().readLine();
		write('\n');

		var rand: Int = Math.floor(Math.random() * 5);
		switch (rand) {
			case 0:
				logln('Hi, ${name}!');
			case 1:
				logln('Sup, ${name}!');
			case 2:
				logln('Yooooo, it\'s ${name}!');
			case 3:
				logln('${name} has joined the chat');
			case 4:
				logln('Meet the ${name.toUpperCase()}');
				if (name.toUpperCase() == "MEDIC") {
					logln("Dun, dun, du-duuuun!");
				}
		}

		write('\n');
		loop();
	}

	static public function loop () {
		log("");
		var input = Sys.stdin().readLine();
		var input_lc = input.toLowerCase();

		switch (input_lc) {
			case "quit":
				logln("Are you sure? (Y/n)");
				log("");

				var input = Sys.stdin().readLine();
				var input_lc = input.toLowerCase();

				if (input_lc == "y") {
					Sys.exit(0);
				}
		}

		loop();
	}
	
	// //////////////

	static public function main () {
		prefix = "> ";
		new Main();
	}
}