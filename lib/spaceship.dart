import 'package:dodge_side/helper/global.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class SpaceShip extends SpriteComponent with CollisionCallbacks {
  //with HasHitboxes, Collidable
  SpaceShip() : super(size: Vector2.all(32));

  bool isLoadedFirst = false;
  bool isTouched = false;
  Direction direction = Direction.none;
  final Direction _collisionDirection = Direction.none;
  final bool _hasCollided = false;
  final double _playerSpeed = 300.0;

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('ship.png');
    anchor = Anchor.center;

    add(RectangleHitbox.relative(Vector2.all(1), parentSize: Vector2.all(1)));
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    if (!isLoadedFirst) {
      isLoadedFirst = true;

      position = gameSize / 2;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // print(dt);
    movePlayer(dt);
  }

  void movePlayer(double delta) {
    switch (direction) {
      case Direction.up:
        if (canPlayerMoveUp()) {
          moveUp(delta);
        }
        break;
      case Direction.down:
        if (canPlayerMoveDown()) {
          moveDown(delta);
        }
        break;
      case Direction.left:
        if (canPlayerMoveLeft()) {
          moveLeft(delta);
        }
        break;
      case Direction.right:
        if (canPlayerMoveRight()) {
          moveRight(delta);
        }
        break;
      case Direction.none:
        break;
    }
  }

  void moveUp(double delta) {
    position.add(Vector2(0, delta * -_playerSpeed));
  }

  void moveDown(double delta) {
    position.add(Vector2(0, delta * _playerSpeed));
  }

  void moveLeft(double delta) {
    position.add(Vector2(delta * -_playerSpeed, 0));
  }

  void moveRight(double delta) {
    position.add(Vector2(delta * _playerSpeed, 0));
  }

  // @override
  // void onCollision(Set<Vector2> points, Collidable other) {
  //   if (other is Missile) {
  //     Global.status = GameStatus.gameover;
  //   }
  // }

  void move(Vector2 movePosition) {
    if (!isTouched) {
      isTouched = toRect().contains(movePosition.toOffset());
      return;
    }

    position = movePosition;
  }

  void restart() {
    isTouched = false;
    position.x = Global.deviceWidth / 2;
    position.y = Global.deviceHeight / 2;
  }

  bool canPlayerMoveUp() {
    if (_hasCollided && _collisionDirection == Direction.up) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveDown() {
    if (_hasCollided && _collisionDirection == Direction.down) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveLeft() {
    if (_hasCollided && _collisionDirection == Direction.left) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveRight() {
    if (_hasCollided && _collisionDirection == Direction.right) {
      return false;
    }
    return true;
  }
  //   @override
  // void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  //   if (other is SpaceShip) {
  //     if (!_hasCollided) {
  //       _hasCollided = true;
  //       _collisionDirection = direction;
  //     }
  //   }
  // }

  // @override
  // void onCollisionEnd(PositionComponent other) {
  //   _hasCollided = false;
  // }
}
