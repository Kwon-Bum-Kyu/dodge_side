import 'package:dodge_side/helper/bullets.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Bullet extends SpriteAnimationComponent with HasGameRef, BulletsMixin {
  final SpriteAnimationComponent boss;
  final double? movingDirection;
  double speed;
  final bool moveLongAngle;
  final bool increaseSpeed;

  Bullet(this.boss, this.movingDirection,
      {this.speed = 100, this.moveLongAngle = true, this.increaseSpeed = false})
      : super() {
    if (moveLongAngle && movingDirection == null) {
      throw Error();
    }
  }

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.center;
    animation = await gameRef.loadSpriteAnimation(
        'boss_bullets.png',
        SpriteAnimationData.sequenced(
            texturePosition: Vector2.zero(),
            amount: 7,
            stepTime: 0.6,
            textureSize: Vector2(13, 13),
            loop: true));
    size = Vector2(26, 26);
    add(RectangleHitbox(position: Vector2.zero(), size: size));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    boss.priority = boss.priority++;
    if (moveLongAngle) {
      moveWithAngle(movingDirection!, speed * dt);
    }
    super.update(dt);
  }
}
