import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Checkpoint extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Checkpoint({position, size, animation})
      : super(
          position: position,
          size: size,
          animation: animation,
        );

  bool crossedCheckPoint = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    // TODO: implement onLoad
    add(RectangleHitbox(
      size: Vector2(18, 56),
      position: Vector2(2, 2),
      collisionType: CollisionType.active,
    ));
    animation = SpriteAnimation.fromFrameData(
      game.images
          .fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(64, 64),
        stepTime: 1,
      ),
    );
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      if (crossedCheckPoint) {
        return;
      }
      crossedCheckPoint = true;
      print('Player has reached the checkpoint');
      _reachedCheckpoint();
      super.onCollision(intersectionPoints, other);
    }
  }

  void _reachedCheckpoint() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
      SpriteAnimationData.sequenced(
          amount: 27,
          textureSize: Vector2(64, 64),
          stepTime: 0.05,
          loop: false),
    );
    Future.delayed(Duration(seconds: 1), () {
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(
            'Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'),
        SpriteAnimationData.sequenced(
            amount: 10,
            textureSize: Vector2(64, 64),
            stepTime: 0.05,
            loop: true),
      );
    });
  }
}
