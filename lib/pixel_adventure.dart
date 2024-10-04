import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late final CameraComponent cam;
  Player player = Player(state: 'idle', amount: 1, character: 'Mask Dude');
  late JoystickComponent joystick;
  late ButtonComponent upButton;
  bool isJoystickActive = true;
  bool isGoingUp = false;

  @override
  void update(double dt) {
    updateUpButton();
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
    // cam setup
    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 340);
    cam.viewfinder.anchor = Anchor.topLeft;

    // Add world and camera
    addAll([world, cam]);

    if (isJoystickActive) addJoyStick();
    addUpButton();

    return super.onLoad();
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      priority: -100,
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

  void addUpButton() async {
    // Load the up button sprite
    final buttonSprite = await Sprite.load('HUD/JumpButton.png');

    // Define the button component
    upButton = ButtonComponent(
      button: SpriteComponent(sprite: buttonSprite, size: Vector2(64, 64)),
      buttonDown: SpriteComponent(sprite: buttonSprite, size: Vector2(64, 64)),
      position: Vector2(size.x - 64 - 16,
          size.y - 64 - 16), // Position it at the bottom-right
      onPressed: () {
        // Trigger the player's jump method when the button is pressed
        isGoingUp = true;
        player.direction = PlayerDirection.up;

        // Play the jump sound effect
        //audio.play('jump.wav');
      },
    );

    // Add the button to the game
    add(upButton);
  }

  void updateJoyStick() {
    switch (joystick.direction) {
      case JoystickDirection.downLeft:
        player.direction = PlayerDirection.left;
        break;
      case JoystickDirection.downRight:
        player.direction = PlayerDirection.right;
        break;
      case JoystickDirection.upLeft:
        player.direction = PlayerDirection.left;
        break;
      case JoystickDirection.upRight:
        player.direction = PlayerDirection.right;
        break;
      case JoystickDirection.up:
        print('up');
        player.direction = PlayerDirection.none;
        break;
      case JoystickDirection.left:
        player.direction = PlayerDirection.left;
        break;
      case JoystickDirection.right:
        player.direction = PlayerDirection.right;
        break;
      case JoystickDirection.idle:
        player.direction = PlayerDirection.none;
        break;
      default:
        break;
    }
  }

  double jumpHeight = 32; // The amount to move up (adjust to your needs)
  double jumpAmount = 0; // Keeps track of how much has been jumped

  void updateUpButton() {
    // Only move up once, then reset the flag
    if (isGoingUp && jumpAmount < jumpHeight) {
      player.direction = PlayerDirection.up;
      player.position.y -=
          5; // Move player upwards by 5 units (adjust this value)
      jumpAmount += 5; // Increment jump amount
    } else {
      // Stop upward movement once we reach the desired height
      player.direction = PlayerDirection.none;
      isGoingUp = false; // Reset the flag to stop further jumps
      jumpAmount = 0; // Reset the jump amount for next use
    }
  }

  void onUpButtonPressed() {
    // Trigger upward movement when the button is pressed
    if (!isGoingUp) {
      isGoingUp = true; // Set the flag to true only once
      jumpAmount = 0; // Reset the jump amount when the button is pressed
    }
  }
}
