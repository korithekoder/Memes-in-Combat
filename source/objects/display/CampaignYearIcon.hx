package objects.display;

import backend.util.PathUtil;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * Object that represents a year in the campaign menu.
 */
class CampaignYearIcon extends FlxTypedGroup<FlxSprite> {

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
     * in `assets/shared/images/campaign-icons/your-year-image-here`.
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
        this._yearImage = new FlxSprite(PathUtil.ofImage('campaign-icons/$year'));
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

    @:noCompletion
    public function get_year():String {
        return _year;
    }

    @:noCompletion
    public function get_yearImage():FlxSprite {
        return _yearImage;
    }

    @:noCompletion
    public function get_yearText():FlxText {
        return _yearText;
    }

    @:noCompletion
    public function get_yearColor():FlxColor {
        return _yearColor;
    }
}
