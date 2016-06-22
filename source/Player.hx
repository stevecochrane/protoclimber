package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;

class Player extends FlxSprite {

    public var charge:Float;
    public var stamina:Float;

    private var baseMoveVelocity:Float;
    private var baseJumpVelocity:Float;
    private var chargeTimer:Float;
    private var gamepad:FlxGamepad;
    private var isCharging:Bool;
    private var isClimbing:Bool;
    private var isGrabbingTheWall:Bool;
    private var isGrabbingTheWallDelayActive:Bool;
    private var isGrabbingTheWallDelayTimer:Float;
    private var isOnGround:Bool;
    private var lockedVelocityX:Float;
    private var staminaTimer:Float;
    private var velocityFactor:Float;

    public function new(X:Float, Y:Float) {

        super(X, Y);

        //maxVelocity.x = 200;
        //maxVelocity.y = 200;
        baseMoveVelocity = 40;
        baseJumpVelocity = 200;
        velocityFactor = baseJumpVelocity;
        lockedVelocityX = 0;

        acceleration.x = 0;
        acceleration.y = 0;

        drag.x = 800;
        drag.y = 800;

        makeGraphic(16, 24, FlxColor.WHITE);

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);

        width = 16;
        height = 24;

        stamina = 100;
        staminaTimer = 0;

        charge = 0;
        chargeTimer = 0;
        isCharging = false;

        isClimbing = true;

        isGrabbingTheWall = false;
        isGrabbingTheWallDelayActive = false;
        isGrabbingTheWallDelayTimer = 0;

        isOnGround = false;

        FlxG.watch.add(this, "charge", "charge");
        FlxG.watch.add(this, "stamina", "stamina");
        FlxG.watch.add(this, "touching", "touching");
        FlxG.watch.add(this.acceleration, "x", "acceleration.x");
        FlxG.watch.add(this.acceleration, "y", "acceleration.y");
        FlxG.watch.add(this.maxVelocity, "x", "maxVelocity.x");
        FlxG.watch.add(this.maxVelocity, "y", "maxVelocity.y");
        FlxG.watch.add(this.velocity, "x", "velocity.x");
        FlxG.watch.add(this.velocity, "y", "velocity.y");
        FlxG.watch.add(this, "isClimbing", "isClimbing");
        FlxG.watch.add(this, "isGrabbingTheWall", "isGrabbingTheWall");
        FlxG.watch.add(this, "isGrabbingTheWallDelayActive", "isGrabbingTheWallDelayActive");
        FlxG.watch.add(this, "isGrabbingTheWallDelayTimer", "isGrabbingTheWallDelayTimer");
        FlxG.watch.add(this, "isOnGround", "isOnGround");

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

        //  Done before super.update() because that resets the touched/touching flags.
        if (justTouched(FlxObject.FLOOR)) {
            FlxG.log.add("just touched the floor");
            lockedVelocityX = 0;

            if (!isClimbing) {
                isOnGround = true;
            }
        }

        super.update(elapsed);

        staminaTimer += elapsed;

        if (staminaTimer >= 0.2) {
            staminaTimer = 0;
            if (stamina < 100) {
                stamina += 5;
            }
        }

        if (isCharging) {
            chargeTimer += elapsed;
            if (chargeTimer >= 0.05) {
                chargeTimer = 0;
                if (charge < 100) {
                    charge += 5;
                }
            }
        }

        if (!isClimbing) {
            acceleration.y = 400;
            velocity.x = lockedVelocityX;
        } else {
            acceleration.y = 0;
        }

        if (isGrabbingTheWall) {
            if (velocity.y == 0) {
                isGrabbingTheWallDelayActive = true;
            }
        }

