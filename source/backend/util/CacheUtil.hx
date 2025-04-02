package backend.util;

/**
 * Class that holds general, temporary data for pretty much anything.
 * Examples of general temporary data can be things such as the last volume used, the
 * years the player has unlocked, etc.
 */
class CacheUtil {
    
    /**
     * The last volume that the player had set before the game loses focus.
     */
    public static var lastVolumeUsed:Float;

    /**
     * Did the user already see the intro?
     * (This is for loading from and to the main menu when the game hasn't closed yet.)
     */
    public static var alreadySawIntro:Bool = false;

    /**
     * Can the user skip the intro if they have seen it already?
     */
    public static var canSkipIntro:Bool = false;

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

    /**
     * The currently selected year by the player.
     */
    public static var selectedYear:String;

    /**
     * Is the dialogue finished?
     */
    public static var isDialogueFinished:Bool = true;
}
