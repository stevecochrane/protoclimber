package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;

class Player extends FlxSprite {

    private var gamepad:FlxGamepad;

    public function new(X:Float, Y:Float) {

        super(X, Y);

        maxVelocity.x = 200;
        maxVelocity.y = 200;

        acceleration.x = 0;
        acceleration.y = 0;

        drag.x = 800;
        drag.y = 800;

        makeGraphic(16, 24, FlxColor.WHITE);

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);

        width = 16;
        height = 24;

        //  Adjust the starting position now that we have the offsets.
        //  Generally the Tiled object is 2 tiles wide, so add half the difference between the width (20) and 2 tiles (32).
        x += 6;
        //  Similar for the starting y, take the height of the Tiled object (32) and subtract the height (28).
        y += 4;

        FlxG.watch.add(this.acceleration, "x", "acceleration.x");
        FlxG.watch.add(this.acceleration, "y", "acceleration.y");
        FlxG.watch.add(this.maxVelocity, "x", "maxVelocity.x");
        FlxG.watch.add(this.maxVelocity, "y", "maxVelocity.y");
        FlxG.watch.add(this.velocity, "x", "velocity.x");
        FlxG.watch.add(this.velocity, "y", "velocity.y");

    }

    override public function destroy():Void {
        super.destroy();
    }

    override public function update(elapsed:Float):Void {

        /*gamepad = FlxG.gamepads.lastActive;
        if (gamepad != null) {
            updateGamepadInput(gamepad);
        }*/
        updateKeyboardInput();

        super.update(elapsed);

    }

    private function updateGamepadInput(gamepad:FlxGamepad):Void {

        if (gamepad.justPressed.DPAD_UP)    { justPressedUp();    }
        if (gamepad.justPressed.DPAD_DOWN)  { justPressedDown();  }
        if (gamepad.justPressed.DPAD_RIGHT) { justPressedRight(); }
        if (gamepad.justPressed.DPAD_LEFT)  { justPressedLeft();  }
        if (gamepad.justPressed.B)          { justPressedB();     }
        if (gamepad.justPressed.A)          { justPressedA();     }

        if (gamepad.pressed.DPAD_UP)        { pressedUp();        }
        if (gamepad.pressed.DPAD_DOWN)      { pressedDown();      }
        if (gamepad.pressed.DPAD_RIGHT)     { pressedRight();     }
        if (gamepad.pressed.DPAD_LEFT)      { pressedLeft();      }

    }

    private function updateKeyboardInput():Void {

        if (FlxG.keys.anyJustPressed(KeyMappings.getDPadUp()))    { justPressedUp();    }
        if (FlxG.keys.anyJustPressed(KeyMappings.getDPadDown()))  { justPressedDown();  }
        if (FlxG.keys.anyJustPressed(KeyMappings.getDPadRight())) { justPressedRight(); }
        if (FlxG.keys.anyJustPressed(KeyMappings.getDPadLeft()))  { justPressedLeft();  }
        if (FlxG.keys.anyJustPressed(KeyMappings.getB()))         { justPressedB();     }
        if (FlxG.keys.anyJustPressed(KeyMappings.getA()))         { justPressedA();     }

        if (FlxG.keys.anyPressed(KeyMappings.getDPadUp()))        { pressedUp();        }
        if (FlxG.keys.anyPressed(KeyMappings.getDPadDown()))      { pressedDown();      }
        if (FlxG.keys.anyPressed(KeyMappings.getDPadRight()))     { pressedRight();     }
        if (FlxG.keys.anyPressed(KeyMappings.getDPadLeft()))      { pressedLeft();      }

    }

    private function justPressedUp():Void {}
    private function justPressedDown():Void {}
    private function justPressedRight():Void {}
    private function justPressedLeft():Void {}

    private function justPressedB():Void {
        velocity.x -= maxVelocity.x;

        if (FlxG.keys.anyPressed(KeyMappings.getDPadUp())) {
            velocity.y -= maxVelocity.y;
        } else if (FlxG.keys.anyPressed(KeyMappings.getDPadDown())) {
            velocity.y += maxVelocity.y;
        }
    }

    private function justPressedA():Void {
        velocity.x += maxVelocity.x;

        if (FlxG.keys.anyPressed(KeyMappings.getDPadUp())) {
            velocity.y -= maxVelocity.y;
        } else if (FlxG.keys.anyPressed(KeyMappings.getDPadDown())) {
            velocity.y += maxVelocity.y;
        }
    }

    private function pressedUp():Void {}
    private function pressedDown():Void {}
    private function pressedRight():Void {}
    private function pressedLeft():Void {}

}
