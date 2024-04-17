package source;

class Item {
	public var name: String;

	public function new (name: String) {
		this.name = name;
	}

	// //////////////

	public function use (user: Entity) {
		Sys.println('WARNING: Item ID "${name}"\'s use() method is unitialized');
	}
}