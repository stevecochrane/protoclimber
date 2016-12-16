package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;

class AvalancheGenerator extends FlxSprite {

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
        if (isOnScreen()) {
            Groups.avalanches.recycle(Avalanche).init(x + (width / 2), FlxG.camera.scroll.y);
        }
    }
}
