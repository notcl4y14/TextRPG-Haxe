package source.items;

class HurtPotion extends Item {
	public function new () {
		super("HurtPotion", "Hurts -15HP; 1/4 chance bonus -10HP");
	}

	// //////////////

	override public function use (user: Entity) {
		user.heal(-15);

		var bonus = Math.floor(Math.random() * 5);

		if (bonus == 1) {
			user.heal(-10);
		}
	}
}