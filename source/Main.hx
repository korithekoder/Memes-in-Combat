package;

import flixel.FlxGame;
import openfl.display.Sprite;

/**
 * The main entry point of the game. You don't need to modify this class.
 * If you want to change the setup for the game, you can do so by changing
 * the `InitState.hx` class and doing whatever you want from there.
 */
class Main extends Sprite {

	// The game object that holds the data
	// for the FlxGame instance
	private static final _GAME:Dynamic = {
		// The width of the game's window
		width: 0,
		// The height of the game's window
		height: 0,
		// The class that will be used as the initial state
		initialState: InitState,
		// The framerate of the game
		framerate: 60,
		// Should the game skip the HaxeFlixel splash screen?
		skipSplash: true,
		// Should the game start in fullscreen mode?
		startFullscreen: false
	};

	public function new() {
		super();
		addChild(new FlxGame(
			_GAME.width,
			_GAME.height,
			_GAME.initialState,
			_GAME.framerate,
			_GAME.framerate,
			_GAME.skipSplash,
			_GAME.startFullscreen
		));
	}
}
