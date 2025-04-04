package states;

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

	var dialogueBox:DialogueBox;

	var currentMapPaths:Array<String>;

	var tileMapGroup:FlxTypedGroup<MapTile>;
	var tileTypes:Array<Dynamic> = [];

	override public function create() {
		super.create();

		// Make sure the game plays the menu music when going back
		// to the menus
		CacheUtil.canPlayMenuMusic = true;

		// Assign the paths to the map's spritesheet
		currentMapPaths = PathUtil.ofSpriteSheet('campaign-maps/${CacheUtil.currentYearMetadata.mapinfo.spritesheet}');

		// Assign the tile types
		tileTypes = CacheUtil.currentYearLevelData.tiletypes;

		// Setup the tile map group
		tileMapGroup = new FlxTypedGroup<MapTile>();
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

		dialogueBox = new DialogueBox('Tutorial-Start', 'troll');
		dialogueBox.onDialogueComplete = () -> {
			var selectedSoundtrack:String = CacheUtil.currentYearSoundtracks[FlxG.random.int(0, CacheUtil.currentYearSoundtracks.length)];
			FlxG.sound.playMusic(PathUtil.ofMusic(selectedSoundtrack));
		};
		add(dialogueBox);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (CacheUtil.isDialogueFinished) {
			if (Controls.binds.UI_BACK_JUST_PRESSED) {
				GeneralUtil.fadeIntoState(new CampaignMenuState(), Constants.TRANSITION_DURATION, false);
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
}
