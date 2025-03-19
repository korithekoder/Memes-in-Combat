package backend.util;

/**
 * Class that holds general, temporary data for pretty much anything.
 * Examples of general temporary data can be things such as the last volume used, for example.
 */
class CacheUtil {
    
    /**
     * The last volume that the player had set before the game loses focus.
     */
    public static var lastVolumeUsed:Float;

    /**
     * Did the user already see the intro?
     */
    public static var alreadySawIntro:Bool = false;

    /**
     * Can the game play menu music when the user leaves gameplay?
     */
    public static var canPlayMenuMusic:Bool = true;

	/**
	 * Is the game's window focused?
	 */
	public static var isFocused:Bool = true;

    /**
     * The years that the player has unlocked.
     */
    public static var unlockedYears:Array<String> = ['Tutorial'];
}
