import 'dart:ui';

import '../../core/constants/game_constants.dart';
import '../models/bomb.dart';
import '../models/player.dart';
import '../models/tile_type.dart';

class BombSystem {
  final List<Bomb> bombs = [];

  int _nextBombId = 1;

  bool placeBomb(Player player) {
    if (!player.isAlive) return false;

    // Vérifie la capacité maximale de bombes du joueur.
    final playerBombs = bombs.where(
      (bomb) => bomb.ownerId == player.id && !bomb.hasExploded,
    );

    if (playerBombs.length >= player.bombCapacity) {
      return false;
    }

    // Empêche de poser plusieurs bombes au même endroit.
    final position = _snapToTileCenter(player.position);

    final alreadyExists = bombs.any(
      (bomb) => !bomb.hasExploded && bomb.position == position,
    );

    if (alreadyExists) return false;

    bombs.add(
      Bomb(
        id: _nextBombId++,
        ownerId: player.id,
        position: position,
        explosionRange: player.explosionRange,
        remainingTime: GameConstants.bombExplosionDelay,
      ),
    );

    return true;
  }

  void update(double dt) {
    for (final bomb in bombs) {
      if (bomb.hasExploded) continue;

      bomb.remainingTime -= dt;

      if (bomb.remainingTime <= 0) {
        bomb.hasExploded = true;
      }
    }
  }

  Offset _snapToTileCenter(Offset position) {
    final tileSize = GameConstants.tileSize;

    final column = (position.dx / tileSize).floor();
    final row = (position.dy / tileSize).floor();

    return Offset(
      (column + 0.5) * tileSize,
      (row + 0.5) * tileSize,
    );
  }

  void removeExplodedBombs() {
    bombs.removeWhere((bomb) => bomb.hasExploded);
  }
}