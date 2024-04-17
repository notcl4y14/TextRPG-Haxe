package source.items;

class Apple extends Item {
	public function new () {
		super("Apple", "Heals +5HP; 1/10 chance to get +10HP bonus");
	}

	// //////////////

	override public function use (user: Entity) {
		user.heal(5);

		var bonus = Math.floor(Math.random() * 11);

		if (bonus == 1) {
			user.heal(10);
		}
	}
}