import 'package:dodge_side/game_manager.dart';
import 'package:dodge_side/global.dart';
import 'package:dodge_side/main_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final manager = GameManager();
  final menuOverlay = MenuOverlay(game: manager);
  manager.menu = menuOverlay;
  runApp(
    MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: Global.deviceWidth,
              height: Global.deviceWidth,
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
