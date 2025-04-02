package states.menus;

import backend.data.ClientPrefs;
#if DISCORD_ALLOWED
import backend.api.DiscordClient;
#end
import objects.ui.ClickableText;
import backend.Controls;
import backend.data.Constants;
import backend.util.CacheUtil;
import backend.util.GeneralUtil;
import backend.util.PathUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * State that displays the main menu.
 */
class MainMenuState extends FlxTransitionableState {
    
    var titleText:FlxText;
    var introText:FlxText;
    var pressAnyKeyText:FlxText;

    var introStageTimer1:FlxTimer = new FlxTimer();
    var introStageTimer2:FlxTimer = new FlxTimer();

    var chosenSplashText:Array<String> = Constants.SPLASH_TEXTS[FlxG.random.int(0, Constants.SPLASH_TEXTS.length - 1)];

    var flashbang:FlxSprite;

    var goofyAhhTroll:FlxSprite;
    var dumbassBitch:FlxSprite;

    var buttons:Array<String> = [
        'Campaign',
        'Options',
        'Quit Game'
    ];
    var buttonClickFunctions:Map<String, Void -> Void>;
    var buttonGroup:FlxTypedGroup<ClickableText>;
    var buttonWasClicked:Bool = false;

    override public function create() {

        // Start the main menu music
        GeneralUtil.playMenuMusic();

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

        // Setup and add the goofy goober that is shown on the main menu
        goofyAhhTroll = new FlxSprite(0, 0);
        goofyAhhTroll.loadGraphic(PathUtil.ofImage('intro_troll'));
        goofyAhhTroll.updateHitbox();
        goofyAhhTroll.x = FlxG.width + goofyAhhTroll.width;
        goofyAhhTroll.y = FlxG.height - goofyAhhTroll.height - 40;
        add(goofyAhhTroll);

        dumbassBitch = new FlxSprite();
        dumbassBitch.loadGraphic(PathUtil.ofImage('dumbass-bitch'));
        dumbassBitch.scale.set(0.5, 0.5);
        dumbassBitch.updateHitbox();
        dumbassBitch.x = (FlxG.width / 2) - (dumbassBitch.width / 2);
        dumbassBitch.y = (FlxG.height / 2) + 80;
        dumbassBitch.visible = false;
        add(dumbassBitch);

        // Setup the button group
        buttonGroup = new FlxTypedGroup<ClickableText>();
        buttonGroup.visible = false;
        add(buttonGroup);

        // Assign all of the functions that get ran when
        // the said button is clicked
        buttonClickFunctions = [
            'Campaign' => () -> {
                _centerButton(buttonGroup.members[0]);
                new FlxTimer().start(1, (_) -> {
                    GeneralUtil.fadeIntoState(new CampaignMenuState(), Constants.TRANSITION_DURATION, false); 
                });
            },
            'Options' => () -> { 
                _centerButton(buttonGroup.members[1]);
                new FlxTimer().start(1, (_) -> {
                    GeneralUtil.fadeIntoState(new OptionsMenuState(), Constants.TRANSITION_DURATION, false); 
                });
            },
            'Quit Game' => () -> {
                _centerButton(buttonGroup.members[2]);
                var canDisplayEasterEgg = FlxG.random.int(1, 5) == 3;
                new FlxTimer().start((!canDisplayEasterEgg) ? 1 : 3, (_) -> {
                    if (canDisplayEasterEgg) {  // An easter egg shhhhhh
                        FlxG.sound.music.stop();
                        goofyAhhTroll.loadGraphic(PathUtil.ofImage('my_pc_now_weighs_42_tons'));
                        goofyAhhTroll.scale.set(2.3, 2.3);
                        FlxG.sound.play(PathUtil.ofSound('caseoh-nooooo'));
                        // Add a timer so the user can get the caseoh jumpscare lol
                        new FlxTimer().start(0.6, (timer:FlxTimer) -> {
                            GeneralUtil.closeGame();
                        });
                    } else {
                        // Just close the game if the user didn't get
                        // the caseoh easter egg *sob*
                        GeneralUtil.closeGame();
                    }
                });    
            }
        ];

        // Setup the buttons for the selection screen
        var newY:Float = (FlxG.height / 2) + 20;
        for (btn in buttons) {
            var coolSwaggerButton = new ClickableText(80, newY, btn);
            coolSwaggerButton.size = 45;
            coolSwaggerButton.updateHitbox();
            coolSwaggerButton.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3);
            coolSwaggerButton.setHoverBounds(80, (80 + coolSwaggerButton.width), newY, newY + coolSwaggerButton.height);
            coolSwaggerButton.onHover = () -> {
                if (!buttonWasClicked) {
                    // Play a sound
                    FlxG.sound.play(PathUtil.ofSound('blip'));
                    // Tween the button to move to the right of the screen
                    FlxTween.cancelTweensOf(coolSwaggerButton);
                    FlxTween.tween(coolSwaggerButton, { x: 200 }, 0.2, {
                        type: FlxTweenType.PERSIST,
                        ease: FlxEase.quadOut
                    });
                }
            };
            coolSwaggerButton.onHoverLost = () -> {
                if (!buttonWasClicked) {
                    // Tween the button to move to the right of the screen
                    FlxTween.cancelTweensOf(coolSwaggerButton);
                    FlxTween.tween(coolSwaggerButton, { x: 80 }, 0.2, {
                        type: FlxTweenType.PERSIST,
                        ease: FlxEase.quadOut
                    });
                }
            };
            coolSwaggerButton.onClick = buttonClickFunctions.get(btn);
            buttonGroup.add(coolSwaggerButton);
            newY += 80;
        }

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
        if (CacheUtil.canSkipIntro) {
            FlxTween.tween(pressAnyKeyText, { alpha: 1 }, 2, {
                type: FlxTweenType.ONESHOT
            });
        }

