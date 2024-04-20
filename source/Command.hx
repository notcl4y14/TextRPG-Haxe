package source;

import haxe.Constraints.Function;

class Command {
	public var name: String;
	public var alias: Array<String>;
	public var action: Function;
	
	public function new (name: String, alias: Array<String>, action: Function) {
		this.name = name;
		this.alias = alias;
		this.action = action;
	}
	
	// //////////////

	public function matches (name: String): Bool {
		if (name == this.name || this.alias.contains(name)) {
			return true;
		}

		return false;
	}
}