        if (isGrabbingTheWallDelayActive) {
            isGrabbingTheWallDelayTimer += elapsed;
            if (isGrabbingTheWallDelayTimer >= 0.25) {
                isGrabbingTheWallDelayActive = false;
                isGrabbingTheWall = false;
                isGrabbingTheWallDelayTimer = 0;
            }
        }
    }

    private function updateGamepadInput(gamepad:FlxGamepad):Void {

        if (gamepad.justPressed.DPAD_UP)     { justPressedUp();     }
        if (gamepad.justPressed.DPAD_DOWN)   { justPressedDown();   }
        if (gamepad.justPressed.DPAD_RIGHT)  { justPressedRight();  }
        if (gamepad.justPressed.DPAD_LEFT)   { justPressedLeft();   }
        if (gamepad.justPressed.B)           { justPressedB();      }
        if (gamepad.justPressed.A)           { justPressedA();      }

        if (gamepad.pressed.DPAD_UP)         { pressedUp();         }
        if (gamepad.pressed.DPAD_DOWN)       { pressedDown();       }
        if (gamepad.pressed.DPAD_RIGHT)      { pressedRight();      }
        if (gamepad.pressed.DPAD_LEFT)       { pressedLeft();       }
        if (gamepad.pressed.B)               { pressedB();          }
        if (gamepad.pressed.A)               { pressedA();          }

        if (gamepad.justReleased.DPAD_UP)    { justReleasedUp();    }
        if (gamepad.justReleased.DPAD_DOWN)  { justReleasedDown();  }
        if (gamepad.justReleased.DPAD_RIGHT) { justReleasedRight(); }
        if (gamepad.justReleased.DPAD_LEFT)  { justReleasedLeft();  }
        if (gamepad.justReleased.B)          { justReleasedB();     }
        if (gamepad.justReleased.A)          { justReleasedA();     }

    }

    private function updateKeyboardInput():Void {

        if (FlxG.keys.anyJustPressed(KeyMappings.getDPadUp()))     { justPressedUp();     }
        if (FlxG.keys.anyJustPressed(KeyMappings.getDPadDown()))   { justPressedDown();   }
        if (FlxG.keys.anyJustPressed(KeyMappings.getDPadRight()))  { justPressedRight();  }
        if (FlxG.keys.anyJustPressed(KeyMappings.getDPadLeft()))   { justPressedLeft();   }
        if (FlxG.keys.anyJustPressed(KeyMappings.getB()))          { justPressedB();      }
        if (FlxG.keys.anyJustPressed(KeyMappings.getA()))          { justPressedA();      }

        if (FlxG.keys.anyPressed(KeyMappings.getDPadUp()))         { pressedUp();         }
        if (FlxG.keys.anyPressed(KeyMappings.getDPadDown()))       { pressedDown();       }
        if (FlxG.keys.anyPressed(KeyMappings.getDPadRight()))      { pressedRight();      }
        if (FlxG.keys.anyPressed(KeyMappings.getDPadLeft()))       { pressedLeft();       }
        if (FlxG.keys.anyPressed(KeyMappings.getB()))              { pressedB();          }
        if (FlxG.keys.anyPressed(KeyMappings.getA()))              { pressedA();          }

        if (FlxG.keys.anyJustReleased(KeyMappings.getDPadUp()))    { justReleasedUp();    }
        if (FlxG.keys.anyJustReleased(KeyMappings.getDPadDown()))  { justReleasedDown();  }
        if (FlxG.keys.anyJustReleased(KeyMappings.getDPadRight())) { justReleasedRight(); }
        if (FlxG.keys.anyJustReleased(KeyMappings.getDPadLeft()))  { justReleasedLeft();  }
        if (FlxG.keys.anyJustReleased(KeyMappings.getB()))         { justReleasedB();     }
        if (FlxG.keys.anyJustReleased(KeyMappings.getA()))         { justReleasedA();     }

    }

    private function justPressedUp():Void {}
    private function justPressedDown():Void {}
    private function justPressedRight():Void {}
    private function justPressedLeft():Void {}

    private function justPressedB():Void {
        if (isClimbing) {
            lockedVelocityX = velocity.x;
            isClimbing = false;
        } else {
            isClimbing = true;
            isGrabbingTheWall = true;
            isOnGround = false;
        }
    }

    private function justPressedA():Void {
        if (isClimbing) {
            FlxG.log.add("just pressed the A button");
            isCharging = true;
        }
    }

    private function pressedUp():Void {
        if (isClimbing && !isGrabbingTheWall) {
            if (velocity.y >= -baseMoveVelocity) {
                velocity.y = -baseMoveVelocity;
            }
        }
    }

    private function pressedDown():Void {
        if (isClimbing && !isGrabbingTheWall) {
            if (velocity.y <= baseMoveVelocity) {
                velocity.y = baseMoveVelocity;
            }
        }
    }

    private function pressedRight():Void {
        if (isClimbing && !isGrabbingTheWall) {
            if (velocity.x <= baseMoveVelocity) {
                velocity.x = baseMoveVelocity;
            }
        }
    }

    private function pressedLeft():Void {
        if (isClimbing && !isGrabbingTheWall) {
            if (velocity.x >= -baseMoveVelocity) {
                velocity.x = -baseMoveVelocity;
            }
        }
    }

    private function pressedB():Void {}
    private function pressedA():Void {
        velocity.x = 0;
        velocity.y = 0;
    }

    private function justReleasedUp():Void {}
    private function justReleasedDown():Void {}
    private function justReleasedRight():Void {}
    private function justReleasedLeft():Void {}
    private function justReleasedB():Void {}

    private function justReleasedA():Void {
        FlxG.log.add("just released the A button");
        isCharging = false;
        if (stamina > 10) {
            if (FlxG.keys.anyPressed(KeyMappings.getDPadLeft())) {
                velocity.x -= baseJumpVelocity + (charge * velocityFactor * 0.01);
            } else if (FlxG.keys.anyPressed(KeyMappings.getDPadRight())) {
                velocity.x += baseJumpVelocity + (charge * velocityFactor * 0.01);
            }

            if (FlxG.keys.anyPressed(KeyMappings.getDPadUp())) {
                velocity.y -= baseJumpVelocity + (charge * velocityFactor * 0.01);
            } else if (FlxG.keys.anyPressed(KeyMappings.getDPadDown())) {
                velocity.y += baseJumpVelocity + (charge * velocityFactor * 0.01);
            }

            stamina -= 20;
        }
        charge = 0;
    }

}
