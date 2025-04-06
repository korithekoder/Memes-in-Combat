package states;

import flixel.util.FlxTimer;
import flixel.sound.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxCamera;
import flixel.graphics.frames.FlxAtlasFrames;
import objects.gameplay.MapTile;
import flixel.group.FlxGroup.FlxTypedGroup;
import backend.util.PathUtil;
import flixel.FlxG;
import objects.ui.DialogueBox;
import backend.Controls;
import backend.data.Constants;
import backend.util.CacheUtil;
import backend.util.GeneralUtil;
import flixel.addons.transition.FlxTransitionableState;
import states.menus.CampaignMenuState;

/**
 * State where the cool gameplay happens.
 */
class PlayState extends FlxTransitionableState {

	// Dialogue box that can show up during the game
	var dialogueBox:DialogueBox;

	// Current directories to the current year's
	// map spritesheet image and .xml files
	var currentMapPaths:Array<String>;

	// Tile shit
	var tileMapGroup:FlxTypedGroup<MapTile>;
	var tileTypes:Array<Dynamic> = [];

	// Cameras
	var mapCamera:FlxCamera;

	// Mouse dragging variables
	var isDragging:Bool = false;
	var lastMousePos:FlxPoint;

	// Add a fadeout overlay 
	// because HaxeFlixel doesn't like it when 
	// I add new cameras and won't fade into the 
	// play state properly >:(
	var fadeoutOverlay:FlxSprite;

	// The current soundtrack playing for the game
	// (this is for just obtaining the length of the soundtrack to
	// know when to play another soundtrack)
	var currentSoundtrack:FlxSound;

