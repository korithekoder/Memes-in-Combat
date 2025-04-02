package backend.api;

#if DISCORD_ALLOWED
import flixel.FlxG;
import cpp.RawConstPointer;
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types.DiscordRichPresence;
import lime.app.Application;
import sys.thread.Thread;

/**
 * Class that handles Discord rich presence for the client's
 * "Activity" box.
 */
class DiscordClient {

    private static var _presence:DiscordRichPresence = new DiscordRichPresence();
    private static var _clientId:String = '1350914945704923288';  // Client ID for the Discord application

    /**
     * Initializes Discord rich presence.
     */
    public static function setup():Void {
        // Initialize the client
        Discord.Initialize(_clientId, null, true, null);
        // Start the timer (for the amount of time the player has played the game)
        _presence.startTimestamp = Math.floor(Sys.time());

        // Start a thread that runs in the background which
        // makes regular callbacks to Discord
        Thread.create(() -> {
            // Keep looping until the game exits
            while (true) {
                // Update rich presence
                Discord.RunCallbacks();
                // Wait for one second so the game doesn't crash lol
                Sys.sleep(1.0);
            }
        });

        // Add an event listener that shuts down Discord rich presence
        // when the game closes
        Application.current.window.onClose.add(() -> {
            shutdown();
        });
    }

    /**
     * Shutdowns Discord rich presence.
     */
    public static function shutdown():Void {
        Discord.Shutdown();
        FlxG.log.add('Discord rich presence shut down successfully!');
    }

    /**
     * Set the game's Discord rich presence.
     * 
     * @param details       The details of the current presence.
     * @param state         The state of the current presence.
     * @param largeImageKey The ID of the large image to be set.
     */
    public static function setPresence(details:String = 'i wasnt set lmao get reked', state:String = '', largeImageKey:String = 'main_icon'):Void {
        _presence.details = details;
        _presence.state = state;
        _presence.largeImageKey = largeImageKey;
        Discord.UpdatePresence(RawConstPointer.addressOf(_presence));
    }
}
#end
