
// meta variables
String PLAYER_IMAGE = "player.png";
String EARTH_IMAGE = "earth.jpg";

abstract class Drawable{
	abstract void draw();
}

class Player extends Drawable{
	int x, y, size;
	PImage img;
	
	Player(int x, int y, int size) {
		this.x = x;
		this.y = y;
		this.size = size;
		this.img = loadImage(PLAYER_IMAGE);
		this.img.resize(size, size);
	}
	
	void move(int dx) {
		this.x += dx; 
	}
	
	void draw() {
		image(this.img, int(x - this.size / 2), y);
	}
}

class Scene extends Drawable{
	int canvasWidth, canvasHeight;
	PImage earthImage;
	int earthAspectRatio, earthOffset;
	Player player;
	
	Scene(int width, int height) {
		canvasWidth = width;
		canvasHeight = height;
		earthImage = loadImage(EARTH_IMAGE);
		earthAspectRatio = earthImage.height / earthImage.width;
		earthImage.resize(width, int(height * earthAspectRatio));
		earthOffset = canvasHeight - earthImage.height;
		player = new Player(int(canvasWidth / 2), earthOffset, earthImage.height);
	}
	
	Player getPlayer() {
		return this.player;
	}
	
	void draw() {
		// set black background image for space
		background(0);
		// draw earth
		image(this.earthImage, 0, this.earthOffset);
		// draw player on earth
		player.draw();
	}
}

// global game configuration
Scene scene;
Player player;

void settings() {
	scene = new Scene(500, 500);
	player = scene.getPlayer();
	size(scene.canvasWidth, scene.canvasHeight);
}

void draw() {
	//player.x += 1;
	scene.draw();
}

void keyPressed() {
	if (key == LEFT) {
		println("move left");
	}
}
