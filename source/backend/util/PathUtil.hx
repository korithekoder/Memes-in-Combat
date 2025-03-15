package backend.util;

import flixel.FlxG;

class PathUtil {
    
    /**
     * Get the path of an image asset.
     * 
     * @param name The name of the image (this does not include the file extenstion).
     * @return     The path of the image.
     */
    public static inline function ofImage(name:String):String {
        return 'assets/shared/images/' + '$name.png';
    }

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
     * Get the path of a sound effect asset.
     * 
     * @param name The name of the sound effect (this does not include the file extenstion).
     * @return     The path of the sound effect.
     */
    public static inline function ofSound(name:String):String {
        return 'assets/shared/sounds/' + '$name' + #if html5 '.mp3' #else '.ogg' #end;
    }

    /**
     * Get the path of a music soundtrack asset.
     * 
     * @param name The name of the soundtrack (this does not include the file extenstion).
     * @return     The path of the soundtrack.
     */
    public static inline function ofMusic(name:String):String {
        return 'assets/shared/music/' + '$name' + #if html5 '.mp3' #else '.ogg' #end;
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
