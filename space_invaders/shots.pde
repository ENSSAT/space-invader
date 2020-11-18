abstract class Shot extends Moveable{
	Entity entity;
	Point center;
	int radius;
	int clr;
	int dy;
	
	boolean destroyed;
	
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
		boolean destroyed = false;
	}
	
	void draw() {
		fill(this.clr);
		stroke(this.clr);
		circle(center.x, center.y, radius);
	}
	
	void destroy() {
		if (!destroyed) {
			scene.removeShot(this);
			this.entity.onShotDestroyed();
		    this.destroyed = true;
		}
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
	Bullet(Scene scene, Entity entity, Point center, int direction) {
		super(scene, entity, center, LASER_RADIUS, scene.theme.getColor("bullet"), direction * BULLET_VELOCITY);
	}
}


class Laser extends Shot{
	// keep track of initial coordinates of the shot
	Point initial;
	
	Laser(Scene scene, Entity entity, Point center, int direction) {
		super(scene, entity, center, LASER_RADIUS, scene.theme.getColor("laser"), direction * LASER_VELOCITY);
		initial = new Point(center.x, center.y);
	}
	
	void draw() {
		super.draw();
		rect(center.x - radius, initial.y, 2 * radius, center.y - initial.y);
	}
}
