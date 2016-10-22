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

    private var accelerationGravity:Float;
    private var baseGroundJumpVelocity:Float;
    private var baseMoveVelocity:Float;
    private var baseJumpVelocity:Float;
    private var baseRunVelocity:Float;
    private var chargeTimer:Float;
    private var climbingDirection:Int;
    private var currentAnimation:String;
    private var gamepad:FlxGamepad;
    private var isClimbingWindup:Bool;
    private var isClimbingWinddown:Bool;
    private var isCharging:Bool;
    private var isGrabbingTheWall:Bool;
    private var isGrabbingTheWallDelayActive:Bool;
    private var isGrabbingTheWallDelayTimer:Float;
    private var isOnGround:Bool;
    private var isOnWall:Bool;
    private var lockedVelocityX:Float;
    private var staminaDrainTimer:Float;
    private var staminaRechargeTimer:Float;
    private var velocityFactor:Float;
    private var windupTimer:Float;
    private var winddownTimer:Float;

    public function new(X:Float, Y:Float) {

        super(X, Y);

        accelerationGravity = 400;

        //maxVelocity.x = 200;
        //maxVelocity.y = 200;
        baseMoveVelocity = 40;
        baseJumpVelocity = 200;
        velocityFactor = baseJumpVelocity;
        lockedVelocityX = 0;

        baseRunVelocity = 100;
        baseGroundJumpVelocity = -accelerationGravity * 0.4;

        acceleration.x = 0;
        acceleration.y = 0;

        drag.x = 800;
        drag.y = 800;

        loadGraphic(Assets.IMG_PLAYER, true, 48, 72);

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);

        width = 16;
        height = 24;

        offset.x = 16;
        offset.y = 24;

        stamina = 100;
        staminaDrainTimer = 0;
        staminaRechargeTimer = 0;

        charge = 0;
        chargeTimer = 0;
        isCharging = false;

        isOnWall = true;

        isGrabbingTheWall = false;
        isGrabbingTheWallDelayActive = false;
        isGrabbingTheWallDelayTimer = 0;

        isOnGround = false;

        isClimbingWindup = false;
        isClimbingWinddown = false;
        windupTimer = 0;
        winddownTimer = 0;

        currentAnimation = "idle";

        pixelPerfectPosition = true;
        pixelPerfectRender = true;

        animation.add("idle", [0]);

        // 4px intervals
        // animation.add("windupUp",          [5]);
        // animation.add("winddownUp",        [1]);
        // animation.add("windupUpRight",     [6]);
        // animation.add("winddownUpRight",   [2]);
        // animation.add("windupRight",       [7]);
        // animation.add("winddownRight",     [3]);
        // animation.add("windupDownRight",   [8]);
        // animation.add("winddownDownRight", [4]);
        // animation.add("windupDown",        [1]);
        // animation.add("winddownDown",      [5]);
        // animation.add("windupDownLeft",    [2]);
        // animation.add("winddownDownLeft",  [6]);
        // animation.add("windupLeft",        [3]);
        // animation.add("winddownLeft",      [7]);
        // animation.add("windupUpLeft",      [4]);
        // animation.add("winddownUpLeft",    [8]);

        // 2px intervals
        animation.add("windupUp",          [13]);
        animation.add("winddownUp",        [9]);
        animation.add("windupUpRight",     [14]);
        animation.add("winddownUpRight",   [10]);
        animation.add("windupRight",       [15]);
        animation.add("winddownRight",     [11]);
        animation.add("windupDownRight",   [16]);
        animation.add("winddownDownRight", [12]);
        animation.add("windupDown",        [9]);
        animation.add("winddownDown",      [13]);
        animation.add("windupDownLeft",    [10]);
        animation.add("winddownDownLeft",  [14]);
        animation.add("windupLeft",        [11]);
        animation.add("winddownLeft",      [15]);
        animation.add("windupUpLeft",      [12]);
        animation.add("winddownUpLeft",    [16]);

        // FlxG.watch.add(this, "x", "x");
        // FlxG.watch.add(this, "y", "y");
        // FlxG.watch.add(this, "charge", "charge");
        // FlxG.watch.add(this, "stamina", "stamina");
        // FlxG.watch.add(this, "touching", "touching");
        // FlxG.watch.add(this.acceleration, "x", "acceleration.x");
        // FlxG.watch.add(this.acceleration, "y", "acceleration.y");
        // FlxG.watch.add(this.maxVelocity, "x", "maxVelocity.x");
        // FlxG.watch.add(this.maxVelocity, "y", "maxVelocity.y");
        // FlxG.watch.add(this.velocity, "x", "velocity.x");
        // FlxG.watch.add(this.velocity, "y", "velocity.y");
        FlxG.watch.add(this, "isOnWall", "isOnWall");
        // FlxG.watch.add(this, "isGrabbingTheWall", "isGrabbingTheWall");
        // FlxG.watch.add(this, "isGrabbingTheWallDelayActive", "isGrabbingTheWallDelayActive");
        // FlxG.watch.add(this, "isGrabbingTheWallDelayTimer", "isGrabbingTheWallDelayTimer");
        FlxG.watch.add(this, "isOnGround", "isOnGround");
        FlxG.watch.add(this, "isClimbingWindup", "isClimbingWindup");
        FlxG.watch.add(this, "isClimbingWinddown", "isClimbingWinddown");
        FlxG.watch.add(this, "windupTimer", "windupTimer");
        FlxG.watch.add(this, "winddownTimer", "winddownTimer");
        FlxG.watch.add(this, "climbingDirection", "climbingDirection");
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

            if (!isOnWall) {
                isOnGround = true;
            }
        }

        super.update(elapsed);

        staminaDrainTimer += elapsed;
        staminaRechargeTimer += elapsed;

        if (staminaRechargeTimer >= 0.25) {
            staminaRechargeTimer = 0;
            if (isOnGround && stamina < 100) {
                stamina += 10;
            }
        }

        if (staminaDrainTimer >= 1) {
            staminaDrainTimer = 0;
            if (isOnWall && stamina > 0) {
                stamina -= 1;
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

        if (!isOnWall) {
            acceleration.y = accelerationGravity;
            // velocity.x = lockedVelocityX;
        } else {
            acceleration.y = 0;
            velocity.y = 0;
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

        if (stamina <= 0 && isOnWall) {
            lockedVelocityX = velocity.x;
            isOnWall = false;
        }

        if (isClimbingWindup) {
            windupTimer += elapsed;

            switch(climbingDirection) {
                case Direction.UP:
                    currentAnimation = "windupUp";
                case Direction.UP_RIGHT:
                    currentAnimation = "windupUpRight";
                case Direction.RIGHT:
                    currentAnimation = "windupRight";
                case Direction.DOWN_RIGHT:
                    currentAnimation = "windupDownRight";
                case Direction.DOWN:
                    currentAnimation = "windupDown";
                case Direction.DOWN_LEFT:
                    currentAnimation = "windupDownLeft";
                case Direction.LEFT:
                    currentAnimation = "windupLeft";
                case Direction.UP_LEFT:
                    currentAnimation = "windupUpLeft";
            }

            if (windupTimer >= 0.2) {
                isClimbingWindup = false;
                windupTimer = 0;
                moveInDirection(climbingDirection);
            }
        }

        if (isClimbingWinddown) {
            winddownTimer += elapsed;

            switch(climbingDirection) {
                case Direction.UP:
                    currentAnimation = "winddownUp";
                case Direction.UP_RIGHT:
                    currentAnimation = "winddownUpRight";
                case Direction.RIGHT:
                    currentAnimation = "winddownRight";
                case Direction.DOWN_RIGHT:
                    currentAnimation = "winddownDownRight";
                case Direction.DOWN:
                    currentAnimation = "winddownDown";
                case Direction.DOWN_LEFT:
                    currentAnimation = "winddownDownLeft";
                case Direction.LEFT:
                    currentAnimation = "winddownLeft";
                case Direction.UP_LEFT:
                    currentAnimation = "winddownUpLeft";
            }

            if (winddownTimer >= 0.2) {
                isClimbingWinddown = false;
                winddownTimer = 0;
                currentAnimation = "idle";
            }
        }

        animation.play(currentAnimation);
        currentAnimation = "idle";
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

        if (FlxG.keys.anyPressed(KeyMappings.getDPadUp())    && !FlxG.keys.anyPressed(KeyMappings.getDPadLeft())   && !FlxG.keys.anyPressed(KeyMappings.getDPadRight())) { pressedUp();        }
        if (FlxG.keys.anyPressed(KeyMappings.getDPadUp())    &&  FlxG.keys.anyPressed(KeyMappings.getDPadRight()))                                                       { pressedUpRight();   }
        if (FlxG.keys.anyPressed(KeyMappings.getDPadRight()) && !FlxG.keys.anyPressed(KeyMappings.getDPadUp())     && !FlxG.keys.anyPressed(KeyMappings.getDPadDown()))  { pressedRight();     }
        if (FlxG.keys.anyPressed(KeyMappings.getDPadDown())  &&  FlxG.keys.anyPressed(KeyMappings.getDPadRight()))                                                       { pressedDownRight(); }
        if (FlxG.keys.anyPressed(KeyMappings.getDPadDown())  && !FlxG.keys.anyPressed(KeyMappings.getDPadLeft())   && !FlxG.keys.anyPressed(KeyMappings.getDPadRight())) { pressedDown();      }
        if (FlxG.keys.anyPressed(KeyMappings.getDPadDown())  &&  FlxG.keys.anyPressed(KeyMappings.getDPadLeft()))                                                        { pressedDownLeft();  }
        if (FlxG.keys.anyPressed(KeyMappings.getDPadLeft())  && !FlxG.keys.anyPressed(KeyMappings.getDPadUp())     && !FlxG.keys.anyPressed(KeyMappings.getDPadDown()))  { pressedLeft();      }
        if (FlxG.keys.anyPressed(KeyMappings.getDPadUp())    &&  FlxG.keys.anyPressed(KeyMappings.getDPadLeft()))                                                        { pressedUpLeft();    }
        if (FlxG.keys.anyPressed(KeyMappings.getB()))                                                                                                                    { pressedB();         }
        if (FlxG.keys.anyPressed(KeyMappings.getA()))                                                                                                                    { pressedA();         }

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
        if (isOnWall) {
            lockedVelocityX = velocity.x;
            isOnWall = false;
        } else {
            if (overlaps(Groups.climbZones)) {
                isOnWall = true;
                /*isGrabbingTheWall = true;*/
                isOnGround = false;

                acceleration.y = 0;
                velocity.y = 0;

                snapToGrid();
            }
        }
    }

    private function justPressedA():Void {
        if (isOnWall) {
            FlxG.log.add("just pressed the A button");
            isCharging = true;
        } else if (isOnGround && isTouching(FlxObject.FLOOR)) {
            FlxG.log.add("Jump!");
            velocity.y = baseGroundJumpVelocity;
        }
    }

    private function pressedUp():Void {
        if (isOnWall && !isGrabbingTheWall && !isClimbingWindup && !isClimbingWinddown && overlapsAt(x, y - 24 - 1, Groups.climbZones)) {
            // For instant movement
            // y -= 16;
            // stamina -= 5;

            // For timed movement
            isClimbingWindup = true;
            climbingDirection = Direction.UP;
        }
    }

    private function pressedUpRight():Void {
        if (isOnWall && !isGrabbingTheWall && !isClimbingWindup && !isClimbingWinddown && overlapsAt(x, y - 24 - 1, Groups.climbZones)) {
            // For instant movement
            // y -= 16;
            // stamina -= 5;

            // For timed movement
            isClimbingWindup = true;
            climbingDirection = Direction.UP_RIGHT;
        }
    }

    private function pressedRight():Void {
        // if (isOnGround) {
        if (!isOnWall) {
            velocity.x = baseRunVelocity;
        }

        if (isOnWall && !isGrabbingTheWall && !isClimbingWindup && !isClimbingWinddown && overlapsAt(x + 16 + 1, y, Groups.climbZones)) {
            // For instant movement
            // x += 16;
            // stamina -= 5;

            // For timed movement
            isClimbingWindup = true;
            climbingDirection = Direction.RIGHT;
        }
    }

    private function pressedDownRight():Void {
        if (isOnWall && !isGrabbingTheWall && !isClimbingWindup && !isClimbingWinddown && overlapsAt(x, y - 24 - 1, Groups.climbZones)) {
            // For instant movement
            // y -= 16;
            // stamina -= 5;

            // For timed movement
            isClimbingWindup = true;
            climbingDirection = Direction.DOWN_RIGHT;
        }
    }

    private function pressedDown():Void {
        if (isOnWall && !isGrabbingTheWall && !isClimbingWindup && !isClimbingWinddown && overlapsAt(x, y + 16 + 1, Groups.climbZones)) {
            // For instant movement
            // y += 16;
            // stamina -= 5;

            // For timed movement
            isClimbingWindup = true;
            climbingDirection = Direction.DOWN;
        }
    }

    private function pressedDownLeft():Void {
        if (isOnWall && !isGrabbingTheWall && !isClimbingWindup && !isClimbingWinddown && overlapsAt(x, y - 24 - 1, Groups.climbZones)) {
            // For instant movement
            // y -= 16;
            // stamina -= 5;

            // For timed movement
            isClimbingWindup = true;
            climbingDirection = Direction.DOWN_LEFT;
        }
    }

    private function pressedLeft():Void {
        // if (isOnGround) {
        if (!isOnWall) {
            velocity.x = -baseRunVelocity;
        }

        if (isOnWall && !isGrabbingTheWall && !isClimbingWindup && !isClimbingWinddown && overlapsAt(x - 16 - 1, y, Groups.climbZones)) {
            // For instant movement
            // x -= 16;
            // stamina -= 5;

            // For timed movement
            isClimbingWindup = true;
            climbingDirection = Direction.LEFT;
        }
    }

    private function pressedUpLeft():Void {
        if (isOnWall && !isGrabbingTheWall && !isClimbingWindup && !isClimbingWinddown && overlapsAt(x, y - 24 - 1, Groups.climbZones)) {
            // For instant movement
            // y -= 16;
            // stamina -= 5;

            // For timed movement
            isClimbingWindup = true;
            climbingDirection = Direction.UP_LEFT;
        }
    }

    private function pressedB():Void {}
    private function pressedA():Void {
        if (isOnWall) {
            velocity.x = 0;
            velocity.y = 0;
        }
    }

    private function justReleasedUp():Void {}
    private function justReleasedDown():Void {}
    private function justReleasedRight():Void {}
    private function justReleasedLeft():Void {}
    private function justReleasedB():Void {}

    private function justReleasedA():Void {
        FlxG.log.add("just released the A button");
        if (isOnWall) {
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

                lockedVelocityX = velocity.x;
                isOnWall = false;
            }
            charge = 0;
        }
    }

    private function snapToGrid():Void {
        var xRounded:Int = Math.round(x);
        var yRounded:Int = Math.round(y);
        var xGridOffset:Int = xRounded % 16;
        var yGridOffset:Int = yRounded % 16;

        if (xGridOffset <= 8 && overlapsAt(xRounded - xGridOffset - 1, y, Groups.climbZones)) {
            x = xRounded - xGridOffset;
        } else if (xGridOffset >= 8 && overlapsAt(xRounded - xGridOffset + 16 + 1, y, Groups.climbZones)) {
            x = xRounded - xGridOffset + 16;
        }

        if (yGridOffset <= 8 && overlapsAt(x, yRounded - yGridOffset - 1, Groups.climbZones)) {
            y = yRounded - yGridOffset;
        } else if (yGridOffset >= 8 && overlapsAt(x, yRounded - yGridOffset + 16 + 1, Groups.climbZones)) {
            y = yRounded - yGridOffset + 16;
        }
    }

    private function moveInDirection(theDirection:Int):Void {
        FlxG.log.add("Let's go in this direction: " + theDirection);

        switch(theDirection) {
            case Direction.UP:
                y -= 16;
            case Direction.UP_RIGHT:
                x += 16;
                y -= 16;
            case Direction.RIGHT:
                x += 16;
            case Direction.DOWN_RIGHT:
                x += 16;
                y += 16;
            case Direction.DOWN:
                y += 16;
            case Direction.DOWN_LEFT:
                x -= 16;
                y += 16;
            case Direction.LEFT:
                x -= 16;
            case Direction.UP_LEFT:
                x -= 16;
                y -= 16;
        }

        stamina -= 5;
        isClimbingWinddown = true;
    }

}
