package;

import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyList;

class KeyMappings {

    //  These are functions because Array variables can't be inline.
    //  http://old.haxe.org/manual/haxe3/migration?version=15900#initialization-of-inline-variables

    public static inline function getDPadUp():Array<FlxKey> {
        return ["UP"];
    }

    public static inline function getDPadRight():Array<FlxKey> {
        return ["RIGHT"];
    }

    public static inline function getDPadDown():Array<FlxKey> {
        return ["DOWN"];
    }

    public static inline function getDPadLeft():Array<FlxKey> {
        return ["LEFT"];
    }

    public static inline function getB():Array<FlxKey> {
        return ["Z"];
    }

    public static inline function getA():Array<FlxKey> {
        return ["X"];
    }

    public static inline function getSelect():Array<FlxKey> {
        return ["A"];
    }

    public static inline function getStart():Array<FlxKey> {
        return ["ENTER", "P", "ESCAPE"];
    }

}
