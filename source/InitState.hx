package;

import backend.Controls;
import backend.data.ClientPrefs;
import backend.data.Constants;
import backend.util.CacheUtil;
import backend.util.PathUtil;
import backend.util.SaveUtil;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.math.FlxMath;
import flixel.system.FlxAssets;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import openfl.Lib;
import openfl.display.StageScaleMode;
import openfl.events.KeyboardEvent;
import states.menus.MainMenuState;
#if DISCORD_ALLOWED
import backend.api.DiscordClient;
#end

/**
 * The initial state of the game. This is where
 * you can load assets and set up the game.
 */
class InitState extends FlxState {

	override public function create() {
		// Set up the system configuration
		_flxSystemConfig();

		// Add event listeners
		_addEventListeners();

		// Load the client's preferences and their options
		// Removing this line will cause a bunch of null errors,
		// so it's extremely important to keep this line here!
		ClientPrefs.loadAll();

		// Setup Discord rich presence
		#if DISCORD_ALLOWED
		if (ClientPrefs.options.discordRPC) {
			DiscordClient.setup();
		}
		#end

		// Center the window to be in the middle of the display
		Application.current.window.x = Std.int((Application.current.window.display.bounds.width - Application.current.window.width) / 2);
		Application.current.window.y = Std.int((Application.current.window.display.bounds.height - Application.current.window.height) / 2);

		// Switch to the main menu state after everything is set up and fully loaded
		FlxG.switchState(() -> new MainMenuState());
	}

	private static function _flxSystemConfig():Void {
		// Set the cursor to be the system default
		FlxG.mouse.useSystemCursor = true;

		// Set auto pause to false
		FlxG.autoPause = false;

		// Set the default font
		FlxAssets.FONT_DEFAULT = PathUtil.ofFont('impact');

		// Set the stage and scaling modes
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

		// Set the transition effect when switching states
		FlxTransitionableState.defaultTransIn = new TransitionData(FlxColor.BLACK, Constants.TRANSITION_DURATION);
	}

	private static function _addEventListeners():Void {
		#if desktop
		// Fullscreen :sparkles:
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, (event:KeyboardEvent) -> {
			// Toggle fullscreen when the user presses the fullscreen bind
			if (Controls.binds.FULLSCREEN_JUST_PRESSED) {
				FlxG.fullscreen = !FlxG.fullscreen;
			}
		});

		// Minimize volume when the window is out of focus
		Application.current.window.onFocusIn.add(() -> {
			// Set back to one decimal place (0.1) when the screen gains focus again
			// (note that if the user had the volume all the way down, it will be set to zero)
			FlxG.sound.volume = (!(Math.abs(FlxG.sound.volume) < FlxMath.EPSILON)) ? 0.1 : 0;
			CacheUtil.isFocused = true;
			// Set the volume back to the last volume used
			FlxTween.num(FlxG.sound.volume, CacheUtil.lastVolumeUsed, 0.3, {type: FlxTweenType.ONESHOT}, (v) -> {
				FlxG.sound.volume = v;
			});
		});
		Application.current.window.onFocusOut.add(() -> {
			// Minimize the volume when the window loses focus
			if (ClientPrefs.options.minimizeVolume) {
				// Set the last volume used to the current volume
				CacheUtil.lastVolumeUsed = FlxG.sound.volume;
				CacheUtil.isFocused = false;
				// Tween the volume to 0.03
				FlxTween.num(FlxG.sound.volume, (!(Math.abs(FlxG.sound.volume) < FlxMath.EPSILON)) ? 0.03 : 0, 0.3, {type: FlxTweenType.ONESHOT}, (v) -> {
					FlxG.sound.volume = v;
				});
			}
		});
		#end

		// Do shit like saving the user's data when the game closes
		Application.current.window.onClose.add(() -> {
			// Save all of the user's data
			SaveUtil.saveAll();
		});
	}
}
