//
Scene scene;
Player player;
Shot playerShot;

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
	//invaders = new ArrayList();
	
	for (int j = 0; j < invadersCols; j++) {
		for (int i = 0; i < invadersRows; i++) {
			// instanciate j cols, i rows of invaders
			new Invader(scene, j, i, invadersSize, invadersSprites.get(i));
		}
	}
	
	// initialize shots
	playerShot = null;
	
	// TODO: remove this test
	new Shot(scene, GROUP_INVADERS, 500, 50, 2);
}

void settings() {
	// game configuration
	int sceneWidth = 1000;
	int sceneHeight = 800;
	int invadersRow = 3;
	int invadersCols = 4;
	
	// initialize a new game
	size(sceneWidth, sceneHeight);
	scene = new Scene(sceneWidth, sceneHeight);
	//scene.reset();
	//scene.gameOver("Welcome back!");
	//newGame(scene, invadersRow, invadersCols);
	scene.gameOver("Welcome back!");
}

int invadersDx = - 2;
int invadersDy = 50;

// gameloop
void draw() {
	scene.draw();
	
	// don't perform aliens move logic once game has ended
	if (scene.isGameOver) {
		// update the scene to reflect previous changes...
		return;
	}
	
	Invader invader;
	boolean borderReached = false;
	
	// detect invaders related events
	for (int k = 0; k < scene.invaders.size(); k++) {
		invader = scene.invaders.get(k);
		
		// invaders reached border of the world
		if (!invader.canMove(invadersDx)) {
			borderReached = true;
			break;
		}
		
		// invaders reached earth
		if (invader.earthReached()) {
			scene.gameOver("Aliens reached earth...\nGame over!");
			break;
		}
	}
	
	// if invaders reached border of the world, change their speed's direction.
	if (borderReached) {
		invadersDx = - invadersDx;
	}
	
	// move each invader according to the group's speed
	for (int k = 0; k < scene.invaders.size(); k++) {
		invader = scene.invaders.get(k);
		invader.move(invadersDx, borderReached ? invadersDy : 0);
	}
	
	if (playerShot != null) {		
		// move player shot
		if (!playerShot.move()) {
			// if no move, border was reached, delete shot entity and reset lock.
			playerShot.destroy();
			playerShot = null;
		} else{
			// foreach invader, check if it is hit!
			for (int k = scene.invaders.size() - 1; k>- 1; k--) {
				// if so, remove invader and shot entities
				if (playerShot.hurt(scene.invaders.get(k))) {
					scene.removeInvader(scene.invaders.get(k));
					playerShot.destroy();
					
					playerShot = null;
					break;
				}
			}
		}
	}
	
	// move each shot to the next step
	for (int k = 0; k < scene.shots.size(); k++) {
		Shot shot = scene.shots.get(k);
		shot.move();
		
		if (shot.hurt(player)) {
			scene.gameOver("You were killed!\nGame over");
			break;
		}
	}
	
	//
	for (int k = 0; k < scene.invaders.size(); k++) {
		invader = scene.invaders.get(k);
		invader.move(invadersDx, borderReached ? invadersDy : 0);
	}
}

int playerDx = 5;

void keyPressed() {
	switch(keyCode) {
		case KEY_LEFT:
		player.move(- playerDx);
		break;
		case KEY_RIGHT:
		player.move(playerDx);
		break;
		case KEY_SPACE:
		if (!scene.gameRunning()) {
			// start a new game
			int invadersRow = 3;
			int invadersCols = 4;
			newGame(scene, invadersRow, invadersCols);
		} if (playerShot == null) {
			// instanciate a shot
			playerShot = new Laser(scene, GROUP_PLAYER, this.player.x, this.scene.earth.earthOffset + int(0.2 * this.player.size), - 8);
		}
		break;
	}
}