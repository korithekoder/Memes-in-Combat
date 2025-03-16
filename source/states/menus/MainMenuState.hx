package states.menus;

#if DISCORD_ALLOWED
import backend.api.DiscordClient;
#end
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import backend.data.Constants;
import flixel.util.FlxTimer;
import backend.util.CacheUtil;
import backend.util.PathUtil;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

/**
 * State that displays the main menu.
 */
class MainMenuState extends FlxState {
    
    var titleText:FlxText;
    var introText:FlxText;
    var pressAnyKeyText:FlxText;

    var introStageTimer1:FlxTimer = new FlxTimer();
    var introStageTimer2:FlxTimer = new FlxTimer();

    var chosenSplashText:Array<String> = Constants.SPLASH_TEXTS[FlxG.random.int(0, Constants.SPLASH_TEXTS.length - 1)];

    var flashbang:FlxSprite;

    var goofyAhhTroll:FlxSprite;

    var buttonGroup:FlxTypedGroup<FlxText>;

    var campaignButton:FlxText;
    var exitButton:FlxText;

    var buttonTween:FlxTween;

    var lastHoveredButton:FlxText;

    override public function create() {

        // Start the main menu music
        FlxG.sound.playMusic(PathUtil.ofMusic('Jam Out By Myself'), 1, true);

        // Setup and add the title text
        titleText = new FlxText('Memes in Combat');
        titleText.size = 90;
        titleText.color = FlxColor.WHITE;
        titleText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4);
        titleText.x = 60;
        titleText.y = 80;
        titleText.visible = CacheUtil.alreadySawIntro;
        add(titleText);

        // Setup and add the intro text
        introText = new FlxText();
        introText.size = 60;
        add(introText);

        // Setup and add the "Press any key to skip" text
        pressAnyKeyText = new FlxText('Press any key to skip');
        pressAnyKeyText.size = 20;
        pressAnyKeyText.alignment = FlxTextAlign.CENTER;
        pressAnyKeyText.setPosition((FlxG.width - pressAnyKeyText.width) / 2, FlxG.height - pressAnyKeyText.height - 10);
        pressAnyKeyText.alpha = 0;
        add(pressAnyKeyText);

        // Setup and add the goofy goober that on the main menu
        goofyAhhTroll = new FlxSprite(0, 0);
        goofyAhhTroll.loadGraphic(PathUtil.ofImage('intro_troll'));
        goofyAhhTroll.updateHitbox();
        goofyAhhTroll.x = FlxG.width + goofyAhhTroll.width;
        goofyAhhTroll.y = FlxG.height - goofyAhhTroll.height - 40;
        add(goofyAhhTroll);

        // Setup the button group
        buttonGroup = new FlxTypedGroup<FlxText>();
        buttonGroup.visible = false;
        add(buttonGroup);

