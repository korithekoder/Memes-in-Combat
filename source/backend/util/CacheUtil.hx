package backend.util;

/**
 * Class that holds general, temporary data for pretty much anything.
 * Examples of general temporary data can be things such as the last volume used, the
 * years the player has unlocked, etc.
 */
final class CacheUtil {
    
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
	public static var isWindowFocused:Bool = true;

    /**
     * The years that the player has unlocked.
     */
    public static var unlockedYears:Array<String> = ['Tutorial'];

    /**
     * The currently selected year by the player.
     */
    public static var selectedYear:String;

    /**
     * The current data for the selected year.
     * This is pulled from `shared/data/years`, and its name should
     * match the year ID, or otherwise it will not work.
     */
    public static var currentYearData:Dynamic;

    /**
     * The current level data for the selected year.
     * This holds information about things such as the size of the map.
     */
    public static var currentYearLevelData:Dynamic;

    /**
     * The current metadata for the selected year.
     */
    public static var currentYearMetadata:Dynamic;

    /**
     * The current data that is used to generate the map for the selected year.
     */
    public static var currentYearMapData:Array<Array<Dynamic>> = [];

    /**
     * The current music soundtracks for the selected year.
     */
    public static var currentYearSoundtracks:Array<String> = [];

    /**
     * Is the dialogue finished?
     */
    public static var isDialogueFinished:Bool = true;

    private function new() {}
}
