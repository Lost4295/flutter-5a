
import 'package:flutter/foundation.dart';

import '../core/constants/game_constants.dart';
import 'game_state.dart';

class GameLoop extends ChangeNotifier {
  final GameState state;

  double _accumulator = 0.0;

  static const int maxUpdatesPerFrame = 5;

  GameLoop(this.state);

  double get interpolation =>
      _accumulator / GameConstants.fixedDeltaTime;

  void advance(double frameDelta) {
    // Évite les gros sauts après une interruption
    final safeDelta = frameDelta.clamp(0.0, 0.1).toDouble();

    _accumulator += safeDelta;

    int updates = 0;

    // Simulation à fréquence fixe
    while (_accumulator >= GameConstants.fixedDeltaTime &&
        updates < maxUpdatesPerFrame) {
      state.update(GameConstants.fixedDeltaTime);

      _accumulator -= GameConstants.fixedDeltaTime;
      updates++;
    }

    // Évite une accumulation excessive
    if (updates == maxUpdatesPerFrame &&
        _accumulator >= GameConstants.fixedDeltaTime) {
      _accumulator %= GameConstants.fixedDeltaTime;
    }

    notifyListeners();
  }
}
