import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../models/player_data.dart';
import '../models/charactor_details.dart';

import 'game_play.dart';
import 'main_menu.dart';

// Represents the spaceship selection menu from where player can
// change current spaceship or buy a new one.
class SelectCharactor extends StatelessWidget {
  const SelectCharactor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Game title.
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Select',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      blurRadius: 20.0,
                      color: Colors.white,
                      offset: Offset(0, 0),
                    )
                  ],
                ),
              ),
            ),

            // Displays current spaceship's name and amount of money left.
            Consumer<PlayerData>(
              builder: (context, playerData, child) {
                final charactor =
                    Charactor.getSpaceshipByType(playerData.charactorType);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Ship: ${charactor.name}'),
                    Text('Money: ${playerData.money}'),
                  ],
                );
              },
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: CarouselSlider.builder(
                itemCount: Charactor.charactors.length,
                slideBuilder: (index) {
                  final charactor =
                      Charactor.charactors.entries.elementAt(index).value;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(charactor.assetPath),
                      Text(charactor.name),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Speed: ${charactor.speed}'),
                          Text('Level: ${charactor.level}'),
                          Text('Cost: ${charactor.cost}'),
                        ],
                      ),
                      Consumer<PlayerData>(
                        builder: (context, playerData, child) {
                          final type =
                              Charactor.charactors.entries.elementAt(index).key;
                          final isEquipped = playerData.isEquipped(type);
                          final isOwned = playerData.isOwned(type);
                          final canBuy = playerData.canBuy(type);

                          return ElevatedButton(
                            onPressed: isEquipped
                                ? null
                                : () {
                                    if (isOwned) {
                                      playerData.equip(type);
                                    } else {
                                      if (canBuy) {
                                        playerData.buy(type);
                                      } else {
                                        // Displays an alert if player
                                        // does not have enough money.
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.red,
                                              title: const Text(
                                                'Insufficient Balance',
                                                textAlign: TextAlign.center,
                                              ),
                                              content: Text(
                                                'Need ${charactor.cost - playerData.money} more',
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                            child: Text(
                              isEquipped
                                  ? 'Equipped'
                                  : isOwned
                                      ? 'Select'
                                      : 'Buy',
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),

            // Start button.
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  // Push and replace current screen (i.e MainMenu) with
                  // GamePlay, because back press will be blocked by GamePlay.
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const GamePlay(),
                    ),
                  );
                },
                child: const Text('Start'),
              ),
            ),

            // Back button.
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const MainMenu(),
                    ),
                  );
                },
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
