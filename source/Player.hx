package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.input.gamepad.FlxGamepad;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDirectionFlags;

class Player extends FlxSprite {

    public static var player:Player;
    public static var staminaMax:Float = 18;

    public static function collisionHurtPlayer(hazard:FlxSprite, player:FlxSprite) {
        Player.player.hurt(1);
    }

    private var accelerationGravity:Float;
    private var baseDragX:Float;
    private var baseGroundJumpVelocity:Float;
    private var baseGroundChargedJumpVelocity:Float;
    private var baseJumpVelocity:Float;
    private var baseKnockedBackVelocity:Float;
    private var baseMoveVelocity:Float;
    private var baseRunVelocity:Float;
    private var charge:Float;
    private var chargeTimer:Float;
    private var climbingDirection:Int;
    private var currentAnimation:String;
    private var chargingDragX:Float;
    private var gamepad:FlxGamepad;
    private var isBeingKnockedBack:Bool;
    private var isClimbingWindup:Bool;
    private var isClimbingWinddown:Bool;
    private var isCharged:Bool;
    private var isCharging:Bool;
    private var isDuckingForAJump:Bool;
    private var isGrabbingTheWall:Bool;
    private var isGrabbingTheWallDelayActive:Bool;
    private var isGrabbingTheWallDelayTimer:Float;
    private var isOnGround:Bool;
    private var isOnWall:Bool;
    private var lockedVelocityX:Float;
    private var stamina:Float;
    private var staminaDrainTimer:Float;
    private var staminaRechargeTimer:Float;
    private var staminaChargedJumpCost:Float;
    private var staminaJumpCost:Float;
    private var staminaStepCost:Float;
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
        baseGroundJumpVelocity = -accelerationGravity * 0.45;
        baseGroundChargedJumpVelocity = -accelerationGravity * 0.6;
        baseKnockedBackVelocity = baseGroundJumpVelocity * 0.5;

        acceleration.x = 0;
        acceleration.y = 0;

        baseDragX = 800;
        chargingDragX = 200;
        drag.x = baseDragX;
        drag.y = 800;

        loadGraphic(Assets.IMG_PLAYER, true, 48, 72);

        setFacingFlip(FlxDirectionFlags.LEFT, true, false);
        setFacingFlip(FlxDirectionFlags.RIGHT, false, false);

        width = 16;
        height = 24;

        offset.x = 16;
        offset.y = 24;

        stamina = staminaMax;
        staminaJumpCost = 6;
        staminaChargedJumpCost = staminaJumpCost * 2;
        staminaStepCost = 1;
        staminaDrainTimer = 0;
        staminaRechargeTimer = 0;

        charge = 0;
        chargeTimer = 0;
        isCharged = false;
        isCharging = false;

        isOnWall = false;

        isGrabbingTheWall = false;
        isGrabbingTheWallDelayActive = false;
        isGrabbingTheWallDelayTimer = 0;

        isOnGround = false;

        isClimbingWindup = false;
        isClimbingWinddown = false;

        isBeingKnockedBack = false;

        windupTimer = 0;
        winddownTimer = 0;

        isDuckingForAJump = false;

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

        animation.add("ducking",           [17]);

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
        if (justTouched(FlxDirectionFlags.FLOOR)) {
            FlxG.log.add("just touched the floor");
            lockedVelocityX = 0;
            stamina = staminaMax;
            isBeingKnockedBack = false;
            FlxFlicker.stopFlickering(this);

            isOnWall = false;
            isOnGround = true;
        }

        super.update(elapsed);

        // staminaDrainTimer += elapsed;
        // staminaRechargeTimer += elapsed;

        // if (staminaRechargeTimer >= 0.25) {
        //     staminaRechargeTimer = 0;
        //     if (isOnGround && stamina < staminaMax) {
        //         stamina += staminaStepCost;
        //     }
        // }

        // if (staminaDrainTimer >= 1) {
        //     staminaDrainTimer = 0;
        //     if (isOnWall && stamina > 0) {
        //         stamina -= staminaStepCost;
        //     }
        // }

        if (isCharging) {
            chargeTimer += elapsed;

            if (chargeTimer >= 0.5) {
                isCharged = true;
                FlxFlicker.flicker(this, 0, 0.04, true, false);
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
                currentAnimation = "idle";
            }

            if (winddownTimer >= 0.6) {
                isClimbingWinddown = false;
                winddownTimer = 0;
            }
        }

        if (isDuckingForAJump) {
            currentAnimation = "ducking";
        }

