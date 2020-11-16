
abstract class Drawable{
	abstract void draw();
}


class Shot extends Drawable{
	// initial coordinates
	int y0, dy;
	// actual coordinates
	int x, y1;
	//
	Scene scene;
	
	Shot(Scene scene, int x, int y, int dy) {
		this.x = x;
		this.y0 = y;
		this.y1 = y;
		this.dy = dy;
		this.scene = scene;
	}
	
	boolean move() {
		// return true if it moved, false otherwise
		boolean move = this.canMove();
		if (move) {
			y1 += dy;
		} else {
			scene.remove(this);
		}
		return move;
	}
	
	boolean canMove() {
		return y1 > 0 && y1 < scene.height;
	}
	
	void draw() {
		int clr = 0xFFFF0000;
		fill(clr);
		stroke(clr);
		strokeWeight(4);
		circle(x, y1, 15);
	}
}


class Laser extends Shot{
	Laser(Scene scene, int x, int y, int dy) {
		super(scene, x, y, dy);
	}
	void draw() {
		int clr = 0xFFFF0000;
		fill(clr);
		stroke(clr);
		strokeWeight(4);
		rect(x - 7, y0, 15, y1 - y0);
		circle(x, y1, 15);
	}
}


class Entity extends Drawable{
	// coordinates of the center
	int x, y, size;
	// coordinates of the hitbox
	int x0, y0, x1, y1;
	// texture of the entity
	PImage sprite;
	// scene containing this entity
	Scene scene;
	
	Entity(Scene scene, int x, int y, int size, PImage sprite) {
		this.scene = scene;
		this.scene.add(this);
		
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
			int(scene.width / 2), 
			scene.height - int(scene.getPlayerSize() / 2),
			scene.getPlayerSize(),
			loadImage("player.png")
			);
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
		super(
			scene,
			int((col + 0.5) * size),
			int((row + 0.5) * size),
			size,
			sprite
			);
	}
	
	boolean earthReached() {
		return this.y1 > this.scene.earth.earthOffset;
	}
}