package objects.display;

import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import backend.util.PathUtil;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * Object that represents a year in the campaign menu.
 */
class CampaignYearDisplayObject extends FlxTypedGroup<FlxSprite> {

    /**
     * The x position of `this` campaign year display.
     */
    public var x:Float;

    /**
     * The y position of `this` campaign year display.
     */
    public var y:Float;

    /**
     * The year this object represents. Note that this will also
     * be used to obtain the display image for this year, which is found
     * in `assets/shared/images/campaign-years/your-year-image-here`.
     */
    public var year(get, never):String;
    private var _year:String;

    /**
     * The image that displays the year.
     */
    public var yearImage(get, never):FlxSprite;
    private var _yearImage:FlxSprite;

    /**
     * The text that displays the year.
     */
    public var yearText(get, never):FlxText;
    private var _yearText:FlxText;

    /**
     * The color of the year text.
     */
    public var yearColor(get, never):FlxColor;
    private var _yearColor:FlxColor;

    /**
     * Constructor.
     * @param x    The x position.
     * @param y    The y position.
     * @param year The year `this` object represents.
     */
    public function new(x:Float, y:Float, year:String, yearColor:FlxColor = FlxColor.WHITE, outlineColor:FlxColor = FlxColor.BLACK, isUnlocked:Bool = false) {
        super(2);
        this.x = x;
        this.y = y;
        this._year = year;
        this._yearImage = new FlxSprite(PathUtil.ofImage('campaign-years/$year'));
        this._yearImage.setGraphicSize(200, 200);
        this._yearImage.updateHitbox();
        this._yearImage.setPosition(this.x, this.y);
        this._yearText = new FlxText();
        this._yearText.text = (isUnlocked) ? year : '???';
        this._yearText.size = 56;
        this._yearText.updateHitbox();
        this._yearText.color = yearColor;
        this._yearText.setBorderStyle(FlxTextBorderStyle.OUTLINE, outlineColor, 3);
        this._yearText.setPosition((this._yearImage.x) + (this._yearImage.width / 2) - (this._yearText.width / 2), ((this._yearImage.y + this._yearImage.height) - this._yearText.height));

        this._yearImage.color = (isUnlocked) ? FlxColor.WHITE : FlxColor.BLACK;
        
        this.add(this._yearImage);
        this.add(this._yearText);
    }

    // ------------------------------
    //      GETTERS AND SETTERS
    // ------------------------------

    public function get_year():String {
        return _year;
    }

    public function get_yearImage():FlxSprite {
        return _yearImage;
    }

    public function get_yearText():FlxText {
        return _yearText;
    }

    public function get_yearColor():FlxColor {
        return _yearColor;
    }

    // -----------------------------
    //            METHODS
    // -----------------------------

    /**
     * Tweens all the objects in `this` group.
     * 
     * @param options  The options for the tween.
     * @param duration How long the tween should last.
     * @param types    The types of tweens and eases to use.
     */
    public function tween(options:Dynamic, duration:Float, types:Dynamic):Void {
        for (obj in this.members) {                
            FlxTween.tween(obj, options, duration, types);
        }
    }
}
