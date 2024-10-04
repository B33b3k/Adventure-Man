import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late final CameraComponent cam;
  Player player = Player(state: 'idle', amount: 1, character: 'Mask Dude');
  late JoystickComponent joystick;
  bool isJoystickActive = true;

  @override
  void update(double dt) {
    // TODO: implement update
    if (isJoystickActive) updateJoyStick();
    super.update(dt);
  }

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();
    final world = Level(
      player: player,
      levelName: 'level01',
    );
    //cam
    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 340);
    cam.viewfinder.anchor = Anchor.topLeft;
    // Load assets here
    addAll(
      [
        world,
        cam,
      ],
    );
    if (isJoystickActive) addJoyStick();

    return super.onLoad();
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Knob.png')),
      ),
      knobRadius: 64,
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 16),
    );
    add(joystick);
  }

  void updateJoyStick() {
    switch (joystick.direction) {
      case JoystickDirection.up:
        player.direction = PlayerDirection.up;
        break;
      // case JoystickDirection.down:
      //   player.direction = PlayerDirection.down;
      //   break;
      case JoystickDirection.left:
        player.direction = PlayerDirection.left;
        break;
      case JoystickDirection.right:
        player.direction = PlayerDirection.right;
        break;
      case JoystickDirection.idle:
        player.direction = PlayerDirection.none;
        break;
      case JoystickDirection.up:
        player.direction = PlayerDirection.up;

      case JoystickDirection.upLeft:
      // player.direction = PlayerDirection.left;
      case JoystickDirection.upRight:
      // player.direction = PlayerDirection.right;

      // TODO: Handle this case.
      case JoystickDirection.down:
        player.direction = PlayerDirection.none;
      // TODO: Handle this case.
      case JoystickDirection.downRight:
      // player.direction = PlayerDirection.right;

      case JoystickDirection.downLeft:
      // player.direction = PlayerDirection.left;

      // TODO: Handle this case.
    }
  }
}
