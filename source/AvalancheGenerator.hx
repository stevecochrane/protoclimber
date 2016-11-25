package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;

class AvalancheGenerator extends FlxSprite {

    private static var fallingIceGroup:FlxTypedGroup<AvalancheFallingIce> = new FlxTypedGroup<AvalancheFallingIce>();

    private var midpoint:FlxPoint;
    private var phase:Float = 0;
    private var timer:Float = 0;

    public function new(X:Float, Y:Float, theWidth:Float, theHeight:Float, thePhase:Float) {

        super(X, Y);

        phase = thePhase;
        timer = phase;

        width = theWidth;
        height = theHeight;

        alpha = 0;
        makeGraphic(Std.int(width), Std.int(height), 0xFFFF0000);
        immovable = true;

    }

    override public function destroy():Void {
        super.destroy();
        fallingIceGroup = FlxDestroyUtil.destroy(fallingIceGroup);
        midpoint = FlxDestroyUtil.destroy(midpoint);
    }

    override public function update(elapsed:Float):Void {
        timer += elapsed;
        if (timer >= 4) {
            dropIceIfInRange();
            timer = 0;
        }
        super.update(elapsed);
    }

    private function dropIceIfInRange():Void {
        //  Check if this is within the current camera bounds. If so, drop some ice, if not, don't.
        if (isOnScreen()) {
            getMidpoint(midpoint);
            fallingIceGroup.recycle(AvalancheFallingIce).init(midpoint);
        }
    }
}
