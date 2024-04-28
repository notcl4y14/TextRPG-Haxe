package source.items;

class Sword extends Item {
	public function new () {
		super("Sword", "Damage: 10-20HP", false, true);
	}

	// //////////////

	override public function use (user: Entity, target: Any, quiet: Bool = false) {
		var gameParent = user.gameParent;
		var target: Entity = cast (target, Entity);
		var dmg = Math.floor(Math.random() * (20 - 10) + 10);

		var userName = '${Colors.YELLOW}${user.name}${Colors.RESET}';
		var targetName = '${Colors.YELLOW}${target.name}${Colors.RESET}';

		if (!quiet) {
			var dmg = '${Colors.BLUE}${dmg}${Colors.RESET}';
			var name = '${Colors.GREEN}${this.name}${Colors.RESET}';

			gameParent.logln('${userName} attacks ${targetName} with ${name}!');
			gameParent.logln('${userName} deals ${dmg} damage!');
		}

		target.heal(dmg * -1, false, true);

		if (!quiet) {
			if (user.health <= 0) {
				gameParent.logln('${userName} is ded!');
			}

			if (target.health <= 0) {
				gameParent.logln('${targetName} is ded!');
			}
		}
	}
}