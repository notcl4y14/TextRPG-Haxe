package source;

class Entity {
	public var name: String;
	public var health: Float;
	public var healthMax: Float;
	public var invent: Array<Item>;
	public var inventSize: Int;
	
	public var destroyWhenDead: Bool;
	public var healthPercent (get, set): Float;

	public var gameParent: Game;

	// //////////////

	public function new (name: String, health: Float, healthMax: Float, inventSize: Int, gameParent: Game) {
		this.name = name;
		this.health = health;
		this.healthMax = healthMax;
		this.invent = [];
		this.inventSize = inventSize;

		this.destroyWhenDead = false;

		this.gameParent = gameParent;
	}

	// //////////////
	
	public function get_healthPercent () {
		return this.health / this.healthMax * 100;
	}
	
	public function set_healthPercent (v:Float) {
		return this.health = v * this.healthMax / 100;
	}

	// //////////////

	public function onDead () {}

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
		
		if (this.health < 0) {
			this.health = 0;

			if (!quiet) {
				gameParent.logln('${name} is ded!');
			}

			this.onDead();

			if (destroyWhenDead) {
				var index = gameParent.enemies.indexOf(this);
				gameParent.enemies.splice( index, 1 );
			}
		}

		else if (this.health > this.healthMax) {
			this.health = this.healthMax;
			if (!quiet) {
				gameParent.logln('${name} Max HP!');
			}
		}
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