        // Set the Discord rich presence
        #if DISCORD_ALLOWED
        if (ClientPrefs.options.discordRPC) {
            DiscordClient.setPresence('Viewing Main Menu');
        }
        #end

        // Start the intro if the player hasn't seen it yet
        // (This is for when the player goes back to the main menu)
        if (!CacheUtil.alreadySawIntro) {
            _startIntro();
        } else {
            _setupMainMenu();
        }
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        // If the player hasn't seen the intro yet, they can skip it by pressing any key
        // (excluding the fullscreen and volume binds)
        if (!CacheUtil.alreadySawIntro && CacheUtil.canSkipIntro) {
            if (FlxG.keys.justPressed.ANY && !(Controls.binds.FULLSCREEN_JUST_PRESSED || Controls.justPressedAnyVolumeKeys())) {
                _setupMainMenu();
            }
        }

        // If the user presses the back button, then
        // just simply close the game :p
		if (Controls.binds.UI_BACK_JUST_PRESSED) {
            GeneralUtil.closeGame();
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
                dumbassBitch.visible = true;
            case (3):
                _setIntroText('');
                dumbassBitch.visible = false;
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
        buttonGroup.visible = true;
        dumbassBitch.visible = false;

        FlxG.camera.bgColor = FlxColor.WHITE;

        introStageTimer1.cancel();
        introStageTimer2.cancel();

        flashbang.alpha = 1;
        FlxTween.tween(flashbang, { alpha: 0 }, 3, {
            type: FlxTweenType.ONESHOT
        });

        CacheUtil.alreadySawIntro = true;
        CacheUtil.canSkipIntro = true;

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

    private function _centerButton(b:ClickableText):Void {
        // Play a goofy sound lol
        FlxG.sound.play(PathUtil.ofSound('vine-boom'));
        // Make sure any other button doesn't tween after being centered!
        buttonWasClicked = true;
        // Center the clicked button to make it the 
        // :sparkles: ***m a i n  f o c u s*** :sparkles:
        FlxTween.tween(b, { x: (FlxG.width / 2) - (b.width / 2), y: (FlxG.height / 2) - (b.height / 2), size: 60 }, 0.3, {
            type: FlxTweenType.ONESHOT,
            ease: FlxEase.quadOut
        });
    }
}
