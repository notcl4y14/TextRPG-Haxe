package source;

class Item {
	public var name: String;
	public var info: String;

	public var consumable: Bool;
	public var turnChanging: Bool;

	public function new (name: String, info: String, consumable: Bool, turnChanging: Bool = false) {
		this.name = name;
		this.info = info;
		
		this.consumable = consumable;
		this.turnChanging = turnChanging;
	}

	// //////////////

	public function use (user: Entity, target: Any, quiet: Bool = false) {
		Sys.println('WARNING: Item ID "${name}"\'s use() method is unitialized');
	}
}