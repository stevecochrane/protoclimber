package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;

class HazardCircle extends FlxSprite {

    public function new(X:Float, Y:Float) {

        super(X, Y);

        width = 16;
        height = 16;

        makeGraphic(Std.int(width), Std.int(height), 0xFFFF0000);
        immovable = true;

    }

    override public function destroy():Void {
        super.destroy();
    }

    override public function update(elapsed:Float):Void {
        // Do stuff
        super.update(elapsed);
    }
}
