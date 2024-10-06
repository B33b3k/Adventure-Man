import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/CheckPoint.dart';
import 'package:pixel_adventure/components/fruit.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/saw.dart';

class Level extends World {
  final String levelName;
  final Player player;
  Level({
    required this.levelName,
    required this.player,
  });

  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = []; //add all platforms here

  @override
  Future<void> onLoad() async {
    debugMode = false;
    // Load the tiled level
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);

    _scrollingBackground();
    _spawningObjects();
    _collisionLayer();

    // Get the spawn point layer

    await super.onLoad();
  }

  void _spawningObjects() {
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoint');

    // Check if the spawn point layer exists
    if (spawnPointLayer != null) {
      // Loop through all objects in the spawn point layer
      for (final spawnPoint in spawnPointLayer.objects) {
        final spawnPointProperties = spawnPoint.class_;
        final spawnPointX = spawnPoint.x;
        final spawnPointY = spawnPoint.y;

        // Enhanced debug info for spawn points

        // Check if this spawn point is for the player
        switch (spawnPointProperties) {
          case 'Player':
            // Add the player to the level at the specified spawn point
            player.position = Vector2(spawnPointX, spawnPointY);
            add(player);
            break;
          case 'Fruit':
            // Add the player to the level at the specified spawn point
            final fruit = Fruit(
              fruit: spawnPoint.name,
              position: Vector2(spawnPointX, spawnPointY),
              size: Vector2(32, 32),
            );
            add(fruit);
            break;
          case 'Saw':
            final isVertical = spawnPoint.properties.getValue('isVertical');
            final offPositive = spawnPoint.properties.getValue('offPositive');
            final offNegative = spawnPoint.properties.getValue('offNegative');

            final saw = Saw(
              isVertical: isVertical,
              offNegative: offNegative,
              offPositive: offPositive,
              position: Vector2(
                spawnPointX,
                spawnPointY,
              ),
              size: Vector2(38, 38),
            );
            add(saw);
          case 'CheckPoint':
            // Add the player to the level at the specified spawn point
            final checkpoint = Checkpoint(
              position: Vector2(spawnPointX, spawnPointY),
              size: Vector2(64, 64),
            );
            add(checkpoint);
            break;
          default:
            break;
        }
      }
    } else {
      print('No spawn point layer found in the tile map.');
    }
  }

  void _collisionLayer() {
    final collisionLayer = level.tileMap.getLayer<ObjectGroup>('Collision');
    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height),
                isPlatform: true);
            collisionBlocks.add(platform);

            add(platform);
            break;
          default:
            final block = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height));
            collisionBlocks.add(block);

            add(block);
            break;
        }
      }
    }
    player.collisionBlocks = collisionBlocks;

    // Call super.onLoad at the end
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');
    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue('BackgroundColor');
    }
  }
}
