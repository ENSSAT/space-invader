//
Scene scene;
Player player;
ArrayList<Invader> invaders;
Keyboard keyboard;


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
	INVADERS_SIMULTANEOUS_SHOTS = 0;
	
	// load textures
	int invadersSize = int(0.1 * scene.width);
	HashMap<Integer, PImage> invadersSprites = loadInvadersSprites(invadersSize);
	
	// create scene items
	player = new Player(scene);
	invaders = new ArrayList();
	
	for (int j = 0; j < invadersCols; j++) {
		for (int i = 0; i < invadersRows; i++) {
			// instanciate j cols, i rows of invaders
			invaders.add(
				new Invader(scene, j, i, invadersSize, invadersSprites.get(i))
				);
		}
	}
	
	// make the first invader shot... 
	//invaders.get(0).shot();
	//invaders.get(1).shot();
}

void settings() {	
	// game configuration
	int sceneWidth = 1000;
	int sceneHeight = 800;
	
	// initialize a map containing pressed keys
	keyboard = new Keyboard();
	
	// initialize a new game
	size(sceneWidth, sceneHeight);
	scene = new Scene(sceneWidth, sceneHeight);
	scene.gameOver("Welcome back!");
}

int invadersDx = - 2;
int invadersDy = 50;

// gameloop
void draw() {
	// perform actions when keys are pressed
	eventsHandler();
	
	// draw all drawable items
	scene.draw();
	
	// don't perform aliens move logic once game has ended
	if (scene.isGameOver) {
		// update the scene to reflect previous changes...
		return;
	}
	
	int index;
	int n = INVADER_MAX_SIMULTANEOUS_SHOTS - INVADERS_SIMULTANEOUS_SHOTS;
	
	for (int k = 0; k < n; k++) {
		index = int(random(invaders.size()));
		invaders.get(index).shot();
		println("in the loop");
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
	
	
	// move each shot to the next step
	for (int k = 0; k < scene.shots.size(); k++) {
		Shot shot = scene.shots.get(k);
		
		// try to move a shot, or destroy instance if it reached border
		if (!shot.move()) {
			shot.destroy();
			break;
		}
		
		if (shot.entity.hasGroup(GROUP_INVADERS)) {
			// if shot was initiated by an invader, test it against player
			if (shot.hurt(player)) {
				scene.gameOver("You were killed!\nGame over");
				break;
			}
		} else if (shot.entity.hasGroup(GROUP_PLAYER)) {
			// if shot was initiated by a player, test it against invaders
			for (int l = 0; l < scene.invaders.size(); l++) {
				invader = scene.invaders.get(l);
				if (shot.hurt(invader)) {
					invader.destroy();
					shot.destroy();
				}
			}
		}
	}
	
	// move invaders down when they reached sides of the scene
	for (int k = 0; k < scene.invaders.size(); k++) {
		invader = scene.invaders.get(k);
		invader.move(invadersDx, borderReached ? invadersDy : 0);
	}
	
	// if no invaders remains, game is finished
	if (scene.invaders.size() == 0) {
		scene.gameOver("You win!");
	}
	
}

int playerDx = 5;

void eventsHandler() {
	if (keyboard.isPressed(KEY_LEFT)) {
		player.move(- playerDx);
	} else if (keyboard.isPressed(KEY_RIGHT)) {
		player.move(playerDx);
	}
	
	if (keyboard.isPressed(KEY_SPACE)) {
		if (!scene.gameRunning()) {
			// start a new game
			int invadersRow = 3;
			int invadersCols = 4;
			newGame(scene, invadersRow, invadersCols);
		} else if (player.canShot()) {
			// make player shot
			player.shot();
		}
	}
}

void keyPressed() {
	// add pressed key to keyboard event store
	keyboard.keyPressed(keyCode);
}

void keyReleased() {
	// add pressed key to keyboard event store
	keyboard.keyReleased(keyCode);
}