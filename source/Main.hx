package;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flixel.FlxGame;
import flixel.FlxState;

class Main extends Sprite {

    private var gameWidth:Int = 400;                        // Width of the game in pixels
    private var gameHeight:Int = 240;                       // Height of the game in pixels
    private var initialState:Class<FlxState> = PlayState;    // The FlxState the game starts with.
    private var framerate:Int = 60;                         // How many frames per second the game should run at.
    private var skipSplash:Bool = true;                     // Whether to skip the flixel splash screen that appears in release mode.
    private var startFullscreen:Bool = true;                // Whether to start the game in fullscreen on desktop targets

    // You can pretty much ignore everything from here on - your code should go in your states.

    public static function main():Void {
        Lib.current.addChild(new Main());
    }

    public function new() {
        super();

        if (stage != null) {
            init();
        } else {
            addEventListener(Event.ADDED_TO_STAGE, init);
        }
    }

    private function init(?E:Event):Void {
        if (hasEventListener(Event.ADDED_TO_STAGE)) {
            removeEventListener(Event.ADDED_TO_STAGE, init);
        }

        setupGame();
    }

    private function setupGame():Void {
        var stageWidth:Int = Lib.current.stage.stageWidth;
        var stageHeight:Int = Lib.current.stage.stageHeight;

        var ratioX:Float = stageWidth / gameWidth;
        var ratioY:Float = stageHeight / gameHeight;
        var zoom:Float = Math.min(ratioX, ratioY);
        gameWidth = Math.ceil(stageWidth / zoom);
        gameHeight = Math.ceil(stageHeight / zoom);

        addChild(new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, startFullscreen));
    }
}
