package source.items;

class HurtPotion extends Item {
	public function new () {
		super("HurtPotion", "Hurts -15HP; 1/4 chance bonus -10HP", true);
	}

	// //////////////

	override public function use (user: Entity, target: Any, quiet: Bool = false) {
		var target: Entity = cast (target, Entity);
		target.heal(-15, false, quiet);

		var bonus = Math.floor(Math.random() * 5);

		if (bonus == 1) {
			target.heal(-10, false, quiet);
		}
	}
}