//
final int KEY_SPACE = 32;
final int KEY_LEFT = 37;
final int KEY_RIGHT = 39;

//
Scene scene;
Player player;
ArrayList<Invader> invaders;

Shot playerShot;
ArrayList<Shot> invadersShots;


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

	// initialize shots
	playerShot = null;
	invadersShots = new ArrayList();
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

// gameloop
void draw() {
	// don't perform aliens move logic once game has ended
	if (scene.gameOver) {
		return;
	}
	
	Invader invader;
	boolean borderReached = false;
	
	// detect invaders related events
	for (int k = 0; k < invaders.size(); k++) {
		invader = invaders.get(k);

		// invaders reached border of the world
		if (!invader.canMove(invadersDx)) {
			borderReached = true;
			break;
		}

		// invaders reached earth
		if (invader.earthReached()) {
			scene.gameOver = true;
			break;
		}
	}
	
	// if invaders reached border of the world, change their speed's direction.
	if (borderReached) {
		invadersDx = - invadersDx;
	}
	
	// move each invader according to the group's speed
	for (int k=0; k<invaders.size(); k++) {
		invader = invaders.get(k);
		invader.move(invadersDx, borderReached ? invadersDy : 0);
	}

	// move player and invaders shots one step further
	if(playerShot != null){
		if(!playerShot.move()){
			playerShot = null;
		}
		for(int k=invaders.size()-1 ; k>-1; k--) {
			if(invaders.get(k).contains(playerShot.x, playerShot.y1)){
				scene.remove(invaders.get(k));
				invaders.remove(invaders.get(k));
				scene.remove(playerShot);
				
				playerShot = null;
				break;
			}
		}
	}
	for(int k=0; k<invadersShots.size(); k++){
		invadersShots.get(k).move();
	}

	

	//
	for (int k=0; k<invaders.size(); k++) {
		invader = invaders.get(k);
		invader.move(invadersDx, borderReached ? invadersDy : 0);
	}
	
	// update the scene to reflect previous changes...
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
		if(!scene.gameRunning()){
			// start a new game
			int invadersRow = 3;
			int invadersCols = 5;
			newGame(scene, invadersRow, invadersCols);
		} if(playerShot == null){
			// instanciate a shot
			playerShot = new Shot(scene, this.player.x, this.player.y, -5);
			this.scene.add(playerShot);
		}
		break;
	}
}