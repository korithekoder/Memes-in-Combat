package objects.ui;

import backend.data.ClientPrefs;
import backend.util.CacheUtil;
import flixel.util.FlxTimer;
import backend.util.GeneralUtil;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import backend.Controls;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import haxe.Json;
import openfl.Assets;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import backend.util.PathUtil;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * Object used to create dialogue boxes during the game.
 */
class DialogueBox extends FlxTypedGroup<FlxSprite> {

    /**
     * The data that `this` dialogue box has.
     * This includes things like responses, what the speaker says,
     * what each response responds to, etc.
     */
    public var speechData(get, never):Array<Dynamic>;
    private var _speechData:Array<Dynamic>;

    /**
     * The ID of the speaker associated with the dialogue box.
     */
    public var speakerId(get, never):String;
    private var _speakerId:String;

    private var _speaker:FlxSprite;
    private var _speakerData:Dynamic;
    private var _speakerEmotions:Array<Dynamic>;
    private var _currentSpeakerEmotion:String = '';

    private var _dialogueText:FlxText;
    private var _dialogueBoxBase:FlxSprite;

    private var _currentDialogueIdx:Int = 0;
    private var _currentBubbleData:Dynamic;
    private var _foundStartingBubble:Bool = false;

    private var _canEnterPrompt:Bool = true;

    private var _response1:ClickableText;
    private var _response2:ClickableText;
    private var _oldBubbleData:Dynamic;

    private var _hoveredResponse:Int = 1;

    private var _hoverArrow:FlxSprite;

