package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;

class HazardCircle extends FlxSprite {

    private var tiles:Float = 0;

    public function new(X:Float, Y:Float, theTiles:Float) {

        super(X, Y);

        tiles = theTiles;

        width = 16;
        height = 16;

        makeGraphic(Std.int(width), Std.int(height), 0xFFA81000);
        immovable = true;

        FlxTween.circularMotion(this, x, y, tiles * 16, 0, true, 4, true, { type: LOOPING });

    }

    override public function destroy():Void {
        super.destroy();
    }

    override public function update(elapsed:Float):Void {
        // Do stuff
        super.update(elapsed);
    }
}
