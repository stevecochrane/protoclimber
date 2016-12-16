package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxBar;
import flixel.util.FlxDestroyUtil;

class PlayState extends FlxState {

    private var chargeBar:FlxBar;
    private var level:TiledLevel;
    private var staminaBar:FlxBar;

    override public function create():Void {

        super.create();

        level = TiledLevel.loadLevel(1, this);

        FlxG.camera.follow(Player.player);
        FlxG.camera.pixelPerfectRender = true;

        staminaBar = new FlxBar(8, FlxG.height - 16, FlxBarFillDirection.LEFT_TO_RIGHT, 96, 8, Player.player, "stamina", 0, Player.staminaMax);
        staminaBar.createImageBar(Assets.IMG_STAMINA_BAR_EMPTY, Assets.IMG_STAMINA_BAR_FULL);
        staminaBar.scrollFactor.set(0, 0);

        // chargeBar = new FlxBar(8, FlxG.height - 32, FlxBarFillDirection.LEFT_TO_RIGHT, 80, 8, player, "charge", 0, 100);
        // chargeBar.createFilledBar(0xff000000, 0xffffffff, true, 0xffffffff);
        // chargeBar.scrollFactor.set(0, 0);

        add(level.backgroundTiles);
        add(Groups.climbZones);
        add(Groups.avalancheGenerators);
        add(Player.player);
        add(level.foregroundTiles);
        add(Groups.hazardCircles);
        add(Groups.avalancheFallingIce);
        add(staminaBar);
        // add(chargeBar);

    }

    override public function destroy():Void {
        super.destroy();

        // chargeBar = FlxDestroyUtil.destroy(chargeBar);
        staminaBar = FlxDestroyUtil.destroy(staminaBar);
    }

    override public function update(elapsed:Float):Void {

        super.update(elapsed);

        FlxG.collide(level.foregroundTiles, Player.player);
        FlxG.overlap(Groups.avalancheFallingIce, Player.player, Player.collisionHurtPlayer);

    }

}
