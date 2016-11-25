package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxBar;
import flixel.util.FlxDestroyUtil;

class PlayState extends FlxState {

    private var chargeBar:FlxBar;
    private var level:TiledLevel;
    private var player:Player;
    private var staminaBar:FlxBar;

    override public function create():Void {

        super.create();

        level = TiledLevel.loadLevel(1, this);

        player = new Player(32, 608);

        FlxG.camera.follow(player);
        FlxG.camera.pixelPerfectRender = true;

        staminaBar = new FlxBar(8, FlxG.height - 16, FlxBarFillDirection.LEFT_TO_RIGHT, 96, 8, player, "stamina", 0, player.staminaMax);
        staminaBar.createImageBar(Assets.IMG_STAMINA_BAR_EMPTY, Assets.IMG_STAMINA_BAR_FULL);
        staminaBar.scrollFactor.set(0, 0);

        // chargeBar = new FlxBar(8, FlxG.height - 32, FlxBarFillDirection.LEFT_TO_RIGHT, 80, 8, player, "charge", 0, 100);
        // chargeBar.createFilledBar(0xff000000, 0xffffffff, true, 0xffffffff);
        // chargeBar.scrollFactor.set(0, 0);

        add(level.backgroundTiles);
        add(Groups.climbZones);
        add(Groups.avalancheGenerators);
        add(player);
        add(level.foregroundTiles);
        add(Groups.avalancheFallingIce);
        add(staminaBar);
        // add(chargeBar);

    }

    override public function destroy():Void {
        super.destroy();

        // chargeBar = FlxDestroyUtil.destroy(chargeBar);
        player = FlxDestroyUtil.destroy(player);
        staminaBar = FlxDestroyUtil.destroy(staminaBar);
    }

    override public function update(elapsed:Float):Void {

        super.update(elapsed);

        FlxG.collide(level.foregroundTiles, player);

    }

}
