
class ThemeLoader{
	String themeFolderName;
	PImage targetSprite;
	PImage playerSprite;
	HashMap<Number, PImage> invadersSprites;
	
	ThemeLoader(String themeFolderName) {
		this.themeFolderName = themeFolderName;
		targetSprite = loadImage(themeFolderName + "/target.png");
		playerSprite = loadImage(themeFolderName + "/player.png");
        invadersSprites = new HashMap();
	}
	
	PImage getPlayerSprite() {
		return this.playerSprite;
	}
	
	PImage getTargetSprite() {
		return this.targetSprite;
	}
	
	PImage getInvaderSprite(int index) {
		PImage sprite = invadersSprites.get(index);
		if (sprite == null) {
			sprite = loadImage(themeFolderName + "/invader_" + nf(index) + ".png");
			invadersSprites.put(index, sprite);
		}
		return sprite;
	}
}
