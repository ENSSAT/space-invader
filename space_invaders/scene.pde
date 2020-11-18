/**
* Object to reach. Typically target in space invader.
*/
class Target extends Drawable{
	int targetOffset;
	PImage img;
	
	Target(Scene scene, PImage img) {
		this.img = img;
		img.resize(scene.width, int(scene.width * img.height / img.width));
		targetOffset = scene.height - img.height;
	}
	
	void draw() {
		image(img, 0, targetOffset);
	}
}

/**
* Manage rendering of drawables entities.
*/
class Scene extends Drawable{
	// scene properties
	int width, height;
	Target target = null;
	Player player = null;
	
	// state variables
	boolean isGameOver = false;
	String gameOverMessage = "";
	
	// drawable entities
	ArrayList<Drawable> items;
	ArrayList<Invader> invaders;
	ArrayList<Shot> shots;
	
	Scene(int width, int height) {
		this.width = width;
		this.height = height;
		this.reset();
	}

	void setPlayer(Player player){
		this.player = player;
	}

	void setTarget(Target target){
		this.target = target;
	}
	
	void gameOver(String message) {
		println("Set game over message" + message);
		this.gameOverMessage = message;
		this.isGameOver = true;
	}
	
	void clear() {
		// items marked for removal...
		this.items = new ArrayList();
		this.shots = new ArrayList();
		this.invaders = new ArrayList();
		
		// TODO: refactoring, shouldn't be in the scene but in a state storage
		this.isGameOver = false;
	}
	
	/**
	* Setters and deleters
	*/
	void addShot(Shot shot) {
		this.shots.add(shot);
	}
	
	void removeShot(Shot shot) {
		this.shots.remove(shot);
	}
	
	void addInvader(Invader invader) {
		this.invaders.add(invader);
	}
	
	void removeInvader(Invader invader) {
		this.invaders.remove(invader);
	}
	
	void reset() {
		this.clear();
	}
	
	boolean gameRunning() {
		return !this.isGameOver;
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
	
	void remove(Drawable item) {
		items.remove(item);
	}
	
	/**
	* individually draw each element of the scene
	*/
	void draw() {
		background(0);

		if (isGameOver) {
			int titleWidth = int(0.8 * this.width * 0.1);
			int halfWidth = int(this.width / 2);
			int halfHeight = int(0.5 * this.height);
			int borderWidth = 3;
			
			textSize(int(titleWidth * 0.3));
			textAlign(LEFT);
			text("Press[Space] to play a new game...", 0, int(titleWidth * 0.3));
			
			textAlign(CENTER);
			
			textSize(titleWidth);
			
			fill(0, 0, 0);
			for (int x =- borderWidth; x < borderWidth + 1; x++) {
				for (int y =- borderWidth; y < borderWidth + 1; y++) {
					text(this.gameOverMessage, halfWidth - x, halfHeight - y);
				}
			}
			
			fill(255, 255, 255);
			text(this.gameOverMessage, halfWidth, halfHeight);
			return;
		}
		
		target.draw();
		player.draw();
		
		// draw shots
		for (int i = 0; i < shots.size(); i++) {
			shots.get(i).draw();
		}
		
		for (int i = 0; i < invaders.size(); i++) {
			invaders.get(i).draw();
		}
	}
}
