package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxBar;
import flixel.util.FlxDestroyUtil;

class PlayState extends FlxState {

    private var level:TiledLevel;
    private var player:Player;
    private var staminaBar:FlxBar;

    override public function create():Void {

        super.create();

        level = TiledLevel.loadLevel(1, this);

        player = new Player(32, 608);

        FlxG.camera.follow(player);

        staminaBar = new FlxBar(8, FlxG.height - 16, FlxBarFillDirection.LEFT_TO_RIGHT, 80, 8, player, "stamina", 0, 100);
        staminaBar.createFilledBar(0xff000000, 0xffffffff, true, 0xffffffff);
        staminaBar.scrollFactor.set(0, 0);

        add(level.backgroundTiles);
        add(player); //  Player needs to be below pickaxes or weird unexplained things will happen
        add(level.foregroundTiles);
        add(staminaBar);

    }

    override public function destroy():Void {
        super.destroy();

        player = FlxDestroyUtil.destroy(player);
        staminaBar = FlxDestroyUtil.destroy(staminaBar);
    }

    override public function update(elapsed:Float):Void {

        super.update(elapsed);

        FlxG.collide(level.foregroundTiles, player);

    }

}
