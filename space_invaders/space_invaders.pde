//
final int KEY_SPACE = 32;
final int KEY_LEFT = 37;
final int KEY_RIGHT = 39;

//
Scene scene;
Player player;
ArrayList<Invader> invaders;

HashMap<Integer, PImage> loadInvadersSprites(Integer size) {
	HashMap<Integer, PImage> sprites = new HashMap();
	PImage sprite;
	for (int k = 0; k < 5; k++) {
		sprite = loadImage("invader_" + k + ".png");
		sprite.resize(size, size);
		sprites.put(k, sprite);
	}
	return sprites;
}

void newGame(Scene scene, int invadersRows, int invadersCols) {
	// reset locks
	scene.reset();
	
	// load textures
	int invadersSize = int(0.1 * scene.width);
	HashMap<Integer, PImage> invadersSprites = loadInvadersSprites(invadersSize);
	
	// create scene items
	player = new Player(scene);
	invaders = new ArrayList();
    
	for (int j = 0; j < invadersCols; j++) {
		for (int i = 0; i < invadersRows; i++) {
		    // instanciate j cols, i rows of invaders
			invaders.add(new Invader(
		        scene, j, i, invadersSize, invadersSprites.get(i)
		    ));
        }
	}
}

void settings() {
	// game configuration
	int sceneWidth = 1000;
	int sceneHeight = 800;
	int invadersRow = 5;
	int invadersCols = 8;
	
	// initialize a new game
	size(sceneWidth, sceneHeight);
	scene = new Scene(sceneWidth, sceneHeight);
	newGame(scene, invadersRow, invadersCols);
}

int invadersDx = - 2;
int invadersDy = 50;

void draw() {
	// don't perform aliens move logic once game has ended
	if (scene.gameOver) {
		return;
	}
	
	Invader invader;
	boolean borderReached = false;
	
	for (int k = 0; k < invaders.size(); k++) {
		invader = invaders.get(k);
		if (!invader.canMove(invadersDx)) {
			borderReached = true;
			break;
		}
		if (invader.earthReached()) {
			scene.gameOver = true;
			break;
		}
	}
	
	if (borderReached) {
		invadersDx = - invadersDx;
	}
	
	for (int k = 0; k < invaders.size(); k++) {
		invader = invaders.get(k);
		invader.move(invadersDx, borderReached ? invadersDy : 0);
	}
	
	scene.draw();
}

int playerDx = 5;

void keyPressed() {
	switch(keyCode) {
		case KEY_LEFT:
		player.move( - playerDx);
		break;
		case KEY_RIGHT:
		player.move(playerDx);
		break;
		case KEY_SPACE:
		if(scene.gameRunning()){
			// fire not implemented
		}else{
			// start a new game
			int invadersRow = 3;
			int invadersCols = 5;
			
			// initialize a new game
			newGame(scene, invadersRow, invadersCols);
		}
		break;
	}
}