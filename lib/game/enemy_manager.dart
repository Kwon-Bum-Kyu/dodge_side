import 'dart:async';
import 'dart:math';

import 'package:flame/experimental.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components.dart';
import 'package:provider/provider.dart';

import 'game.dart';
import 'enemy.dart';

import '../models/enemy_data.dart';
import '../models/player_data.dart';

// This component class takes care of spawning new enemy components
// randomly from top of the screen. It uses the HasGameReference mixin so that
// it can add child components.
class EnemyManager extends Component with HasGameReference<SpacescapeGame> {
  // The timer which runs the enemy spawner code at regular interval of time.
  late Timer _timer;

  // Controls for how long EnemyManager should stop spawning new enemies.
  late Timer _freezeTimer;

  // A reference to spriteSheet contains enemy sprites.
  SpriteSheet spriteSheet;

  // Holds an object of Random class to generate random numbers.
  Random random = Random();

  EnemyManager({required this.spriteSheet}) : super() {
    // Sets the timer to call _spawnEnemy() after every 1 second, until timer is explicitly stops.
    _timer = Timer(1, onTick: _spawnEnemy, repeat: true);

    // Sets freeze time to 2 seconds. After 2 seconds spawn timer will start again.
    _freezeTimer = Timer(2, onTick: () {
      _timer.start();
    });
  }
  @override
  Future<void> onLoad() async {
    await game.images.load('water_test.png');
  }

  // Spawns a new enemy at random position at the top of the screen.
  void _spawnEnemy() {
    // 0 : 상, 1 : 하, 2 : 좌,  3 : 우
    int randomAngle = random.nextInt(4);
    Vector2 initialSize = Vector2(32, 32);
    Vector2 position;
    Vector2 endPosition;
    // random.nextDouble() generates a random number between 0 and 1.
    // Multiplying it by game.fixedResolution.x makes sure that the value remains between 0 and width of screen.
    switch (randomAngle) {
      case 0:
        //random.nextInt(Global.deviceWidth.toInt()).toDouble()
        position = Vector2(random.nextDouble() * game.fixedResolution.x, 0);
        endPosition = Vector2(
            random.nextInt(game.fixedResolution.x.toInt()).toDouble(),
            game.fixedResolution.y);
        break;
      case 1:
        position = Vector2(random.nextDouble() * game.fixedResolution.x,
            game.fixedResolution.y);
        endPosition = Vector2(
            random.nextInt(game.fixedResolution.x.toInt()).toDouble(), 0);
        break;
      case 2:
        position = Vector2(0, random.nextDouble() * game.fixedResolution.y);
        endPosition = Vector2(game.fixedResolution.x,
            random.nextInt(game.fixedResolution.y.toInt()).toDouble());
        break;
      default:
        position = Vector2(game.fixedResolution.x,
            random.nextDouble() * game.fixedResolution.y);
        endPosition = Vector2(
            0, random.nextInt(game.fixedResolution.y.toInt()).toDouble());
        break;
    }

    // Clamps the vector such that the enemy sprite remains within the screen.
    position.clamp(
      Vector2.zero() + initialSize / 2,
      game.fixedResolution - initialSize / 2,
    );

    // Make sure that we have a valid BuildContext before using it.
    if (game.buildContext != null) {
      // Get current score and figure out the max level of enemy that
      // can be spawned for this score.
      int currentScore =
          Provider.of<PlayerData>(game.buildContext!, listen: false)
              .currentScore;
      int maxLevel = mapScoreToMaxEnemyLevel(currentScore);

      /// Gets a random [EnemyData] object from the list.
      final enemyData = _enemyDataList.elementAt(random.nextInt(maxLevel * 4));

      Enemy enemy = Enemy(
          sprite: Sprite(game.images.fromCache('water_test.png')),
          size: initialSize,
          position: position,
          enemyData: enemyData,
          randomAngle: randomAngle,
          endPoint: endPosition);

      // Makes sure that the enemy sprite is centered.
      enemy.anchor = Anchor.center;

      // Add it to components list of game instance, instead of EnemyManager.
      // This ensures the collision detection working correctly.
      game.world.add(enemy);
    }
  }

  // For a given score, this method returns a max level
  // of enemy that can be used for spawning.
  int mapScoreToMaxEnemyLevel(int score) {
    int level = 1;

    if (score > 2500) {
      level = 6;
    } else if (score > 2000) {
      level = 5;
    } else if (score > 1500) {
      level = 4;
    } else if (score > 1000) {
      level = 3;
    } else if (score > 500) {
      level = 2;
    }
    repeatTimer(level);
    return level;
  }

  void repeatTimer(int level) {
    _timer.stop();
    _timer = Timer(1 / level, onTick: _spawnEnemy, repeat: true);
  }

  @override
  void onMount() {
    super.onMount();
    // Start the timer as soon as current enemy manager get prepared
    // and added to the game instance.
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    // Stop the timer if current enemy manager is getting removed from the
    // game instance.
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update timers with delta time to make them tick.
    _timer.update(dt);
    _freezeTimer.update(dt);
  }

  // Stops and restarts the timer. Should be called
  // while restarting and exiting the game.
  void reset() {
    _timer.stop();
    _timer.start();
  }

  // Pauses spawn timer for 2 seconds when called.
  void freeze() {
    _timer.stop();
    _freezeTimer.stop();
    _freezeTimer.start();
  }

  /// A private list of all [EnemyData]s.
  static const List<EnemyData> _enemyDataList = [
    EnemyData(
      killPoint: 1,
      speed: 250,
      spriteId: 8,
      level: 1,
      hMove: false,
    ),
    EnemyData(
      killPoint: 2,
      speed: 250,
      spriteId: 9,
      level: 1,
      hMove: false,
    ),
    EnemyData(
      killPoint: 4,
      speed: 250,
      spriteId: 10,
      level: 1,
      hMove: false,
    ),
    EnemyData(
      killPoint: 4,
      speed: 250,
      spriteId: 11,
      level: 1,
      hMove: false,
    ),
    EnemyData(
      killPoint: 6,
      speed: 250,
      spriteId: 12,
      level: 2,
      hMove: false,
    ),
    EnemyData(
      killPoint: 6,
      speed: 250,
      spriteId: 13,
      level: 2,
      hMove: false,
    ),
    EnemyData(
      killPoint: 6,
      speed: 250,
      spriteId: 14,
      level: 2,
      hMove: false,
    ),
    EnemyData(
      killPoint: 6,
      speed: 250,
      spriteId: 15,
      level: 2,
      hMove: true,
    ),
    EnemyData(
      killPoint: 10,
      speed: 250,
      spriteId: 16,
      level: 3,
      hMove: false,
    ),
    EnemyData(
      killPoint: 10,
      speed: 250,
      spriteId: 17,
      level: 3,
      hMove: false,
    ),
    EnemyData(
      killPoint: 10,
      speed: 250,
      spriteId: 18,
      level: 3,
      hMove: true,
    ),
    EnemyData(
      killPoint: 10,
      speed: 250,
      spriteId: 19,
      level: 3,
      hMove: false,
    ),
    EnemyData(
      killPoint: 10,
      speed: 250,
      spriteId: 20,
      level: 4,
      hMove: false,
    ),
    EnemyData(
      killPoint: 50,
      speed: 250,
      spriteId: 21,
      level: 4,
      hMove: true,
    ),
    EnemyData(
      killPoint: 50,
      speed: 250,
      spriteId: 22,
      level: 4,
      hMove: false,
    ),
    EnemyData(
      killPoint: 50,
      speed: 250,
      spriteId: 23,
      level: 4,
      hMove: false,
    )
  ];
}
