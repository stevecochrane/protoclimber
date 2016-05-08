package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxDestroyUtil;

class PlayState extends FlxState {

    private var level:TiledLevel;
    private var player:Player;

    override public function create():Void {

        super.create();

        level = TiledLevel.loadLevel(1, this);

        player = new Player(32, 608);

        FlxG.camera.follow(player);

        add(level.backgroundTiles);
        add(player); //  Player needs to be below pickaxes or weird unexplained things will happen
        add(level.foregroundTiles);

    }

    override public function destroy():Void {
        super.destroy();
    }

    override public function update(elapsed:Float):Void {

        super.update(elapsed);

        FlxG.collide(level.foregroundTiles, player);

    }

}
