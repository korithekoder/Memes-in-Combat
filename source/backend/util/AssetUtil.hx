package backend.util;

import haxe.Json;
import openfl.utils.Assets;

/**
 * Utility class for obtaining and manipulating data in files.
 */
final class AssetUtil {
    
    private function new() {}

    /**
     * Gets regular JSON data from the specified file pathway.
     * 
     * @param path The pathway to obtain the JSON data.
     * @return     The data that was obtained from the said file. If it was not found, then `null` is returned instead.
     */
    public static inline function getJsonData(path:String):Dynamic {
        return (Assets.exists(PathUtil.ofJson(path))) ? Json.parse(Assets.getText(PathUtil.ofJson(path))) : null;
    }

    /**
     * Caches a list of sounds from an `Array`.
     * 
     * @param soundArray The list of the file pathways for each sound file to precache.
     */
    public static function precacheSoundArray(soundArray:Array<String>):Void {
        for (snd in soundArray) {
            Assets.loadSound(snd);
        }
    }
}
