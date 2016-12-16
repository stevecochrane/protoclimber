package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

class Groups {

    public static var avalancheFallingIce:FlxTypedGroup<AvalancheFallingIce> = new FlxTypedGroup<AvalancheFallingIce>(8);
    public static var avalancheGenerators:FlxTypedGroup<AvalancheGenerator> = new FlxTypedGroup<AvalancheGenerator>();
    public static var climbZones:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
    public static var hazardCircles:FlxTypedGroup<HazardCircle> = new FlxTypedGroup<HazardCircle>();

}
