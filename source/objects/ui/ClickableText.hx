package objects.ui;

import flixel.FlxG;
import flixel.text.FlxText;

class ClickableText extends FlxText {

    public var onClick:Void -> Void = () -> {};
    public var onHover:Void -> Void = () -> {};
    
    private var _isHovered:Bool = false;
    
    public function new(x:Float = 0, y:Float = 0, text:String = '') {
        super(x, y, text);
    }
    
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this)) {
            if (!_isHovered) {
                this.onHover();
            }
            this._isHovered = true;

            if (FlxG.mouse.justPressed) {
                this.onClick();
            }
        }

        if (!FlxG.mouse.overlaps(this)) {
            this._isHovered = false;
        }
    }

    public function resetHovered() {
        this._isHovered = false;
    }
}
