package source;

class Item {
	public var name: String;
	public var info: String;

	public function new (name: String, info: String) {
		this.name = name;
		this.info = info;
	}

	// //////////////

	public function use (user: Entity, target: Any) {
		Sys.println('WARNING: Item ID "${name}"\'s use() method is unitialized');
	}
}