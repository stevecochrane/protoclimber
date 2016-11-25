package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;

class AvalancheFallingIce extends FlxSprite {

    private var hasFallenFromTop:Bool = false;

    public function new() {
        super(0, 0);

        acceleration.y = 400;
        maxVelocity.y = 400;

        makeGraphic(36, 36, 0xFFFFFFFF);

        width = 24;
        height = 24;
        offset.x = 6;
        offset.y = 6;
    }

    override public function destroy():Void {
        super.destroy();
    }

    public function init(location:FlxPoint):Void {
        super.reset(location.x - (width / 2), location.y - (height / 2));
        hasFallenFromTop = false;
    }

    override public function update(elapsed:Float):Void {
        if (!hasFallenFromTop && velocity.y > (maxVelocity.y * 0.6667)) {
            hasFallenFromTop = true;
        }
        if (hasFallenFromTop && !isOnScreen()) {
            kill();
        }
        super.update(elapsed);
    }
}
