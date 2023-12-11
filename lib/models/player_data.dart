import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

import 'charactor_details.dart';

part 'player_data.g.dart';

// This class represents all the persistent data that we
// might want to store for tracking player progress.
@HiveType(typeId: 0)
class PlayerData extends ChangeNotifier with HiveObjectMixin {
  static const String playerDataBox = 'PlayerDataBox';
  static const String playerDataKey = 'PlayerData';

  // The spaceship type of player's current spaceship.
  @HiveField(0)
  CharactorType charactorType;

  // List of all the characotrs owned by player.
  // Note that just storing their type is enough.
  @HiveField(1)
  final List<CharactorType> ownedCharactors;

  // Highest player score so far.
  @HiveField(2)
  late int _highScore;
  int get highScore => _highScore;

  // Balance money.
  @HiveField(3)
  int money;

  // Keeps track of current score.
  // If game is not running, this will
  // represent score of last round.
  int _currentScore = 0;

  int get currentScore => _currentScore;

  set currentScore(int newScore) {
    _currentScore = newScore;
    // While setting currentScore to a new value
    // also make sure to update highScore.
    if (_highScore < _currentScore) {
      _highScore = _currentScore;
    }
  }

  PlayerData({
    required this.charactorType,
    required this.ownedCharactors,
    int highScore = 0,
    required this.money,
  }) {
    _highScore = highScore;
  }

  /// Creates a new instance of [PlayerData] from given map.
  PlayerData.fromMap(Map<String, dynamic> map)
      : charactorType = map['currentSpaceshipType'],
        ownedCharactors = map['ownedSpaceshipTypes']
            .map((e) => e as CharactorType) // Map out each element.
            .cast<CharactorType>() // Cast each element to SpaceshipType.
            .toList(), // Convert to a List<SpaceshipType>.
        _highScore = map['highScore'],
        money = map['money'];

  // A default map which should be used for creating the
  // very first PlayerData instance when game is launched
  // for the first time.
  static Map<String, dynamic> defaultData = {
    'currentSpaceshipType': CharactorType.fire,
    'ownedSpaceshipTypes': [CharactorType.fire],
    'highScore': 0,
    'money': 0,
  };

  /// Returns true if given [CharactorType] is owned by player.
  bool isOwned(CharactorType charactorType) {
    return ownedCharactors.contains(charactorType);
  }

  /// Returns true if player has enough money to by given [SpaceshipType].
  bool canBuy(CharactorType charactorType) {
    return (money >= Charactor.getSpaceshipByType(charactorType).cost);
  }

  /// Returns true if player's current spaceship type is same as given [CharactorType].
  bool isEquipped(CharactorType charactorType) {
    return (this.charactorType == charactorType);
  }

  /// Buys the given [CharactorType] if player has enough money and does not already own it.
  void buy(CharactorType charactorType) {
    if (canBuy(charactorType) && (!isOwned(charactorType))) {
      money -= Charactor.getSpaceshipByType(charactorType).cost;
      ownedCharactors.add(charactorType);
      notifyListeners();

      // Saves player data to disk.
      save();
    }
  }

  /// Sets the given [CharactorType] as the current spaceship type for player.
  void equip(CharactorType charactorType) {
    this.charactorType = charactorType;
    notifyListeners();

    // Saves player data to disk.
    save();
  }
}
