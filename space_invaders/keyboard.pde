
class Keyboard{
	HashMap<Integer, Boolean> isKeyPressed;
	
	Keyboard() {
		isKeyPressed = new HashMap();
	}
	
	void keyPressed(int keyCode) {
		isKeyPressed.put(keyCode, true);
	}
	
	void keyReleased(int keyCode) {
		isKeyPressed.remove(keyCode);
	}
	
	boolean isPressed(int keyCode) {
		return isKeyPressed.containsKey(keyCode);
	}
}
