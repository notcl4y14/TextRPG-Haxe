package source.entities;

class Skeleton extends Entity {
	public function new (game: Game) {
		super ("Skeleton", 100, 100, 0, game);

		this.destroyWhenDead = true;
	}
}