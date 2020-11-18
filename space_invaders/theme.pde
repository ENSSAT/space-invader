
class ThemeSettings{
    HashMap <String, Integer> colors;

    ThemeSettings(String settingsPath){
        JSONObject settings = loadJSONObject(settingsPath);
        loadThemeColors(settings.getJSONObject("colors"));
    }

    void loadThemeColors(JSONObject jsonobj){
        this.colors = new HashMap();
        String[] keys = (String[]) jsonobj.keys().toArray(new String[jsonobj.size()]);

        for(int k=0; k<keys.length; k++){
            String value = jsonobj.getString(keys[k]);
            this.colors.put(keys[k], unhex(value));
        }
    }

    Integer getColor(String name){
        return colors.get(name);
    }
}


class Theme{
	String themeFolderName;
    ThemeSettings settings;
	PImage targetSprite;
	PImage playerSprite;
	HashMap<Number, PImage> invadersSprites;
	
	Theme(String themeFolderName) {
		this.themeFolderName = themeFolderName;
        this.settings = new ThemeSettings(this.themeFolderName + "/theme.json");

		targetSprite = loadImage(themeFolderName + "/target.png");
		playerSprite = loadImage(themeFolderName + "/player.png");
        invadersSprites = new HashMap();
	}

    int getColor(String name){
        return this.settings.getColor(name);
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
