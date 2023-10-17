import 'package:dodge_side/game_manager.dart';
import 'package:dodge_side/main_overlay.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  await Flame.device.fullScreen();
  final manager = GameManager();
  final menuOverlay = MenuOverlay(game: manager);
  manager.menu = menuOverlay;
  runApp(
    MaterialApp(
      home: Scaffold(
        body: SafeArea(
          left: false,
          right: false,
          top: false,
          bottom: false,
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              // width: Global.deviceWidth,
              // height: Global.deviceWidth,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GameWidget(game: manager),
                  menuOverlay,
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
