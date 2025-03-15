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
}