        // Setup and add the campaign button
        campaignButton = new FlxText(80, (FlxG.height / 2) + 20, 'Campaign');
        campaignButton.size = 45;
        campaignButton.updateHitbox();
        campaignButton.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3);
        buttonGroup.add(campaignButton);

        #if desktop // Exiting only works on desktop!
        // Setup and add the exit button
        exitButton = new FlxText(80, (FlxG.height / 2) + 100, 'Quit Game');
        exitButton.size = 45;
        exitButton.updateHitbox();
        exitButton.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3);
        buttonGroup.add(exitButton);
        #end

        // Setup and add the flash that appears when the main menu is shown
        flashbang = new FlxSprite(0, 0);
        flashbang.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        flashbang.alpha = 0;
        add(flashbang);

        // Start the title text tween that makes it somewhat like a seesaw
        FlxTween.angle(titleText, -8, 8, 2.1, {
            type: FlxTweenType.PINGPONG,
            ease: FlxEase.quadInOut
        });

        // Start the "Press any key to skip" text tween that makes it fade in
        FlxTween.tween(pressAnyKeyText, { alpha: 1 }, 2, {
            type: FlxTweenType.ONESHOT
        });

        // Set the Discord rich presence
        #if DISCORD_ALLOWED
        DiscordClient.setPresence("Main Menu");
        #end

        // Start the intro if the player hasn't seen it yet
        // (This is for when the player goes back to the main menu)
        if (!CacheUtil.alreadySawIntro) {
            _startIntro();
        }
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        // If the player hasn't seen the intro yet, they can skip it by pressing any key
        if (!CacheUtil.alreadySawIntro) {
            if (FlxG.keys.justPressed.ANY) {
                _setupMainMenu();
            }
        } else {
            // Loop through each button in the button group
            for (button in buttonGroup.members) {
                // If the mouse is hovering over the button, then
                // tween the button to make it look like it's being hovered
                // (this line is so long oml)
                if (FlxG.mouse.overlaps(button) || ((FlxG.mouse.x >= 80) && (FlxG.mouse.y >= button.y) && (FlxG.mouse.y <= button.y + button.height) && (FlxG.mouse.x <= button.x + button.width) && (lastHoveredButton == button))) {
                    // Make sure the button isn't already being hovered, otherwise
                    // some crazy shit will happen!
                    if (lastHoveredButton != button) {
                        // Play a sound
                        FlxG.sound.play(PathUtil.ofSound('blip'));
                        lastHoveredButton = button;
                        // Tween the button to move to the right of the screen
                        buttonTween = FlxTween.tween(button, { x: 200 }, 0.2, {
                            type: FlxTweenType.PERSIST,
                            ease: FlxEase.quadOut
                        });
                    }
                    // If the button has been clicked, then
                    // do the action that is linked with the said button
                    if (FlxG.mouse.justReleased) {
                        if (button == campaignButton) {  // Campaign button action
                            trace('Campaign button clicked');
                        } else if (button == exitButton) {  // Exit button action
                            #if desktop
                            Sys.exit(0);
                            #end
                        }
                    }
                } else if (lastHoveredButton == button) {
                    lastHoveredButton = null;
                    // Cancel the tween if the mouse is no longer hovering over the button
                    buttonTween.cancel();
                    // Tween the button back to its original position
                    buttonTween = FlxTween.tween(button, { x: 80 }, 0.2, {
                        type: FlxTweenType.PERSIST,
                        ease: FlxEase.quadOut
                    });
                }
            }
        }
    }

    private function _startIntro():Void {
        // Start timer(s) that loops through the different stages
        // of the intro
        var stage:Int = 0;
        introStageTimer1.start(
            // Time
            2.5,
            // Callback
            (timer:FlxTimer) -> {
                stage++;
                _switchIntroStage(stage);
            },
            // Loops
            9
        );

        new FlxTimer().start(
            // Time
            22.5,
            // Callback
            (timer:FlxTimer) -> {
                introStageTimer2.start(
                    0.5,
                    (timer:FlxTimer) -> {
                        stage++;
                        _switchIntroStage(stage);
                    },
                    4
                );
            }
        );
    }

    private function _switchIntroStage(stage:Int):Void {
        switch (stage) {
            case (1):
                _setIntroText('A game by', true);
            case (2):
                _setIntroText('korithekoder', true);
            case (3):
                _setIntroText('');
            case (4):
                _setIntroText('Music by', true);
            case (5):
                _setIntroText('Basket', true);
            case (6):
                _setIntroText('');
            case (7):
                _setIntroText(chosenSplashText[0], true);
            case (8):
                _setIntroText(chosenSplashText[1], true);
            case (9):
                _setIntroText('');
            case (10):
                _setIntroText('Memes', true);
            case (11):
                _setIntroText('in', true);
            case (12):
                _setIntroText('Combat', true);
            case (13):
                _setupMainMenu();
        }
    }

    private function _setIntroText(text:String, append:Bool = false):Void {
        if (!append) {
            introText.text = text;
        } else {
            introText.text += '$text\n';
        }
        introText.setPosition((FlxG.width - introText.width) / 2, (FlxG.height - introText.height) / 2);
        introText.alignment = FlxTextAlign.CENTER;
    }

    private function _setupMainMenu():Void {
        introText.visible = false;
        titleText.visible = true;
        pressAnyKeyText.visible = false;

        FlxG.camera.bgColor = FlxColor.WHITE;
        CacheUtil.alreadySawIntro = true;

        introStageTimer1.cancel();
        introStageTimer2.cancel();

        buttonGroup.visible = true;

        flashbang.alpha = 1;
        FlxTween.tween(flashbang, { alpha: 0 }, 3, {
            type: FlxTweenType.ONESHOT
        });

        new FlxTimer().start(
            1.75,
            (timer:FlxTimer) -> {
                FlxTween.tween(goofyAhhTroll, { x: FlxG.width - goofyAhhTroll.width - 20 }, 2, {
                    type: FlxTweenType.PERSIST,
                    ease: FlxEase.quadOut
                });
            }
        );
    }
}
