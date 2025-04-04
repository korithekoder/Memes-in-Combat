package objects.gameplay;

import flixel.FlxSprite;

/**
 * Object that is used to represent a tile in the map
 * for the current year that is being played.
 */
class MapTile extends FlxSprite {

    /**
     * The tile's x position in the map.
     */
    public var mx:Int = 0;

    /**
     * The tile's y position in the map.
     */
    public var my:Int = 0;

    /**
     * The rotation type of `this` tile.
     * - 1 = 90 degrees
     * - 2 = 180 degrees
     * - 3 = 270 degrees
     */
    public var rotation:Float = 1;

    public function new(mx:Int = 0, my:Int = 0, rotation:Int = 1, tileType:Dynamic) {
        super(mx * 200, my * 200);
        this.mx = mx;
        this.my = my;
        this.rotation = Math.abs(rotation);
        this.angle = this.rotation * 90;
    }
}