    /**
     * Constructs a new dialogue instance, which is responsible for displaying
     * dialogue text and managing interactions within the dialogue system.
     * 
     * It initializes the dialogue box with the specified speech data and associates
     * it with a particular speaker. The `speechDataName` parameter is used to load the relevant
     * dialogue content, while the `speakerId` parameter identifies the character or entity
     * delivering the dialogue. These parameters allow the dialogue box to dynamically adapt
     * to different scenarios and speakers in the game.
     * 
     * For your `xml` data, each emotion (animation) should look like this format
     * (notice how each sub texture is formatted as the character's ID, the emotion, and then the frame):
     * 
     * ```xml
     * <SubTexture name="troll_normal_0" ... />
     * <SubTexture name="troll_confident_0" ... />
     * <SubTexture name="troll_confident_1" ... />
     * <SubTexture name="troll_confident_2" ... />
     * <SubTexture name="troll_upset_0" ... />
     * <SubTexture name="troll_upset_1" ... />
     * ```
     * 
     * @param speechDataName A string representing the name or key of the speech data resource
     *                       to be loaded. This is typically used to fetch pre-defined dialogue
     *                       content from a file.
     * @param speakerId      An identifier representing the speaker associated with 
     *                       this dialogue. This is used to obtain data, such as their emotions
     *                       (animations that can play), their name, etc.
     */
    public function new(speechDataName:String, speakerId:String) {
        super(6);

        CacheUtil.isDialogueFinished = false;

        this._speakerId = speakerId;
        this._speechData = (Assets.exists(PathUtil.ofJson('dialogue/speeches/$speechDataName'))) ? Json.parse(Assets.getText(PathUtil.ofJson('dialogue/speeches/$speechDataName'))) : [];
        this._speakerData = (Assets.exists(PathUtil.ofJson('dialogue/characters/$speakerId'))) ? Json.parse(Assets.getText(PathUtil.ofJson('dialogue/characters/$speakerId'))) : {}
        this._speakerEmotions = this._speakerData.emotions;

        this._speaker = new FlxSprite();
        this._speaker.frames = FlxAtlasFrames.fromSparrow(PathUtil.ofSpriteSheet('dialogue/${this._speakerId}')[0], PathUtil.ofSpriteSheet('dialogue/${this._speakerId}')[1]);

        this._dialogueBoxBase = new FlxSprite();
        this._dialogueBoxBase.makeGraphic(FlxG.width - 110, 220, FlxColor.BLACK);
        this._dialogueBoxBase.alpha = 1;    
        this._dialogueBoxBase.screenCenter(FlxAxes.X);
        this._dialogueBoxBase.y = (FlxG.height - _dialogueBoxBase.height) - 50;

        this._speaker.x = this._dialogueBoxBase.x;
        this._speaker.y = (this._dialogueBoxBase.y - this._speaker.height) + 120;

        this._dialogueText = new FlxText();
        this._dialogueText.text = this._speechData[this._currentDialogueIdx].text;
        this._dialogueText.size = 32;
        this._dialogueText.color = FlxColor.WHITE;
        this._dialogueText.updateHitbox();
        this._dialogueText.setPosition(this._dialogueBoxBase.x + 8, this._dialogueBoxBase.y + 8);

        this._response1 = new ClickableText();
        this._response1.size = 32;
        this._response1.color = FlxColor.WHITE;
        this._response1.updateHitbox();
        this._response1.onClick = () -> {
            _changeDialogue();
            if (this._currentBubbleData == this._oldBubbleData) {
                this.fadeOutAndDestroy();
            }
        };
        this._response1.onHover = () -> _setHoveredResponse(1);

        this._response2 = new ClickableText();
        this._response2.size = 32;
        this._response2.color = FlxColor.WHITE;
        this._response2.updateHitbox();
        this._response2.onClick = () -> {
            _changeDialogue();
            if (this._currentBubbleData == this._oldBubbleData) {
                this.fadeOutAndDestroy();
            }
        };
        this._response2.onHover = () -> _setHoveredResponse(2);

        this._hoverArrow = new FlxSprite();
        this._hoverArrow.loadGraphic(PathUtil.ofImage('arrow'));
        this._hoverArrow.scale.set(0.2, 0.2);
        this._hoverArrow.updateHitbox();

        this.add(this._speaker);
        this.add(this._dialogueBoxBase);
        this.add(this._dialogueText);
        this.add(this._response1);
        this.add(this._response2);
        this.add(this._hoverArrow);

        // Find the first speech bubble that has nothing contained
        // in the "responsefrom" array
        for (bubble in this._speechData) {
            if (bubble.responsefrom.length == 0) {
                this._foundStartingBubble = true;
                this._currentBubbleData = bubble;
                this.setResponses(bubble);
                this._response1.updateHoverBounds();
                this._response2.updateHoverBounds();
                this._currentSpeakerEmotion = this._currentBubbleData.emotion;
                break;
            }
        }

        // Set the arrow to be on the first response
        this.changeHoverArrowLocation(this._hoveredResponse, false);

        // Add each animation, with the data from the speaker's character .json
        // file, with the .xml file from the images/spritesheets folder
        for (emtn in this._speakerEmotions) {
            var frames:Array<Int> = [];
            for (i in 0...emtn.frames) frames.push(i);
            this._speaker.animation.addByIndices(emtn.id, '${this._speakerId}_${emtn.id}_', frames, '', 15, false);
        }
    }

    // ------------------------------
    //      GETTERS AND SETTERS
    // ------------------------------

    @:noCompletion
    public inline function get_speechData():Dynamic {
        return this._speechData;
    }

    @:noCompletion
    public inline function get_speakerId():String {
        return this._speakerId;
    }

    @:noCompletion
    public inline function get_speaker():FlxSprite {
        return this._speaker;
    }

    // -----------------------------
    //            METHODS
    // -----------------------------

    override function update(elapsed:Float) {
        super.update(elapsed);

        // Check if the left/right bind was pressed
        // to switch responses
        if (Controls.binds.UI_LEFT_JUST_PRESSED) {
            this._switchHoveredResponse(1);
        } else if (Controls.binds.UI_RIGHT_JUST_PRESSED) {
            this._switchHoveredResponse(2);
        }

        // If the user presses the accept bind, then load the next response
        if (Controls.binds.UI_SELECT_JUST_PRESSED && this._canEnterPrompt) {
            _changeDialogue();
            if (this._currentBubbleData == this._oldBubbleData) {
                this.fadeOutAndDestroy();
            }
        }
    }

