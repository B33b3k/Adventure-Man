//player

import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerDirection { left, right, up, down, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  String character;
  String state;
  int amount;

  Player(
      {position,
      this.character = 'Ninja Frog',
      required this.state,
      required this.amount})
      : super(position: position);

  late final SpriteAnimation idle;
  late final SpriteAnimation run;
  late final SpriteAnimation jump;
  late final SpriteAnimation fall;
  late final SpriteAnimation attack;
  late final SpriteAnimation death;
  late final SpriteAnimation hit;
  late final SpriteAnimation slide;
  late final SpriteAnimation swim;
  late final SpriteAnimation climb;

  final double stepTime = 0.05;
  double horizntalMovement = 0;
  final double _gravity = 19.8;
  final double _jumpForce = 500;
  final double _terminalVelocity = 250;
  bool isJumping = false;

  PlayerDirection direction = PlayerDirection.left;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isfacingRight = true;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    debugMode = true;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    checkHorizontalCollisions();
    _applyGravity(dt);
    _checkVerticalCollisions();
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD);

    isJumping = keysPressed.contains(LogicalKeyboardKey.space);

    // Register only key down events
    horizntalMovement = 0;
    if (isLeftKeyPressed) {
      horizntalMovement -= 1;
    }
    if (isRightKeyPressed) {
      horizntalMovement += 1;
    }

    // if (event is KeyDownEvent) {
    //   if (isLeftKeyPressed) {
    //     direction = PlayerDirection.left;
    //     print('Left key pressed');
    //   } else if (isRightKeyPressed) {
    //     direction = PlayerDirection.right;
    //     print('Right key pressed');
    //   } else {
    //     direction = PlayerDirection.none;
    //     print('No key pressed');
    //   }
    // }

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idle = _spriteAnimation('Ninja Frog', 'Idle', 11);

    run = _spriteAnimation('Ninja Frog', 'Run', 12);
    jump = _spriteAnimation('Ninja Frog', 'Jump', 1);

    animations = {
      'idle': idle,
      'run': run,
      'jump': jump,
    };
    current = 'idle';
  }

  SpriteAnimation _spriteAnimation(String character, String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images
            .fromCache('Main Characters/${character}/${state} (32x32).png'),
        SpriteAnimationData.sequenced(
          amount: amount,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
        ));
  }

  void _updatePlayerMovement(dt) {
    double dirX = 0;
    switch (direction) {
      case PlayerDirection.up:
        current = 'jump';
        _playerJump(dt);

        break;
      case PlayerDirection.left:
        if (isfacingRight) {
          flipHorizontallyAroundCenter();
          isfacingRight = false;
        }
        current = 'run';
        dirX = -moveSpeed;

        break;
      case PlayerDirection.right:
        if (!isfacingRight) {
          flipHorizontallyAroundCenter();
          isfacingRight = true;
        }
        current = 'run';
        dirX = moveSpeed;
        break;
      case PlayerDirection.none:
        current = 'idle';
        dirX = 0;
        break;
      default:
        break;
    }
    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }

  void checkHorizontalCollisions() {
    final playerRect = toRect();
    for (final block in collisionBlocks) {
      final blockRect = block.toRect();
      if (playerRect.overlaps(blockRect)) {
        final intersection = playerRect.intersect(blockRect);
        if (intersection.width > intersection.height) {
          if (playerRect.top < blockRect.top) {
            position = Vector2(position.x, position.y - intersection.height);
          } else {
            position = Vector2(position.x, position.y + intersection.height);
          }
        } else {
          if (playerRect.left < blockRect.left) {
            position = Vector2(position.x - intersection.width, position.y);
          } else {
            position = Vector2(position.x + intersection.width, position.y);
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity * dt * 100;
    position += velocity * dt;
  }

  void _checkVerticalCollisions() {
    final playerRect = toRect();
    for (final block in collisionBlocks) {
      final blockRect = block.toRect();
      if (playerRect.overlaps(blockRect)) {
        final intersection = playerRect.intersect(blockRect);
        if (intersection.width > intersection.height) {
          if (playerRect.top < blockRect.top) {
            position = Vector2(position.x, position.y - intersection.height);
          } else {
            position = Vector2(position.x, position.y + intersection.height);
          }
        } else {
          if (playerRect.left < blockRect.left) {
            position = Vector2(position.x - intersection.width, position.y);
          } else {
            position = Vector2(position.x + intersection.width, position.y);
          }
        }
      }
    }
  }

  void _playerJump(dt) {
    if (!isJumping) return;
    if (isJumping) {
      velocity.y = -_jumpForce;
      position.y += velocity.y * dt;

      isJumping = false;
    } else {
      velocity.y += _gravity * dt * 100;
      position.y += velocity.y * dt;
    }
  }
}
