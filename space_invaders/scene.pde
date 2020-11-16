
class Earth extends Drawable{
	int earthOffset;
	PImage img;
	
	Earth(Scene scene) {
		img = loadImage("earth.jpg");
		img.resize(scene.width, int(scene.width * img.height / img.width));
		earthOffset = scene.height - img.height;
	}
	
	void draw() {
		image(img, 0, earthOffset);
	}
}


class Scene extends Drawable{
	int width, height;
	ArrayList<Drawable> items;
	PImage earth;
	
	Scene(int width, int height) {
		this.width = width;
		this.height = height;
		items = new ArrayList();
		this.add(new Earth(this));
	}
	
	int getPlayerSize() {
		// TODO: put aspect ratio here
		return int(0.125 * this.width);
	}
	
	/**
	* Add a drawable object to the scene.
	**/
	void add(Drawable item) {
		items.add(item);
	}
	
	/**
	* individually draw each element of the scene
	*/
	void draw() {
		background(0);
		for (int i = 0; i < items.size(); i++) {
			items.get(i).draw();
		}
	}
}
