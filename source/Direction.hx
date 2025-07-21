package;

class Direction {

    //  Extends on the cardinal directions provided in FlxObject to include diagonals.
    public static var UP         (default, never) : Int = 0x0100;
    public static var UP_RIGHT   (default, never) : Int = 0x0110;
    public static var RIGHT      (default, never) : Int = 0x0010;
    public static var DOWN_RIGHT (default, never) : Int = 0x1010;
    public static var DOWN       (default, never) : Int = 0x1000;
    public static var DOWN_LEFT  (default, never) : Int = 0x1001;
    public static var LEFT       (default, never) : Int = 0x0001;
    public static var UP_LEFT    (default, never) : Int = 0x0101;

}
