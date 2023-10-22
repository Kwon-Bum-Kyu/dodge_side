import 'dart:async' as async;
import 'dart:math';

import 'package:dodge_side/helper/game_wall.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'component/bullet.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();
  var bulletHell = BulletHell();
  runApp(GameWidget(game: bulletHell));
}

late Vector2 viewPortSize;

class BulletHell extends FlameGame with HasCollisionDetection {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    viewPortSize = size;
    camera.viewport = FixedResolutionViewport(size);

    await addParallaxBackground();
    await addBoss();
    await add(GameWall());
  }

  Future<void> addBoss() async {
    var imageSize = Vector2(101, 64);
    final running = await loadSpriteAnimation(
      'boss.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: imageSize,
        stepTime: 0.5,
      ),
    );

    var boss = SpriteAnimationComponent(
        priority: 1,
        animation: running,
        anchor: Anchor.center,
        size: imageSize,
        angle: pi,
        position: Vector2(size.x / 2.0, -10),
        scale: Vector2(0.5, 0.5));

    boss.add(SequenceEffect(
      [
        MoveEffect.to(
            Vector2(size.x / 2.0, 500),
            EffectController(
                duration: 1, infinite: false, curve: Curves.bounceIn)),
        MoveEffect.to(
            Vector2(size.x / 2.0, 300),
            EffectController(
                duration: 1, infinite: false, curve: Curves.easeInExpo))
      ],
    ));

    var counter = 10;
    const patterns = 10;
    var i = 0;
    async.Timer.periodic(const Duration(seconds: 5), (timer) {
      switch (i) {
        case 0:
          hellOne(counter, boss);
          break;
        case 1:
          hellTwo(counter, boss);
          break;
        case 2:
          hellThree(counter, boss);
          break;
        case 3:
          hellFour(counter, boss);
          break;
        case 4:
          hellFive(counter, boss);
          break;
        case 5:
          hellSix(counter, boss);
          break;
        case 6:
          hellSeven(counter, boss);
          break;
        case 7:
          hellEight(counter, boss);
          break;
        case 8:
          hellNine(counter, boss);
          break;
        case 9:
          hellTen(counter, boss);
          break;
      }
      i = (i + 1) % patterns;
    });

    add(boss);
  }

  void hellTen(int counter, SpriteAnimationComponent boss) {
    double speed = 100;
    async.Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (timer.tick == counter) {
        counter++;
        timer.cancel();
      }

      var positionComponent =
          PositionComponent(position: boss.position, size: Vector2(600, 600));

      for (int i = 0; i < 37; i++) {
        var bullet = Bullet(boss, -(pi / 37 - pi) * i, speed: speed)
          ..position = Vector2.zero()
          ..scale = boss.scale;
        positionComponent.add(bullet
          ..add(SequenceEffect([
            OpacityEffect.to(
              0.2,
              SineEffectController(period: 2),
            ),
            OpacityEffect.to(
              1,
              SineEffectController(period: 2),
            ),
          ])));
      }
      add(positionComponent);
    });
  }

  void hellNine(int counter, SpriteAnimationComponent boss) {
    double speed = 100;
    async.Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (timer.tick == counter) {
        counter++;
        timer.cancel();
      }

      for (int i = 0; i < 37; i++) {
        var bullet = Bullet(boss, (pi / 37 - pi) * i, speed: speed)
          ..position = boss.position
          ..scale = boss.scale;

        bullet.add(MoveAlongPathEffect(
            Path()
              ..lineTo(0, 100)
              ..lineTo(100, 0)
              ..lineTo(0, -100)
              ..lineTo(-100, 0)
              ..lineTo(0, 100)
              ..close(),
            SineEffectController(period: 2)));
        add(bullet);
      }
    });
  }

  void hellEight(int counter, SpriteAnimationComponent boss) {
    double speed = 100;
    async.Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (timer.tick == counter) {
        counter++;
        timer.cancel();
      }

      var positionComponent =
          PositionComponent(position: boss.position, size: Vector2(600, 600));
      for (int i = 0; i < 37; i++) {
        var bullet = Bullet(boss, (pi / 37 - pi) * i, speed: speed)
          ..position = Vector2.zero()
          ..scale = boss.scale;
        positionComponent.add(bullet);
      }
      add(positionComponent
        ..add(RotateEffect.to(2 * pi, SineEffectController(period: 10))));
    });
  }

  void hellSeven(int counter, SpriteAnimationComponent boss) {
    double speed = 100;
    async.Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (timer.tick == counter) {
        counter++;
        timer.cancel();
      }

      for (int i = 0; i < 37; i++) {
        var bullet = Bullet(boss, (pi / 37 - pi) * i, speed: speed)
          ..position = boss.position
          ..scale = boss.scale
          ..add(SequenceEffect([
            OpacityEffect.to(
              0.2,
              SineEffectController(period: 2),
            ),
            OpacityEffect.to(
              1,
              SineEffectController(period: 2),
            ),
          ]));

        add(bullet);
      }
    });
  }

  void hellSix(int counter, SpriteAnimationComponent boss) {
    double speed = 100;
    async.Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (timer.tick == counter) {
        counter++;
        timer.cancel();
      }

      for (int i = 0; i < 37; i++) {
        var bullet = Bullet(boss, (pi / 37 - pi) * i, speed: speed)
          ..position = boss.position
          ..scale = boss.scale
          ..add(SequenceEffect([
            MoveAlongPathEffect(
                Path()
                  ..lineTo(
                      Random().nextBool() ? 1 : -1 * Random().nextDouble() * 60,
                      Random().nextBool()
                          ? 1
                          : -1 * Random().nextDouble() * 60),
                NoiseEffectController(duration: 3, frequency: 100))
          ]));

        add(bullet);
      }
    });
  }

  void hellFive(int counter, SpriteAnimationComponent boss) {
    double speed = 100;
    async.Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (timer.tick == counter) {
        counter++;
        timer.cancel();
      }

      for (int i = 0; i < 37; i++) {
        var bullet = Bullet(boss, (pi / 37 - pi) * i, speed: speed)
          ..position = boss.position
          ..scale = boss.scale
          ..add((SequenceEffect([
            MoveToEffect(Vector2(100, 200),
                NoiseEffectController(duration: 2, frequency: 2)),
          ])));

        add(bullet);
      }
    });
  }

  void hellFour(int counter, SpriteAnimationComponent boss) {
    double speed = 100;
    async.Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (timer.tick == counter) {
        counter++;
        timer.cancel();
      }

      for (int i = 0; i < 37; i++) {
        var bullet = Bullet(boss, (pi / 37 - pi) * i, speed: speed)
          ..position = boss.position
          ..scale = boss.scale
          ..add(SequenceEffect([
            GlowEffect(10.0, SineEffectController(period: 2),
                style: BlurStyle.outer),
            MoveByEffect(Vector2(0, 10), ZigzagEffectController(period: 0.2)),
            MoveByEffect(Vector2(0, -10), ZigzagEffectController(period: 0.2)),
            MoveByEffect(Vector2(10, 0), ZigzagEffectController(period: 0.2)),
            MoveByEffect(Vector2(-10, 0), ZigzagEffectController(period: 0.2))
          ]));

        add(bullet);
      }
    });
  }

  void hellThree(int counter, SpriteAnimationComponent boss) {
    double speed = 100;
    async.Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (timer.tick == counter) {
        counter++;
        timer.cancel();
      }

      for (int i = 0; i < 37; i++) {
        var bullet = Bullet(boss, (pi / 37 - pi) * i, speed: speed)
          ..position = boss.position
          ..scale = boss.scale
          ..add(SequenceEffect([
            MoveToEffect(Vector2(100, 200), SineEffectController(period: 8)),
            MoveToEffect(Vector2(-100, -200), SineEffectController(period: 8)),
          ]));

        add(bullet);
      }
    });
  }

  void hellTwo(int counter, SpriteAnimationComponent boss) {
    double speed = 100;
    async.Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (timer.tick == counter) {
        counter++;
        timer.cancel();
      }

      for (int i = 0; i < 37; i++) {
        var bullet = Bullet(boss, (pi / 37 - pi) * i, speed: speed)
          ..position = boss.position
          ..scale = boss.scale;

        add(bullet);
      }
    });
  }

  void hellOne(int counter, SpriteAnimationComponent boss) {
    double speed = 100;
    var i = 0;
    async.Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (timer.tick == counter) {
        counter++;
        timer.cancel();
      }
      var radians = i * 2 * pi / 10;
      i = (i + 1) % 37;
      var path = Path()..lineTo(cos(radians) * 100, sin(radians) * 100);

      for (int i = 0; i < 37; i++) {
        var bullet = Bullet(boss, (pi / 37 - pi) * i, speed: speed)
          ..position = boss.position
          ..scale = boss.scale;

        bullet.add(MoveAlongPathEffect(path, SineEffectController(period: 2)));
        add(bullet);
      }
    });
  }

  Future<void> addParallaxBackground() async {
    final layerInfo = {
      'background_1.png': 6.0,
      'background_2.png': 8.5,
      'background_3.png': 12.0,
      'background_4.png': 20.5,
    };

    final layers = layerInfo.entries.map(
      (entry) => loadParallaxLayer(
        ParallaxImageData(entry.key),
        fill: LayerFill.width,
        repeat: ImageRepeat.repeat,
        velocityMultiplier: Vector2(entry.value, entry.value),
      ),
    );

    final parallax = ParallaxComponent(
      parallax: Parallax(
        await Future.wait(layers),
        baseVelocity: Vector2(10, 10),
      ),
    );

    Random().nextBool() ? ImageRepeat.repeatX : ImageRepeat.repeatY;
    async.Timer.periodic(const Duration(seconds: 5), (timer) {
      parallax.parallax?.baseVelocity = Vector2(
        Random().nextBool()
            ? Random().nextInt(20).toDouble()
            : -Random().nextInt(20).toDouble(),
        Random().nextBool()
            ? Random().nextInt(20).toDouble()
            : -Random().nextInt(20).toDouble(),
      );
    });
    add(parallax);
  }
}
