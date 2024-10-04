import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Fruit extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  final String fruit;
  Fruit({this.fruit = 'Apple', position, size})
      : super(
          position: position,
          size: size,
        );
  final double stepTime = 0.05;

  @override
  Future<void> onLoad() async {
    priority = 1;
    print('Fruit: $fruit');
    final spriteSheet = await SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$fruit.png'),
      SpriteAnimationData.sequenced(
        amount: 17,
        textureSize: Vector2(32, 32),
        stepTime: stepTime,
      ),
    );
    animation = spriteSheet;
  }
}
