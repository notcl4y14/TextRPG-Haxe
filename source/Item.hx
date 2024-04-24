package source;

class Item {
	public var name: String;
	public var info: String;

	public var consumable: Bool;

	public function new (name: String, info: String, consumable: Bool) {
		this.name = name;
		this.info = info;
		
		this.consumable = consumable;
	}

	// //////////////

	public function use (user: Entity, target: Any) {
		Sys.println('WARNING: Item ID "${name}"\'s use() method is unitialized');
	}
}