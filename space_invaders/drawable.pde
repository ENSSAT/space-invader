/**
* Parent class of anything that has a draw() method
*/
abstract class Drawable{
	// called when object must be drawn
	abstract void draw();
	
	/**
	* Implement if required... called when object must be destroyed
	*/
	void destroy() {}
}

/**
* Parent class of any game object.
*/
abstract class Moveable extends Drawable{
	Scene scene;
	Hitbox hitbox;
	Point center;
	
	Moveable(Scene scene, Hitbox hitbox, Point center) {
		this.scene = scene;
		this.hitbox = hitbox;
		this.center = center;
	}
	
	/**
	* try to move hitbox and coordinates and return boolean
	* that indicates wether it worked!
	*/
	boolean move(int dx, int dy) {
		boolean moved = this.hitbox.move(dx, dy);
		if (moved) this.center.translate(dx, dy);
		return moved;
	}
	
	boolean canMove(int dx, int dy) {
		return this.hitbox.canMove(dx, dy);
	}
}
