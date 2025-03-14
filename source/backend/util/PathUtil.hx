package backend.util;

import flixel.FlxG;

class PathUtil {
    
    /**
     * Get the path of a font asset.
     * 
     * @param name The name of the font (this does not include the file extenstion).
     * @return     The path of the font.
     */
    public static inline function ofFont(name:String):String {
        return 'assets/fonts/' + '$name.ttf';
    }

    /**
     * Get the full pathway to the game's save folder.
     * 
     * @param trailingPath The path to concatenate with the save path.
     * @return             The path of the save folder (including anything that was appended after with `trailingPath`).
     */
    @:access(flixel.util.FlxSave.validate)
	public static function getSavePath(trailingPath:String = ''):String {
		var company:String = FlxG.stage.application.meta.get('company');
		var toReturn:String = '${company}/${flixel.util.FlxSave.validate(FlxG.stage.application.meta.get('file'))}';
		toReturn += (trailingPath != '') ? '/$trailingPath' : '';
		return toReturn;
	}
}
