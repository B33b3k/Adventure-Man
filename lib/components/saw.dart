import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  final bool isVertical;
  final double offNegative;
  final double offPositive;

  Saw(
      {this.isVertical = false,
      this.offNegative = 0,
      this.offPositive = 0,
      position,
      size})
      : super(
          position: position,
          size: size,
        );

  static const double speed = 50;
  static const tilesize = 16;
  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;
  @override
  FutureOr<void> onLoad() async {
    priority = -1;
    debugMode = false;
    add(CircleHitbox()); //added hitbox to the saw
    if (isVertical) {
      rangeNeg = position.y - offNegative * tilesize;
      rangePos = position.y + offPositive * tilesize;
    } else {
      rangeNeg = position.x - offNegative * tilesize;
      rangePos = position.x + offPositive * tilesize;
    }
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Saw/On (38x38).png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(38, 38),
        stepTime: 0.03,
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    //move vertical
    if (isVertical) {
      // position.y += speed * dt * moveDirection;
      if (position.y < rangeNeg) {
        moveDirection = 1;
      } else if (position.y > rangePos) {
        moveDirection = -1;
      }
      position.y += speed * dt * moveDirection;
    } else {
      //move horizontally
      if (position.x < rangeNeg) {
        moveDirection = 1;
      } else if (position.x > rangePos) {
        moveDirection = -1;
      }
      position.x += speed * dt * moveDirection;
    }

    super.update(dt);
  }
}