        animation.play(currentAnimation);
        currentAnimation = "idle";
    }

    override public function hurt(damage:Float):Void {
        if (!isBeingKnockedBack) {
            isBeingKnockedBack = true;
            FlxFlicker.flicker(this, 0, 0.04, true, false);

            isOnWall = false;
            isClimbingWinddown = false;
            isClimbingWindup = false;
            stamina = 0;

            velocity.y = baseKnockedBackVelocity;
        }
    }

    private function updateGamepadInput(gamepad:FlxGamepad):Void {

        if (gamepad.justPressed.DPAD_UP)     { justPressedUp();     }
        if (gamepad.justPressed.DPAD_DOWN)   { justPressedDown();   }
        if (gamepad.justPressed.DPAD_RIGHT)  { justPressedRight();  }
        if (gamepad.justPressed.DPAD_LEFT)   { justPressedLeft();   }
        if (gamepad.justPressed.B)           { justPressedB();      }
        if (gamepad.justPressed.A)           { justPressedA();      }

        if (gamepad.pressed.DPAD_UP    && !gamepad.pressed.DPAD_LEFT && !gamepad.pressed.DPAD_RIGHT)         { pressedUp();        }
        if (gamepad.pressed.DPAD_UP    &&  gamepad.pressed.DPAD_RIGHT)                                       { pressedUpRight();   }
        if (gamepad.pressed.DPAD_RIGHT && !gamepad.pressed.DPAD_UP   && !gamepad.pressed.DPAD_DOWN)          { pressedRight();     }
        if (gamepad.pressed.DPAD_DOWN  &&  gamepad.pressed.DPAD_RIGHT)                                       { pressedDownRight(); }
        if (gamepad.pressed.DPAD_DOWN  && !gamepad.pressed.DPAD_LEFT && !gamepad.pressed.DPAD_RIGHT)         { pressedDown();      }
        if (gamepad.pressed.DPAD_DOWN  &&  gamepad.pressed.DPAD_LEFT)                                        { pressedDownLeft();  }
        if (gamepad.pressed.DPAD_LEFT  && !gamepad.pressed.DPAD_UP   && !gamepad.pressed.DPAD_DOWN)          { pressedLeft();      }
        if (gamepad.pressed.DPAD_UP    &&  gamepad.pressed.DPAD_LEFT)                                        { pressedUpLeft();    }
        if (gamepad.pressed.B)                                                                               { pressedB();         }
        if (gamepad.pressed.A)                                                                               { pressedA();         }

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

    private function justPressedB():Void {}
    private function justPressedA():Void {
        // if (isOnWall) {
        //     FlxG.log.add("just pressed the A button");
        //     isCharging = true;
        // } else if (isOnGround && isTouching(FlxDirectionFlags.FLOOR)) {
        //     FlxG.log.add("Jump!");
        //     velocity.y = baseGroundJumpVelocity;
        // }

        // if (isOnWall || isOnGround && isTouching(FlxDirectionFlags.FLOOR)) {
        //     FlxG.log.add("Jump!");
        //     velocity.y = baseGroundJumpVelocity;
        //
        //     if (isOnWall) {
        //         stamina -= staminaJumpCost;
        //         isOnWall = false;
        //     }
        // }
    }

    private function pressedUp():Void {
        if (!isCharging) {
            if (isOnWall) {
                if (!isGrabbingTheWall && !isClimbingWinddown) {
                    isClimbingWindup = true;
                    climbingDirection = Direction.UP;
                }
            } else {
                if (overlaps(Groups.climbZoneTiles) && stamina > 0 && velocity.y >= 0) {
                    isOnWall = true;
                    /*isGrabbingTheWall = true;*/
                    isOnGround = false;

                    acceleration.y = 0;
                    velocity.y = 0;

                    snapToGrid();
                }
            }
        }
    }

    private function pressedUpRight():Void {
        if (!isCharging) {
            if (!isOnWall) {
                velocity.x = baseRunVelocity;

                if (overlaps(Groups.climbZoneTiles) && stamina > 0 && velocity.y >= 0) {
                    isOnWall = true;
                    /*isGrabbingTheWall = true;*/
                    isOnGround = false;

                    acceleration.y = 0;
                    velocity.y = 0;

                    snapToGrid();
                }
            }

            if (isOnWall && !isGrabbingTheWall && !isClimbingWinddown) {
                isClimbingWindup = true;
                climbingDirection = Direction.UP_RIGHT;
            }
        }
    }

    private function pressedRight():Void {
        if (!isCharging) {
            if (!isOnWall) {
                velocity.x = baseRunVelocity;
            }

            if (isOnWall && !isGrabbingTheWall && !isClimbingWinddown) {
                isClimbingWindup = true;
                climbingDirection = Direction.RIGHT;
            }
        }
    }

    private function pressedDownRight():Void {
        if (!isCharging) {
            if (!isOnWall) {
                velocity.x = baseRunVelocity;
            }

            if (isOnWall && !isGrabbingTheWall && !isClimbingWinddown) {
                isClimbingWindup = true;
                climbingDirection = Direction.DOWN_RIGHT;
            }
        }
    }

    private function pressedDown():Void {
        if (!isCharging) {
            if (isOnWall && !isGrabbingTheWall && !isClimbingWinddown) {
                isClimbingWindup = true;
                climbingDirection = Direction.DOWN;
            }
        }
    }

    private function pressedDownLeft():Void {
        if (!isCharging) {
            if (!isOnWall) {
                velocity.x = -baseRunVelocity;
            }

            if (isOnWall && !isGrabbingTheWall && !isClimbingWinddown) {
                isClimbingWindup = true;
                climbingDirection = Direction.DOWN_LEFT;
            }
        }
    }

    private function pressedLeft():Void {
        if (!isOnWall && !isCharging) {
            velocity.x = -baseRunVelocity;
        }

        if (isOnWall && !isGrabbingTheWall && !isClimbingWinddown) {
            isClimbingWindup = true;
            climbingDirection = Direction.LEFT;
        }
    }

    private function pressedUpLeft():Void {
        if (!isCharging) {
            if (!isOnWall) {
                velocity.x = -baseRunVelocity;

                if (overlaps(Groups.climbZoneTiles) && stamina > 0 && velocity.y >= 0) {
                    isOnWall = true;
                    /*isGrabbingTheWall = true;*/
                    isOnGround = false;

                    acceleration.y = 0;
                    velocity.y = 0;

                    snapToGrid();
                }
            }

            if (isOnWall && !isGrabbingTheWall && !isClimbingWinddown) {
                isClimbingWindup = true;
                climbingDirection = Direction.UP_LEFT;
            }
        }
    }

    private function pressedB():Void {}
    private function pressedA():Void {
        // if (isOnWall) {
        //     velocity.x = 0;
        //     velocity.y = 0;
        // }
        if (!isCharging && velocity.y == 0) {
            cancelClimbingWindup();
            isCharging = true;
            drag.x = chargingDragX;
            isDuckingForAJump = true;
        }
    }

    private function justReleasedUp():Void {
        cancelClimbingWindup();
    }

    private function justReleasedDown():Void {
        cancelClimbingWindup();
    }

    private function justReleasedRight():Void {
        cancelClimbingWindup();
    }

    private function justReleasedLeft():Void {
        cancelClimbingWindup();
    }

    private function justReleasedB():Void {}
    private function justReleasedA():Void {
        // FlxG.log.add("just released the A button");
        // if (isOnWall) {
        //     isCharging = false;
        //     if (stamina > staminaJumpCost) {
        //         if (FlxG.keys.anyPressed(KeyMappings.getDPadLeft())) {
        //             velocity.x -= baseJumpVelocity + (charge * velocityFactor * 0.01);
        //         } else if (FlxG.keys.anyPressed(KeyMappings.getDPadRight())) {
        //             velocity.x += baseJumpVelocity + (charge * velocityFactor * 0.01);
        //         }
        //
        //         if (FlxG.keys.anyPressed(KeyMappings.getDPadUp())) {
        //             velocity.y -= baseJumpVelocity + (charge * velocityFactor * 0.01);
        //         } else if (FlxG.keys.anyPressed(KeyMappings.getDPadDown())) {
        //             velocity.y += baseJumpVelocity + (charge * velocityFactor * 0.01);
        //         }
        //
        //         stamina -= staminaJumpCost;
        //
        //         lockedVelocityX = velocity.x;
        //         isOnWall = false;
        //     }
        //     charge = 0;
        // }

        if (isOnWall || isOnGround && isTouching(FlxDirectionFlags.FLOOR)) {
            FlxG.log.add("Jump!");

            if (isCharged) {
                if (stamina >= staminaChargedJumpCost) {
                    velocity.y = baseGroundChargedJumpVelocity;
                    stamina -= staminaChargedJumpCost;
                    isOnWall = false;
                }
            } else if (stamina >= staminaJumpCost) {
                velocity.y = baseGroundJumpVelocity;
                stamina -= staminaJumpCost;
                isOnWall = false;
            }
        }

        isCharged = false;
        FlxFlicker.stopFlickering(this);
        isCharging = false;
        chargeTimer = 0;
        drag.x = baseDragX;
        isDuckingForAJump = false;
    }

    private function snapToGrid():Void {
        var xRounded:Int = Math.round(x);
        var yRounded:Int = Math.round(y);
        var xGridOffset:Int = xRounded % 16;
        var yGridOffset:Int = yRounded % 16;

        if (overlapsAt(xRounded - xGridOffset - 1, y, Groups.climbZoneTiles)) {
            x = xRounded - xGridOffset;
        } else if (overlapsAt(xRounded - xGridOffset + 16 + 1, y, Groups.climbZoneTiles)) {
            x = xRounded - xGridOffset + 16;
        }

        if (overlapsAt(x, yRounded - yGridOffset - 1, Groups.climbZoneTiles)) {
            y = yRounded - yGridOffset;
        } else if (overlapsAt(x, yRounded - yGridOffset + 16 + 1, Groups.climbZoneTiles)) {
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

        stamina -= staminaStepCost;
        isClimbingWinddown = true;

        if (!overlaps(Groups.climbZoneTiles)) {
            isOnWall = false;
        }
    }

    private function cancelClimbingWindup():Void {
        isClimbingWindup = false;
        windupTimer = 0;
    }

}
