package source.items;

class HealthPotion extends Item {
	public function new () {
		super("HealthPotion", "Heals +10HP; Can overheal; 1/2 chance bonus +10HP", true);
	}

	// //////////////

	override public function use (user: Entity, target: Any) {
		var target: Entity = cast (target, Entity);
		target.heal(10, true);

		var bonus = Math.floor(Math.random() * 3);

		if (bonus == 1) {
			target.heal(10, true);
		}
	}
}