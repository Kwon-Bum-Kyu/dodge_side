import 'package:dodge_side/global.dart';
import 'package:dodge_side/missile.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class SpaceShip extends SpriteComponent {
  //with HasHitboxes, Collidable
  SpaceShip() : super(size: Vector2.all(32));

  bool isLoadedFirst = false;
  bool isTouched = false;

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('ship.png');
    anchor = Anchor.center;

    // final hitbox = HitboxRectangle(relation: Vector2.all(0.5));
    // addHitbox(hitbox);
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

    if (Global.isPause() || Global.isOver()) return;
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
}