	override public function create() {
		super.create();

		// Make sure the game plays the menu music when going back
		// to the menus
		CacheUtil.canPlayMenuMusic = true;

		// Assign the last mouse position
		lastMousePos = new FlxPoint();

		// Assign the cameras
		mapCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		// mapCamera.alpha = 0;
		FlxG.cameras.add(mapCamera);

		// Assign the paths to the map's spritesheet
		currentMapPaths = PathUtil.ofSpriteSheet('campaign-maps/${CacheUtil.currentYearMetadata.mapinfo.spritesheet}');

		// Assign the tile types
		tileTypes = CacheUtil.currentYearLevelData.tiletypes;

		currentSoundtrack = new FlxSound();

		// Setup the tile map group
		tileMapGroup = new FlxTypedGroup<MapTile>();
		tileMapGroup.camera = mapCamera;
		add(tileMapGroup);

		// Create the tile map
		for (x in 0...CacheUtil.currentYearLevelData.size.width) {
			for (y in 0...CacheUtil.currentYearLevelData.size.height) {
				// If you set the coords to be [x][y] instead of [y][x], it will
				// rotate the whole map clockwise 90 degrees.
				// I don't know why I wanted to say that, just something
				// I found while developing the game :p
				// - Kori, 4/4/2025

				// The current tile in the looped array(s)
				var currentTile:Dynamic = CacheUtil.currentYearMapData[y][x];
				// The type of tile that the current tile is of
				var tileType:Dynamic = _getTileTypeById(currentTile.id);
				// The tile to add to the map grid
				var tile:MapTile = new MapTile(x, y, currentTile.rotation, tileType);

				// Set the frames for the new map tile
				// TODO: Maybe try to make this more efficient by
				// *only* adding the specific frames needed in the future?
				tile.frames = FlxAtlasFrames.fromSparrow(currentMapPaths[0], currentMapPaths[1]);

				// Add the frames and set the prefix
				// If the tile is set as not animated OR
				// if the frames is less than or equal to 0, then
				// it will not have any frames!
				var animFrames:Array<Int> = [];
				var prefix = '${currentTile.id}_';
				if (!(tileType.frames <= 0) && tileType.animated) {
					for (i in 0...tileType.frames) {
						animFrames.push(i);
					}
				} else {
					animFrames = [0];
				}
				
				// Add the animation
				tile.animation.addByIndices(currentTile.id, prefix, animFrames, '', 7, true);
				// Play the animation
				tile.animation.play(currentTile.id);
				// Add the tile to the map
				tileMapGroup.add(tile);
			}
		}

		// Add the dialogue box to the game
		// (this can be reassigned at any time for a new dialogue box)
		dialogueBox = new DialogueBox('Tutorial-Start', 'troll');
		dialogueBox.onDialogueComplete = () -> {
			_playRandomSoundtrack();
		};
		add(dialogueBox);

		// Add the fadeout overlay
		// (make sure this is the last thing added!!!)
		fadeoutOverlay = new FlxSprite(0, 0);
		fadeoutOverlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(fadeoutOverlay);

		// Tween the fadeout overlay to be transparent
		FlxTween.tween(fadeoutOverlay, { alpha: 0 }, Constants.TRANSITION_DURATION, { type: FlxTweenType.ONESHOT });
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (CacheUtil.isDialogueFinished) {
			if (Controls.binds.UI_BACK_JUST_PRESSED) {
				GeneralUtil.fadeIntoState(new CampaignMenuState(), Constants.TRANSITION_DURATION, false);
			}

			if (FlxG.mouse.pressed) {
				// For dragging around the map
				if (!isDragging) {
					// Start dragging
					isDragging = true;
					lastMousePos.set(FlxG.mouse.viewX, FlxG.mouse.viewY);
				} else {
					// Calculate mouse movement delta
					var dx = FlxG.mouse.viewX - lastMousePos.x;
					var dy = FlxG.mouse.viewY - lastMousePos.y;
		
					// Move the camera
					mapCamera.scroll.x -= dx;
					mapCamera.scroll.y -= dy;
		
					// Update last mouse position
					lastMousePos.set(FlxG.mouse.viewX, FlxG.mouse.viewY);
				}
			} else {
				isDragging = false;
			}

			// If the camera move controls are being held down,
			// move the camera accordingly
			if (Controls.binds.CAM_UP_PRESSED) {
				mapCamera.scroll.y -= Constants.MAP_CAMERA_MOVE_SPEED;
			}
			if (Controls.binds.CAM_LEFT_PRESSED) {
				mapCamera.scroll.x -= Constants.MAP_CAMERA_MOVE_SPEED;
			}
			if (Controls.binds.CAM_DOWN_PRESSED) {
				mapCamera.scroll.y += Constants.MAP_CAMERA_MOVE_SPEED;
			}
			if (Controls.binds.CAM_RIGHT_PRESSED) {
				mapCamera.scroll.x += Constants.MAP_CAMERA_MOVE_SPEED;
			}

			if (FlxG.mouse.wheel != 0) {
				// Zoom in or out based on mouse wheel movement
				if (FlxG.mouse.wheel > 0) {
					mapCamera.zoom += Constants.MAP_CAMERA_ZOOM_INCREMENT;
				} else {
					mapCamera.zoom -= Constants.MAP_CAMERA_ZOOM_INCREMENT;
				}
			}
		}
	}

	private function _getTileTypeById(id:String):Dynamic {
		for (tileType in tileTypes) {
			if (tileType.id == id) {
				return tileType;
			}
		}
		return null;
	}

	private function _playRandomSoundtrack():Void {
		// Select a random soundtrack from the current year's soundtracks
		var selectedSoundtrack:String = CacheUtil.currentYearSoundtracks[FlxG.random.int(0, CacheUtil.currentYearSoundtracks.length - 1)];
		// Get the current soundtrack (this is for getting the length of the soundtrack)
		currentSoundtrack.loadEmbedded(PathUtil.ofMusic(selectedSoundtrack), false, false);
		// Play the soundtrack
		FlxG.sound.playMusic(PathUtil.ofMusic(selectedSoundtrack), false);
		// Start a timer that, when it ends, will play a new soundtrack
		new FlxTimer().start(currentSoundtrack.length / 1000, (_) -> {
			_playRandomSoundtrack();
		});
	}
}
