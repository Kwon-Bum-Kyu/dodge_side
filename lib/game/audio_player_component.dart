import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:provider/provider.dart';

import 'game.dart';

import '../models/settings.dart';

class AudioPlayerComponent extends Component
    with HasGameReference<SpacescapeGame> {
  @override
  Future<void>? onLoad() async {
    FlameAudio.bgm.initialize();

    await FlameAudio.audioCache.loadAll([
      'laser1.ogg',
      'powerUp6.ogg',
    ]);

    try {
      await FlameAudio.audioCache.load(
        'River 6-29.wav',
      );
    } catch (_) {
      // ignore: avoid_print
      print('Missing VOiD1 Gaming music pack: '
          'https://brevynmusic.itch.io/short-circuits-energetic-8-bit'
          'See assets/audio/README.md for more information.');
    }

    return super.onLoad();
  }

  void playBgm(String filename) {
    if (!FlameAudio.audioCache.loadedFiles.containsKey(filename)) return;

    if (game.buildContext != null) {
      if (Provider.of<Settings>(game.buildContext!, listen: false)
          .backgroundMusic) {
        FlameAudio.bgm.play(filename);
      }
    }
  }

  void playSfx(String filename) {
    if (game.buildContext != null) {
      if (Provider.of<Settings>(game.buildContext!, listen: false)
          .soundEffects) {
        FlameAudio.play(filename);
      }
    }
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }
}
