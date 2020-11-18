// variable loaded from theme settings
int INVADERS_DX;
int PLAYER_DX;
int BULLET_VELOCITY;
int LASER_VELOCITY;

// global scoped variables
Scene scene;
Player player;
ArrayList<Invader> invaders;
Keyboard keyboard;
Theme theme;

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

	// restore settings
	INVADERS_SIMULTANEOUS_SHOTS = 0;
	INVADERS_DX = theme.getVelocity("invader");
	PLAYER_DX = theme.getVelocity("player");
	BULLET_VELOCITY = scene.theme.getVelocity("bullet");
	LASER_VELOCITY = scene.theme.getVelocity("laser");
	
	// load textures
	int charactersSize = 80;
	
	// add target to the scene
	Target target = new Target(scene, theme.getTargetSprite());
	scene.setTarget(target);

	// add player to the scene
	player = new Player(scene, theme.getPlayerSprite());
	scene.setPlayer(player);

	invaders = new ArrayList();
	
	for (int j = 0; j < invadersCols; j++) {
		for (int i = 0; i < invadersRows; i++) {
			// instanciate j cols, i rows of invaders
			invaders.add(
				new Invader(scene, j, i, charactersSize, theme.getInvaderSprite(i))
				);
		}
	}
}

void settings() {	
	// game configuration
	int sceneWidth = 1500;
	int sceneHeight = 800;
	
	// initialize a map containing pressed keys
	keyboard = new Keyboard();
	
	// initialize a new game
	size(sceneWidth, sceneHeight);

	// instanciate theme
	scene = new Scene(sceneWidth, sceneHeight);

	// load one of the themes
	theme = new Theme("theme_frog");
	scene.setTheme(theme);

	// stop game with welcome message
	scene.gameOver("Welcome back!");
}

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
	}
	
	Invader invader;
	boolean borderReached = false;
	
	// detect invaders related events
	for (int k = 0; k < scene.invaders.size(); k++) {
		invader = scene.invaders.get(k);
		
		// invaders reached border of the world
		if (!invader.canMove(INVADERS_DX)) {
			borderReached = true;
			break;
		}
		
		// invaders reached target
		if (invader.targetReached()) {
			scene.gameOver("Aliens reached target...\nGame over!");
			break;
		}
	}
	
	// if invaders reached border of the world, change their speed's direction.
	if (borderReached) {
		INVADERS_DX = - INVADERS_DX;
	}
	
	// move each invader according to the group's speed
	for (int k = 0; k < scene.invaders.size(); k++) {
		invader = scene.invaders.get(k);
		invader.move(INVADERS_DX, borderReached ? invadersDy : 0);
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
				player.isAlive = false;
				scene.gameOver("You were killed!\nGame over");
				break;
			}
		} else if (shot.entity.hasGroup(GROUP_PLAYER)) {
			// if shot was initiated by a player, test it against invaders
			for (int l = 0; l < scene.invaders.size(); l++) {
				invader = scene.invaders.get(l);
				if (shot.hurt(invader)) {
					Logger.info("You killed an invader!");
					invader.isAlive = false;
					invader.destroy();
					shot.destroy();
				}
			}
		}
	}
	
	// move invaders down when they reached sides of the scene
	for (int k = 0; k < scene.invaders.size(); k++) {
		invader = scene.invaders.get(k);
		invader.move(INVADERS_DX, borderReached ? invadersDy : 0);
	}
	
	// if no invaders remains, game is finished
	if (scene.invaders.size() == 0) {
		scene.gameOver("You win!");
	}
	
}


void eventsHandler() {
	if (keyboard.isPressed(KEY_LEFT)) {
		player.move( - PLAYER_DX);
	} else if (keyboard.isPressed(KEY_RIGHT)) {
		player.move(PLAYER_DX);
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