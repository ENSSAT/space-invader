Scene scene;
Player player;

void settings() {
	// configuration
	int sceneWidth = 1000;
	int sceneHeight = 500;
	
	scene = new Scene(sceneWidth, sceneHeight);
	player = new Player(scene);
	
	size(sceneWidth, sceneHeight);
}

void draw() {
	scene.draw();
}
