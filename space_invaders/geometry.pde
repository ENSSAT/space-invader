/**
* Modelize a point...
*/
class Point{
	int x, y;
	
	Point(int x, int y) {
		this.x = x;
		this.y = y;
	}
	
	void translate(int dx, int dy) {
		this.x += dx;
		this.y += dy;
	}
	
	String toString() {
		return String.format("(Point : " + nf(x) + " " + nf(y) + ")");
	}
}


/**
*Concept modeling the bounds of an object.
*/
class Hitbox{
	Scene scene;
	int x0, y0, x1, y1;
	
	Hitbox(Scene scene, int x0, int y0, int x1, int y1) {
		this.scene = scene;
		this.x0 = x0;
		this.y0 = y0;
		this.x1 = x1;
		this.y1 = y1;
	}
	
	/**
	* Determine wether a point belong to this hitbox
	*/
	boolean contains(int x, int y) {
		return(x0 <= x) && (y0 <= y) && (x <= x1) && (y <= y1);
	}
	
	/**
	* Determines whether a move will make 
	* this hitbox go out of the screen.
	*/
	boolean canMove(int dx, int dy) {
		return 0 <= this.x0 + dx && this.x1 + dx <= this.scene.width
		 && 0 <= this.y0 + dy && this.y1 + dy <= this.scene.height;
	}
	
	/**
	* Translate the hitbox along x and y axis.
	* Return true if it moved, false otherwise.
	*/
	boolean move(int dx, int dy) {
		boolean moved = canMove(dx, dy);
		if (moved) {
			this.x0 += dx;
			this.y0 += dy;
			this.x1 += dx;
			this.y1 += dy;
		}
		return moved;
	}
	
	String toString() {
		return String.format("(Hitbox : " + nf(x0) + " " + nf(y0) + " " + nf(x1) + " " + nf(y1) + ")");
	}
}