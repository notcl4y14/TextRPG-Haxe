package source;

class CommandInput {
	public var name: String;
	public var args: Array<String>;

	public function new (name: String, args: Array<String>) {
		this.name = name;
		this.args = args;
	}

	// //////////////

	static public function parseFromString (inp: String) {
		var split = inp.split(" ");

		var name = split[0];
		var args = [];

		for (i in 1...split.length) {
			args.push( split[i] );
		}

		return new CommandInput(name, args);
	}
}