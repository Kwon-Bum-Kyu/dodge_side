import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
// import 'package:flame/sprite.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/overlays/pause_menu.dart';
import '../widgets/overlays/pause_button.dart';
import '../widgets/overlays/game_over_menu.dart';

import '../models/player_data.dart';
import '../models/charactor_details.dart';

import './enemy.dart';
// import './health_bar.dart';
import './player.dart';
import './command.dart';
import './enemy_manager.dart';
import './audio_player_component.dart';

// This class is responsible for initializing and running the game-loop.
class SpacescapeGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  // The whole game world.
  final World world = World();

  late CameraComponent primaryCamera;

  // Stores a reference to player component.
  late Player _player;

  // Stores a reference to the main spritesheet.
  late Sprite sprite;

  // Stores a reference to an enemy manager component.
  late EnemyManager _enemyManager;

  // Displays player score on top left.
  late TextComponent _playerScore;
  // late TextComponent _highScore;

  // Displays player helth on top right.
  // late TextComponent _playerHealth;

  late AudioPlayerComponent _audioPlayerComponent;

  // List of commands to be processed in current update.
  final _commandList = List<Command>.empty(growable: true);

  // List of commands to be processed in next update.
  final _addLaterCommandList = List<Command>.empty(growable: true);

  // Indicates wheater the game world has been already initilized.
  bool _isAlreadyLoaded = false;

  // Returns the size of the playable area of the game window.
  Vector2 fixedResolution = Vector2(960, 540);

  // This method gets called by Flame before the game-loop begins.
  // Assets loading and adding component should be done here.
  @override
  Future<void> onLoad() async {
    // Initilize the game world only one time.
    if (!_isAlreadyLoaded) {
      // Loads and caches all the images for later use.
      await images.loadAll(
          ['fire_char_walk.png', 'background.png', 'water_bullet_default.png']);

      sprite = Sprite(images.fromCache('water_bullet_default.png'));

      await add(world);

      // Create a basic joystick component on left.
      final joystick = JoystickComponent(
        anchor: Anchor.bottomLeft,
        position: Vector2(30, fixedResolution.y - 180),
        // size: 100,
        background: CircleComponent(
          radius: 60,
          paint: Paint()..color = Colors.white.withOpacity(0.5),
        ),
        knob: CircleComponent(radius: 30),
      );

      primaryCamera = CameraComponent.withFixedResolution(
        world: world,
        width: fixedResolution.x,
        height: fixedResolution.y,
        hudComponents: [joystick],
      )..viewfinder.position = fixedResolution / 2;
      await add(primaryCamera);

      _audioPlayerComponent = AudioPlayerComponent();
      final background = SpriteComponent(
          sprite: Sprite(images.fromCache('background.png')),
          size: fixedResolution); //images.fromCache('background.png');
      final stars = await ParallaxComponent.load(
        [ParallaxImageData('stars1.png'), ParallaxImageData('stars2.png')],
        repeat: ImageRepeat.repeat,
        baseVelocity: Vector2(0, -50),
        velocityMultiplierDelta: Vector2(0, 1.5),
        size: fixedResolution,
      );

      /// As build context is not valid in onLoad() method, we
      /// cannot get current [PlayerData] here. So initilize player
      /// with the default SpaceshipType.Canary.
      const charactorType = CharactorType.fire;
      // final spaceship = Spaceship.getSpaceshipByType(spaceshipType);

      _player = Player(
        joystick: joystick,
        charactorType: charactorType,
        sprite: Sprite(images.fromCache('fire_char_walk.png')),
        size: Vector2(64, 64),
        position: fixedResolution / 2,
      );

      // Makes sure that the sprite is centered.
      _player.anchor = Anchor.center;

      _enemyManager = EnemyManager(sprite: sprite);

      // Create text component for player score.
      _playerScore = TextComponent(
        text: 'Score: 0',
        position: Vector2(30, 30),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontFamily: 'NexonCart',
          ),
        ),
      );

      // _highScore = TextComponent(
      //   text: 'HighScore: ${}',
      //   // anchor: Anchor.topRight,
      //   position: Vector2(fixedResolution.x - 30, 30),
      //   textRenderer: TextPaint(
      //     style: const TextStyle(
      //       color: Colors.white,
      //       fontSize: 36,
      //       fontFamily: 'BungeeInline',
      //     ),
      //   ),
      // );
      // _highScore.anchor = Anchor.topRight;
      // // Create text component for player health.
      // _playerHealth = TextComponent(
      //   text: 'Health: 100%',
      //   position: Vector2(fixedResolution.x - 10, 10),
      //   textRenderer: TextPaint(
      //     style: const TextStyle(
      //       color: Colors.white,
      //       fontSize: 12,
      //       fontFamily: 'BungeeInline',
      //     ),
      //   ),
      // );

      // Anchor to top right as we want the top right
      // corner of this component to be at a specific position.
      // _playerHealth.anchor = Anchor.topRight;

      // Add the blue bar indicating health.
      // final healthBar = HealthBar(
      //   player: _player,
      //   position: _playerHealth.positionOfAnchor(Anchor.topLeft),
      //   priority: -1,
      // );

      // Makes the game use a fixed resolution irrespective of the windows size.
      await world.addAll([
        _audioPlayerComponent,
        background,
        stars,
        _player,
        _enemyManager,
        // button,
        _playerScore,
        // _highScore
        // _playerHealth,
        // healthBar,
      ]);

      // Set this to true so that we do not initilize
      // everything again in the same session.
      _isAlreadyLoaded = true;
    }
  }

  // This method gets called when game instance gets attached
  // to Flutter's widget tree.
  @override
  void onAttach() {
    if (buildContext != null) {
      // Get the PlayerData from current build context without registering a listener.
      final playerData = Provider.of<PlayerData>(buildContext!, listen: false);
      // Update the current spaceship type of player.
      _player.setCharactorType(playerData.charactorType);
    }
    _audioPlayerComponent.playBgm('River 6-29.wav');
    super.onAttach();
  }

  @override
  void onDetach() {
    _audioPlayerComponent.stopBgm();
    super.onDetach();
  }

  // ===================================
  // IMPORTANT NOTE
  // Those overrides are obsolete since Flame v1.2.0 version
  // This code remains as is as a reference for the YouTube tutorial.
  // ===================================
  // @override
  // void prepare(Component c) {
  //   super.prepare(c);

  //   // If the component being prepared is of type KnowsGameSize,
  //   // call onResize() on it so that it stores the current game screen size.
  //   if (c is KnowsGameSize) {
  //     c.onResize(size);
  //   }
  // }

  // @override
  // void onResize(Vector2 canvasSize) {
  //   super.onResize(canvasSize);

  //   // Loop over all the components of type KnowsGameSize and resize then as well.
  //   children.whereType<KnowsGameSize>().forEach((component) {
  //     component.onResize(size);
  //   });
  // }
  // ===================================

  @override
  void update(double dt) {
    super.update(dt);

    // Run each command from _commandList on each
    // component from components list. The run()
    // method of Command is no-op if the command is
    // not valid for given component.
    for (var command in _commandList) {
      for (var component in world.children) {
        command.run(component);
      }
    }
    _player.addToScore(1);
    // Remove all the commands that are processed and
    // add all new commands to be processed in next update.
    _commandList.clear();
    _commandList.addAll(_addLaterCommandList);
    _addLaterCommandList.clear();

    if (_player.isMounted) {
      // Update score and health components with latest values.
      _playerScore.text = 'Score: ${_player.score / 100}';
      // _playerHealth.text = 'Health: ${_player.health}%';

      /// Display [GameOverMenu] when [Player.health] becomes
      /// zero and camera stops shaking.
      // if (_player.health <= 0 && (!camera.shaking)) {
      if (_player.health <= 0) {
        pauseEngine();
        overlays.remove(PauseButton.id);
        overlays.add(GameOverMenu.id);
      }
    }
  }

  // This method handles state of app and pauses
  // the game when necessary.
  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (_player.health > 0) {
          pauseEngine();
          overlays.remove(PauseButton.id);
          overlays.add(PauseMenu.id);
        }
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }

    super.lifecycleStateChange(state);
  }

  // Adds given command to command list.
  void addCommand(Command command) {
    _addLaterCommandList.add(command);
  }

  // Resets the game to inital state. Should be called
  // while restarting and exiting the game.
  void reset() {
    // First reset player, enemy manager and power-up manager .
    _player.reset();
    _enemyManager.reset();

    // Now remove all the enemies, bullets and power ups
    // from the game world. Note that, we are not calling
    // Enemy.destroy() because it will unnecessarily
    // run explosion effect and increase players score.
    world.children.whereType<Enemy>().forEach((enemy) {
      enemy.removeFromParent();
    });

    // world.children.whereType<Bullet>().forEach((bullet) {
    //   bullet.removeFromParent();
    // });
  }
}
