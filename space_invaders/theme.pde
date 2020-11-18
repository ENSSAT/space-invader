
class ThemeSettings{
    HashMap <String, Integer> colors;
    HashMap <String, Integer> sizes;
    HashMap <String, Integer> velocities;

    ThemeSettings(String settingsPath){
        JSONObject settings = loadJSONObject(settingsPath);
        loadThemeColors(settings.getJSONObject("color"));
        loadThemeSizes(settings.getJSONObject("size"));
        loadThemeVelocities(settings.getJSONObject("velocity"));
    }

    void loadThemeSizes(JSONObject jsonobj){
        try{
            this.sizes = new HashMap();
            String[] keys = (String[]) jsonobj.keys().toArray(new String[jsonobj.size()]);

            for(int k=0; k<keys.length; k++){
                this.sizes.put(keys[k], (int) jsonobj.get(keys[k]));
            }
        }catch(Exception e){
            Logger.error("Can't load 'size' from theme");
        }
    }

    void loadThemeColors(JSONObject jsonobj){
        try{
            this.colors = new HashMap();
            String[] keys = (String[]) jsonobj.keys().toArray(new String[jsonobj.size()]);

            for(int k=0; k<keys.length; k++){
                String value = jsonobj.getString(keys[k]);
                this.colors.put(keys[k], unhex(value));
            }
        }catch(Exception e){
            Logger.error("Can't load 'color' from theme");
        }
    }

    void loadThemeVelocities(JSONObject jsonobj){
        try{
            this.velocities = new HashMap();
            String[] keys = (String[]) jsonobj.keys().toArray(new String[jsonobj.size()]);

            for(int k=0; k<keys.length; k++){
                this.velocities.put(keys[k], (int) jsonobj.get(keys[k]));
            }
        }catch(Exception e){
            Logger.error("Can't load 'velocity' from theme");
        }
    }

    Integer getColor(String name){
        return colors.get(name);
    }

    Integer getSize(String name){
        return sizes.get(name);
    }

    Integer getVelocity(String name){
        return velocities.get(name);
    }
}


class Theme{
	String themeFolderName;
    ThemeSettings settings;
	PImage targetSprite;
	PImage playerSprite;
	HashMap<Number, PImage> invadersSprites;
	
	Theme(String themeFolderName) {
        Logger.info("Using theme:", themeFolderName);

		this.themeFolderName = themeFolderName;
        this.settings = new ThemeSettings(this.themeFolderName + "/theme.json");

		targetSprite = loadImage(themeFolderName + "/target.png");
		playerSprite = loadImage(themeFolderName + "/player.png");
        invadersSprites = new HashMap();
	}

    int getColor(String name){
        return this.settings.getColor(name);
    }

    int getSize(String name){
        return this.settings.getSize(name);
    }

    int getVelocity(String name){
        return this.settings.getVelocity(name);
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
