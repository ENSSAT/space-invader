// meta variables
String PLAYER_IMAGE = "player.png";
String EARTH_IMAGE = "earth.jpg";
HashMap<Integer, PImage> INVADER_SPRITE;
int KEY_SPACE = 32;
int KEY_LEFT = 37;
int KEY_RIGHT = 39;

// game physic constants
int DX = 5;
int MOVE_RIGHT = DX;
int MOVE_LEFT = - DX;

/*
*
*/
abstract class Drawable{
	abstract void draw();
}

class Entity extends Drawable{
	// coordinates of the hitbox
	int x0, y0, x1, y1;
	PImage sprite;
	
	Entity(int x, int y, int size, PImage sprite) {
		int half = int(size / 2);
		this.x0 = x - half;
		this.y0 = y - half;
		this.x1 = x + half;
		this.y1 = x + half;
		this.sprite = sprite;
this.sprite.resize(size, size);
	}
	
	void move(int dx, int dy) {
		this.x0 += dx;
		this.x1 += dx;
		this.y0 += dy;
		this.y1 += dy;
	}
	
	boolean contains(int x, int y) {
		return this.x0 <= x && this.x1 >= x && this.y0 <= y && this.y1 >= y;
	}
	
	void draw() {
		image(this.sprite, this.x0, this.y0);
	}
}

class Player extends Entity{
	Player(int x, int y, int size) {
  super(x, y, size, loadImage(PLAYER_IMAGE));		
	}
}

class Invader extends Entity{  
	Invader(int x, int y, int size, int spriteVersion) {
		super(x, y, size, INVADER_SPRITE.get(spriteVersion));
	}
}

// set of all objects to be drawn
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
ArrayList<Invader> INVADERS;

void settings() {
  // load invaders sprite map
  INVADER_SPRITE = new HashMap();
  for(int i=0; i<5; i++){
    INVADER_SPRITE.put(i, loadImage(String.format("sprite_%s.png", i)));
  }
  
  INVADERS = new ArrayList();
  int size = 80, rows = 5, columns = 8;
  for(int i=0; i<rows; i++){
    for(int j=0; j<columns; j++){
      INVADERS.add(new Invader(j*size+size, i*size+size, size, int(random(5))));
    
    }
  }
  
	scene = new Scene(900, 900);
	player = scene.getPlayer();
	size(scene.canvasWidth, scene.canvasHeight);
}

void draw() {
	scene.draw();
  for(int k=0; k<INVADERS.size(); k++){
     INVADERS.get(k).draw();
  }
}

void descendInvaders(){
  for(int i=0; i<INVADERS.size(); i++){
    INVADERS.get(i).move(0, 50); 
  }
}

void keyPressed() {
  println(keyCode);
  switch(keyCode){
    case KEY_LEFT:
    player.move(MOVE_LEFT, 0);
    break;
    case KEY_RIGHT:
    player.move(MOVE_RIGHT, 0);
    break;
    case KEY_SPACE:
    descendInvaders();
    break;
  }
}
