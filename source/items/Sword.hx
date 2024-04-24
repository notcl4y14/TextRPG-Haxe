package source.items;

class Sword extends Item {
	public function new () {
		super("Sword", "Damage: 10-20HP", false);
	}

	// //////////////

	override public function use (user: Entity, target: Any) {
		var target: Entity = cast (target, Entity);
		var dmg = Math.floor(Math.random() * (20 - 10) + 10);

		target.heal(dmg * -1);
	}
}