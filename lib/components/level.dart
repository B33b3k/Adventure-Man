import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/player.dart';

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
    // Load the tiled level
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);

    // Get the spawn point layer
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoint');

    // Check if the spawn point layer exists
    if (spawnPointLayer != null) {
      // Loop through all objects in the spawn point layer
      for (final spawnPoint in spawnPointLayer.objects) {
        final spawnPointProperties = spawnPoint.class_;
        final spawnPointX = spawnPoint.x;
        final spawnPointY = spawnPoint.y;

        // Enhanced debug info for spawn points
        print(
            'Spawn Point: Type: $spawnPoint., Position: ($spawnPointX, $spawnPointY)');

        // Check if this spawn point is for the player
        if (spawnPointProperties == 'Player') {
          // Add the player to the level at the specified spawn point
          player.position = Vector2(spawnPointX, spawnPointY);
          add(player);
        }
      }
    } else {
      print('No spawn point layer found in the tile map.');
    }

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
    await super.onLoad();
  }
}