    /**
     * Changes what response the funni little arrow is hovering over.
     * 
     * @param location       Which response the arrow should hover over.
     * @param playHoverSound Should the arrow play a sound when it changes options?
     */
    public function changeHoverArrowLocation(location:Int, playHoverSound:Bool = true):Void {
        if (playHoverSound && this._response2.text != '') {
            FlxG.sound.play(PathUtil.ofSound('blip'));
        }
        switch (location) {
            case (1):
                this._hoverArrow.x = (this._response1.x + (this._response1.width / 2) - (this._hoverArrow.width / 2));
                this._hoverArrow.y = (this._response1.y + this._response1.height) + 1;
            case (2):
                if (this._response2.text == '') {
                    this._hoveredResponse = 1;
                    return;
                }
                this._hoverArrow.x = (this._response2.x + (this._response2.width / 2) - (this._hoverArrow.width / 2));
                this._hoverArrow.y = (this._response2.y + this._response2.height) + 1;
        }
    }

    /**
     * Sets a response with new data. This is used usually when a new bubble is being generated.
     * 
     * @param r    The response to change.
     * @param text The text to set it too.
     */
    public function setResponse(r:Int, text:String):Void {
        switch (r) {
            case (1):
                this._response1.text = text;
                this._response1.updateHitbox();
                this._response1.updateHoverBounds();
                this._response1.x = (this._dialogueBoxBase.x + 30);
                this._response1.y = (this._dialogueBoxBase.y + this._dialogueBoxBase.height) - this._response1.height - 30;
            case (2):
                this._response2.text = text;
                this._response2.updateHitbox();
                this._response2.updateHoverBounds();
                this._response2.x = (this._response1.x + this._response1.width) + 20;
                this._response2.y = (this._dialogueBoxBase.y + this._dialogueBoxBase.height) - this._response2.height - 30;       
        }
    }

    /**
     * Change both responses at the same time, using the whole speech bubble data to use.
     * 
     * @param bubbleData The speech bubble data to obtain the responses from. 
     */
    public function setResponses(bubbleData:Dynamic):Void {
        var isR1Null:Bool = (bubbleData.responses[0] == null);
        var isR2Null:Bool = (bubbleData.responses[1] == null);
        this.setResponse(1, (!isR1Null) ? bubbleData.responses[0] : 'Press ${ClientPrefs.get_controlsKeyboard().get('ui_select').toString()} to continue...');
        this.setResponse(2, (!isR2Null) ? bubbleData.responses[1] : '');
    }

    /**
     * Add a cool fadeout and then destroy `this` dialogue box.
     */
    public function fadeOutAndDestroy(duration:Float = 1):Void {
        this._canEnterPrompt = false;
        GeneralUtil.tweenSpriteGroup(this, { alpha: 0 }, duration, { type: FlxTweenType.ONESHOT });
        new FlxTimer().start(duration, (_) -> { 
            CacheUtil.isDialogueFinished = true; 
            this.destroy(); 
        });
    }

    private function _setHoveredResponse(r:Int) {
        this._hoveredResponse = r;
        switch (r) {
            case (1):
                changeHoverArrowLocation(1);
            case (2):
                changeHoverArrowLocation(2);
        }
    }

    private function _switchHoveredResponse(r:Int) {
        switch (r) {
            case (1):
                this._hoveredResponse--;
                if (this._hoveredResponse < 1) this._hoveredResponse = 2;
                changeHoverArrowLocation(this._hoveredResponse);
            case (2):
                this._hoveredResponse++;
                if (this._hoveredResponse > 2) this._hoveredResponse = 1;
                changeHoverArrowLocation(this._hoveredResponse);
        }
    }

    private function _changeDialogue():Void {
        this._response1.isHovered = false;
        this._response2.isHovered = false;

        this._oldBubbleData = this._currentBubbleData;

        for (bubble in this._speechData) {
            var rf:Array<String> = bubble.responsefrom;  // Make the array in the JSON data a variable because HTML whines about it :p 
            if (rf.contains(this._currentBubbleData.responses[this._hoveredResponse - 1])) {
                this._currentBubbleData = bubble;
                break;
            }
        }

        setResponses(this._currentBubbleData);
        changeHoverArrowLocation(1, false);
        this._hoveredResponse = 1;
        this._dialogueText.text = this._currentBubbleData.text;
        this._currentSpeakerEmotion = this._currentBubbleData.emotion;
        this._speaker.animation.play(this._currentSpeakerEmotion);
        FlxG.sound.play(PathUtil.ofSound('dialogue/${this._speakerId}-${this._currentSpeakerEmotion}'), false, false);
    }
}
