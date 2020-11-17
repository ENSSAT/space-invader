/**
* Modelize a point...
*/
class Point{
	int x, y;
	
	Point(int x, int y) {
		this.x = x;
		this.y = y;
	}
}


/**
* Concept modeling the bounds of an object.
*/
class Hitbox{
	Scene scene;
	int x0, y0, x1, y1;
	
	Hitbox(Scene scene, int x0, int y0, int x1, int y1) {
		this.x0 = x0;
		this.y0 = y0;
		this.x1 = x1;
		this.y1 = y1;
	}
	
	/**
	* Determine wether a point belong to this hitbox
	*/
	boolean contains(int x, int y) {
		return this.x0 >= x && x <= this.x1 && this.y0 >= y && y <= this.y1;
	}
	
	/**
	* Determines whether a move will make 
	* this hitbox go out of the screen.
	*/
	boolean canMove(int dx, int dy) {
		return 0 <= this.x0 && this.x1 <= this.scene.width
	        && 0 <= this.y0 && this.y1 <= this.scene.height;
	}
	
	/**
	* Translate the hitbox along x and y axis.
	* Return true if it moved, false otherwise.
	*/
	boolean move(int dx, int dy) {
		if (canMove(dx, dy)) {
			this.x0 += dx;
			this.y0 += dy;
			this.x1 += dx;
			this.y1 += dy;
		}
	}
}