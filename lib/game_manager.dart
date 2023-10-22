import 'package:dodge_side/helper/global.dart';
import 'package:dodge_side/main_overlay.dart';
import 'package:dodge_side/missile.dart';
import 'package:dodge_side/spaceship.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:flame/input.dart';

class GameManager extends FlameGame with HasCollisionDetection, KeyboardEvents {
  late SpaceShip spaceShip;
  late MenuOverlay menu;
  final List<Missile> missiles = [];

  int createCount = 50;

  @override
  Future<void> onLoad() async {
    Global.deviceWidth = size[0];
    Global.deviceHeight = size[1];

    spaceShip = SpaceShip();
    add(spaceShip);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (Global.isPause()) return;
    if (Global.isOver()) {
      menu.refreshScreen();
      return;
    }

    if (createCount > 0) {
      var missile = Missile();
      add(missile);
      missiles.add(missile);
      createCount--;
    }

    Global.score += dt;

    if (Global.score >= Global.level * 10 && Global.level <= 20) {
      Global.level++;
      Global.gameSpeed += 10;
      createCount += 5;
    }
    menu.refreshScreen();
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;
    Direction? keyDirection;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      keyDirection = Direction.left;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      keyDirection = Direction.right;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      keyDirection = Direction.up;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      keyDirection = Direction.down;
    }

    if (isKeyDown && keyDirection != null) {
      spaceShip.direction = keyDirection;
    } else if (!isKeyDown && spaceShip.direction == keyDirection) {
      spaceShip.direction = Direction.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void onJoypadDirectionChanged(Direction direction) {
    spaceShip.direction = direction;
  }

  // @override
  // void onMouseMove(PointerHoverInfo info) {
  //   if (Global.isPause() || Global.isOver()) return;

  //   spaceShip.move(info.eventPosition.game);
  // }

  void restart() {
    for (var missile in missiles) {
      remove(missile);
    }
    missiles.clear();
    createCount = 50;
    spaceShip.restart();
    Global.level = 1;
    Global.gameSpeed = 100;
    Global.score = 0;
    Global.status = GameStatus.run;
  }
}
