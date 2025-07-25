package;

import flixel.addons.editors.tiled.TiledImageLayer;
import flixel.addons.editors.tiled.TiledImageTile;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import haxe.io.Path;

//	Modified from the flixel-demos TiledLevel object by Samuel Batista
class TiledLevel extends TiledMap {

    // For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image
    // used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
    private static inline var PATH_LEVEL_TILESETS = "assets/images/tilesets/";

    // Array of tilemaps used for collision
    public var backgroundTiles:FlxGroup;
    public var foregroundTiles:FlxGroup;

    private var collidableTileLayers:Array<FlxTilemap>;

    public function new(tiledLevel:Dynamic, state:FlxState) {

        super(tiledLevel);

        backgroundTiles = new FlxGroup();
        foregroundTiles = new FlxGroup();

        FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);

        loadObjects(state);

        for (layer in layers) {

            if (layer.type != TiledLayerType.TILE) continue;

            var tileLayer:TiledTileLayer = cast layer;
            var tileSheetName:String = tileLayer.properties.get("tileset");

            if (tileSheetName == null) {
                throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";
            }

            var tiledTileset:TiledTileSet = null;

            for (tileset in tilesets) {

                if (tileset.name == tileSheetName) {
                    tiledTileset = tileset;
                    break;
                }

            }

            if (tiledTileset == null) {
                throw "Tileset '" + tileSheetName + " not found. Did you misspell the 'tilesheet' property in " + tileLayer.name + "' layer?";
            }

            var imagePath = new Path(tiledTileset.imageSource);
            var processedPath = PATH_LEVEL_TILESETS + imagePath.file + "." + imagePath.ext;

            var tilemap:FlxTilemap = new FlxTilemap();
            tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath, tiledTileset.tileWidth, tiledTileset.tileHeight, OFF, tiledTileset.firstGID, 1, 1);

            if (tileLayer.properties.contains("climbzone")) {
                Groups.climbZoneTiles = tilemap;
            }

            if (tileLayer.properties.contains("nocollide")) {
                backgroundTiles.add(tilemap);

            } else {
                if (collidableTileLayers == null) {
                    collidableTileLayers = new Array<FlxTilemap>();
                }
                foregroundTiles.add(tilemap);
                collidableTileLayers.push(tilemap);
            }
        }
    }

    public function loadObjects(state:FlxState):Void {
        var layer:TiledObjectLayer;

        for (layer in layers) {
            if (layer.type != TiledLayerType.OBJECT) continue;

            var objectLayer:TiledObjectLayer = cast layer;

            for (obj in objectLayer.objects) {
                loadObject(obj, objectLayer, state);
            }
        }
    }

    /*public function loadImages() {
        for (layer in layers) {
            if (layer.type != TiledLayerType.IMAGE) continue;
            var image:TiledImageLayer = cast layer;

            var sprite = new FlxSprite(image.x, image.y, PATH_LEVEL_TILESETS + image.imagePath);
            imagesLayer.add(sprite);
        }
    }*/

    public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool {
        if (collidableTileLayers != null) {
            for (map in collidableTileLayers) {
                //  IMPORTANT: Always collide the map with objects, not the other way around.
                //  This prevents odd collision errors (collision separation code off by 1 px).
                if (FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static function loadLevel(levelNumber:Int, state:FlxState):TiledLevel {

        var newLevel:TiledLevel;

        switch (levelNumber) {
            default:
                newLevel = new TiledLevel(Assets.TMX_PROTOCLIMBER_1, state);
        }

        return newLevel;

    }

    public function loadObject(obj:TiledObject, objLayer:TiledObjectLayer, state:FlxState):Void {

        var x:Int = obj.x;
		var y:Int = obj.y;

        //  Objects in Tiled are aligned bottom-left (top-left in flixel)
        if (obj.gid != -1) {
            y -= objLayer.map.getGidOwner(obj.gid).tileHeight;
        }

        switch (obj.type.toLowerCase()) {

            case "avalanche_generator":
                var avalancheGenerator:AvalancheGenerator = new AvalancheGenerator(x, y, obj.width, obj.height, Std.parseFloat(obj.properties.get("phase")));
                Groups.avalancheGenerators.add(avalancheGenerator);

            case "climb_zone":
                var climbZone:FlxSprite = new FlxSprite(x, y);
                climbZone.width = obj.width;
                climbZone.height = obj.height;
                climbZone.makeGraphic(Std.int(climbZone.width), Std.int(climbZone.height), 0x00000000);
                climbZone.immovable = true;
                Groups.climbZones.add(climbZone);
                /*Groups.backgroundSprites.add(climbZone);*/

            case "hazard_circle":
                var hazardCircle:HazardCircle = new HazardCircle(x, y, Std.parseFloat(obj.properties.get("tiles")));
                Groups.hazardCircles.add(hazardCircle);

            case "player":
                var player:Player = new Player(x, y);
                Player.player = player;

        }

    }
}
