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

void settings() {
	// configuration
	int sceneWidth = 1000;
	int sceneHeight = 500;
	int invadersRow = 3;
	int invadersCols = 5;

    // load textures
	int invadersSize = int(0.1 * sceneWidth);
	HashMap<Integer, PImage> invadersSprites = loadInvadersSprites(invadersSize);
	
	// create scene items
	scene = new Scene(sceneWidth, sceneHeight);
	player = new Player(scene);
	invaders = new ArrayList();
    
	for (int j = 0; j < 5; j++) {
		for (int i = 0; i < 3; i++) {
		    // instanciate j cols, i rows of invaders
			invaders.add(new Invader(
		        scene, j, i, invadersSize, invadersSprites.get(i)
		    ));
        }
    }	
	size(sceneWidth, sceneHeight);
}

int invadersDx = -2;
int invadersDy = 10;

void draw() {
    Invader invader;
    boolean borderReached = false;
    for (int k = 0; k < invaders.size(); k++) {
        invader = invaders.get(k);
        if(!invader.canMove(invadersDx)){
            borderReached = true;
            break;
        }
    }
    if(borderReached){
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
		player.move(-playerDx);
		break;
		case KEY_RIGHT:
		player.move(playerDx);
		break;
		case KEY_SPACE:
        // fire not implemented
		break;
	}
}