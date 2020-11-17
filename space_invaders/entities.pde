
/**
* Parent class of any game object.
*/
abstract class Drawable{
	Scene scene;
	Hitbox hitbox;
	Point center;
	
	Drawable(Scene scene, Hitbox hitbox, Point center) {
		this.scene = scene;
		this.hitbox = hitbox;
		this.center = center;
	}
	
	// called when object must be drawn
	abstract void draw();
	
	// called when object must be destroyed
	abstract void destroy();
	
	//
	boolean move(int dx, int dy) {
		return this.hitbox.move(dx, dy);
	}
}


abstract class Shot extends Drawable{
	Entity entity;
	Point center;
	int radius;
	int clr;
	int dy;
	
	Shot(Scene scene, Entity entity, Point center, int r, int clr, int dy) {
		// By default, shots are circles of radius r with a squared hitbox...
		super(scene, new Hitbox(scene, center.x - r, center.y - r, center.x + r, center.y + r), center);
		scene.addShot(this);
		// entity who initiated this shot
		this.entity = entity;
		// details of the munition
		this.center = center;
		this.radius = r;
		this.clr = clr;
		// velocity on y axis
		this.dy = dy;
	}
	
	void draw() {
		fill(this.clr);
		stroke(this.clr);
		circle(center.x, center.y, radius);
	}
	
	void destroy() {
		scene.removeShot(this);
		this.entity.onShotDestroyed();
	}
	
	/**
	* Return true if entity is hurt, false otherwise.
	* If hurt, entity loose a lifepoint!
	*/
	boolean hurt(Entity entity) {
		boolean isHurt = entity.hitbox.contains(center.x, center.y) && !entity.hasGroup(this.entity.group);
		return isHurt;
	}
	
	/**
	* Move the shot, or destroy it if it reached border.
	*/
	boolean move() {
		boolean move = super.move(0, dy);
		if (!move) this.destroy();
		return move;
	}
}


class Bullet extends Shot{
	Bullet(Scene scene, Entity entity, Point center, int dy) {
		super(scene, entity, center, LASER_RADIUS, COLOR_RED, dy);
	}
}


class Laser extends Shot{
	// keep track of initial coordinates of the shot
	Point initial;
	
	Laser(Scene scene, Entity entity, Point center, int dy) {
		super(scene, entity, center, LASER_RADIUS, COLOR_RED, dy);
		initial = new Point(center.x, center.y);
	}
	
	void draw() {
		super.draw();
		rect(center.x - radius, initial.y, 2 * radius, center.y - initial.y);
	}
}


abstract class Entity extends Drawable{
	// coordinates of the center
	int x, y, size;
	// coordinates of the hitbox
	int x0, y0, x1, y1;
	// texture of the entity
	PImage sprite;
	// scene containing this entity
	Scene scene;
	// defines a class of vulnerability
	int group;
	// reference shot of this entity
	Shot shotInstance = null;
	
	Entity(Scene scene, int group, int x, int y, int size, PImage sprite) {
		this.scene = scene;
		this.group = group;
		
		this.x = x;
		this.y = y;
		this.size = size;
		
		int half = int(size / 2);
		this.x0 = x - half;
		this.y0 = y - half;
		this.x1 = x + half;
		this.y1 = y + half;
		
		this.sprite = sprite;
		this.sprite.resize(size, size);
	}
	
	abstract void destroy();
	
	abstract void shot();
	
	boolean canShot() {
		return this.shotInstance == null;
	}
	
	void onShotDestroyed() {
		this.shotInstance = null;
	}
	
	boolean hasGroup(int group) {
		return this.group == group;
	}
	
	void move(int dx, int dy) {
		this.x += dx;
		this.y += dy;
		this.x0 += dx;
		this.x1 += dx;
		this.y0 += dy;
		this.y1 += dy;
	}
	
	boolean canMove(int dx) {
		return this.x0 + dx > 0 && this.x1 + dx < this.scene.width;
	}
	
	boolean contains(int x, int y) {
		return this.x0 <= x && this.x1 >= x && this.y0 <= y && this.y1 >= y;
	}
	
	void draw() {
		image(this.sprite, this.x0, this.y0);
	}
}


class Player extends Entity{
	Player(Scene scene) {
		super(
			scene,
			GROUP_PLAYER,
			int(scene.width / 2), 
			scene.height - int(scene.getPlayerSize() / 2),
			scene.getPlayerSize(),
			loadImage("player.png")
			);
		scene.add(this);
	}
	
	void destroy() {
		// nothing append when player is destroyed
	}
	
	void shot() {
		if (this.canShot()) {
			this.shotInstance = new Laser(
				scene, 
				this, 
				this.x, 
				this.scene.earth.earthOffset + int(0.2 * this.size), 
				 - 	8);
		}
	}
	
	void move(int dx) {
		// prevent player from moving out of the scene
		if (super.canMove(dx)) {
			super.move(dx, 0);
		}
	}
}

class Invader extends Entity{  
	Invader(Scene scene, int col, int row, int size, PImage sprite) {
		super(//new Shot(scene, GROUP_INVADERS, 500, 50, 2);
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
		// nothing append when player is destroyed
		this.scene.removeInvader(this);
	}
	
	void shot() {
		if (this.canShot()) {
			this.shotInstance = new Shot(
				scene, 
				this, 
				this.x, 
				this.y - int(0.2 * this.size), 
				2);
		}
	}
	
	boolean earthReached() {
		return this.y1 > this.scene.earth.earthOffset;
	}
}
