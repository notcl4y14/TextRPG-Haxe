package source;

class Entity {
	public var name: String;
	public var health: Float;
	public var healthMax: Float;
	public var invent: Array<Item>;
	public var inventSize: Int;

	public var gameParent: Game;

	// //////////////

	public function new (name: String, health: Float, healthMax: Float, inventSize: Int, gameParent: Game) {
		this.name = name;
		this.health = health;
		this.healthMax = healthMax;
		this.invent = [];
		this.inventSize = inventSize;

		this.gameParent = gameParent;
	}

	// //////////////

	public function heal (v: Float, quiet: Bool = false) {
		this.health += v;

		if (!quiet) {
			if (v < 0) {
				gameParent.logln('${name} ${v}HP');
			} else {
				gameParent.logln('${name} +${v}HP!');
			}
		}
		
		if (this.health < 0) this.health = 0;
		else if (this.health > this.healthMax) this.health = this.healthMax;
	}

	public function pickup (item: Item, quiet: Bool = false) {
		if (this.invent.length > this.inventSize) {
			if (!quiet) {
				gameParent.logln('Inventory full!');
			}
			
			return;
		}
		
		this.invent.push(item);

		if (!quiet) {
			gameParent.logln('You picked ${item.name} up');
		}
	}
}