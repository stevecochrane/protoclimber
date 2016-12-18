package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;

class Groups {

    public static var avalanches:FlxTypedGroup<Avalanche> = new FlxTypedGroup<Avalanche>(8);
    public static var avalancheGenerators:FlxTypedGroup<AvalancheGenerator> = new FlxTypedGroup<AvalancheGenerator>();
    public static var climbZones:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
    public static var hazardCircles:FlxTypedGroup<HazardCircle> = new FlxTypedGroup<HazardCircle>();

    public static var climbZoneTiles:FlxTilemap;

}
