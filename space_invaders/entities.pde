
abstract class Entity extends Moveable{
	int group;
	int size;
	PImage sprite;
	
	boolean isAlive = true;
	Shot shotInstance = null;
	
	Entity(Scene scene, int group, int x, int y, int size, PImage sprite) {
		super(
			scene, 
			new Hitbox(
			scene,
			x - int(size / 2),
			y - int(size / 2),
			x + int(size / 2),
			y + int(size / 2)
			), 
			new Point(x, y)
			);
		
		this.group = group;
		this.size = size;
		this.sprite = sprite;
		this.sprite.resize(size, size);
	}
	
	void draw() {
		image(this.sprite, this.hitbox.x0, this.hitbox.y0);
	}
	
	abstract void destroy();
	
	void shot(Shot shotInstance) {
		if (this.canShot()) {
			this.shotInstance = shotInstance;
		} else{
			shotInstance.destroy();
		}
	}
	
	boolean canMove(int dx) {
		return super.canMove(dx, 0) && this.isAlive;
	}
	
	boolean canShot() {
		return this.shotInstance == null && this.isAlive;
	}
	
	void onShotDestroyed() {
		this.shotInstance = null;
	}
	
	boolean hasGroup(int group) {
		return this.group == group;
	}
}


class Player extends Entity{
	Player(Scene scene, PImage sprite) {
		super(
			scene,
			GROUP_PLAYER,
			int(scene.width / 2), 
			scene.height - int(scene.getPlayerSize() / 2),
			scene.getPlayerSize(),
			sprite
			);
		scene.add(this);
	}
	
	void destroy() {
		// nothing append when player is destroyed
	}
	
	boolean move(int dx) {
		return super.move(dx, 0);
	}
	
	void shot() {
		super.shot(
			new Laser(
			scene, 
			this, 
			new Point(
			this.center.x,
			this.scene.earth.earthOffset + int(0.2 * this.size)
			), 
			DIRECTION_UP
			)
			);
	}
}

int INVADERS_SIMULTANEOUS_SHOTS = 0;

class Invader extends Entity{	
	Invader(Scene scene, int col, int row, int size, PImage sprite) {
		super(
			scene,
			GROUP_INVADERS,
			int((col + 0.5) * size),
			int((row + 0.5) * size),
			size,
			sprite
			);
		scene.addInvader(this);
	}
	
	void destroy() {
		this.scene.removeInvader(this);
	}
	
	void onShotDestroyed() {
		super.onShotDestroyed();
		INVADERS_SIMULTANEOUS_SHOTS -= 1;
	}
	
	void shot() {
		super.shot(			
			new Bullet(
			scene, 
			this,
			new Point(
			this.center.x, 
			this.hitbox.y1
			),
			DIRECTION_DOWN)
			);
		INVADERS_SIMULTANEOUS_SHOTS += 1;
	}
	
	boolean earthReached() {
		return this.hitbox.y1 > this.scene.earth.earthOffset;
	}
}
