
import 'dart:ui';

import '../../core/constants/game_constants.dart';
import '../models/bomb.dart';
import '../models/explosion.dart';
import '../models/player.dart';
import '../models/tile_type.dart';

class ExplosionSystem {
  final List<Explosion> explosions = [];

  final Set<int> _processedBombIds = {};

  void update(
    List<Bomb> bombs,
    List<List<TileType>> map,
    List<Player> players,
    double dt,
  ) {
    // Déclenche les nouvelles explosions.
// Traite aussi les bombes déclenchées en chaîne.
while (true) {
  final pendingBombs = bombs
      .where(
        (bomb) =>
            bomb.hasExploded &&
            !_processedBombIds.contains(bomb.id),
      )
      .toList();

  if (pendingBombs.isEmpty) break;

  for (final bomb in pendingBombs) {
    _processedBombIds.add(bomb.id);
    _createExplosion(bomb, bombs, map, players);
  }
}

    // Met à jour la durée des flammes.
    for (final explosion in explosions) {
      explosion.remainingTime -= dt;
    }

    explosions.removeWhere(
      (explosion) => explosion.remainingTime <= 0,
    );

    // Nettoie les identifiants des bombes supprimées.
    final activeIds = bombs.map((bomb) => bomb.id).toSet();
    _processedBombIds.removeWhere(
      (id) => !activeIds.contains(id),
    );
  }

  void _createExplosion(
    Bomb bomb,
    List<Bomb> bombs,
    List<List<TileType>> map,
    List<Player> players,
  ) {
    final tileSize = GameConstants.tileSize;

    final centerColumn = (bomb.position.dx / tileSize).floor();
    final centerRow = (bomb.position.dy / tileSize).floor();

    // Explosion au centre de la bombe.
    _addExplosion(centerRow, centerColumn, players);

    // Les quatre directions.
    const directions = [
      [0, -1], // Haut
      [0, 1],  // Bas
      [-1, 0], // Gauche
      [1, 0],  // Droite
    ];

    for (final direction in directions) {
      for (int distance = 1;
          distance <= bomb.explosionRange;
          distance++) {
        final row = centerRow + direction[1] * distance;
        final column = centerColumn + direction[0] * distance;

        // Arrêt aux limites de la carte.
        if (row < 0 ||
            row >= map.length ||
            column < 0 ||
            column >= map[row].length) {
          break;
        }

        final tile = map[row][column];

        // Les murs indestructibles bloquent les flammes.
        if (tile == TileType.indestructibleWall) {
          break;
        }

        // Les murs destructibles sont détruits,
        // mais bloquent la propagation.
        if (tile == TileType.destructibleWall) {
          map[row][column] = TileType.empty;
          _addExplosion(row, column, players);
          break;
        }

        // Déclenche les bombes touchées par une explosion.
        for (final otherBomb in bombs) {
          final bombRow =
              (otherBomb.position.dy / tileSize).floor();
          final bombColumn =
              (otherBomb.position.dx / tileSize).floor();

          if (!otherBomb.hasExploded &&
              bombRow == row &&
              bombColumn == column) {
            otherBomb.hasExploded = true;
          }
        }

        _addExplosion(row, column, players);
      }
    }
  }

  void _addExplosion(
    int row,
    int column,
    List<Player> players,
  ) {
    final tileSize = GameConstants.tileSize;

    final position = Offset(
      (column + 0.5) * tileSize,
      (row + 0.5) * tileSize,
    );

    explosions.add(Explosion(position: position));

    // Inflige des dégâts aux joueurs présents sur cette case.
    for (final player in players) {
      if (!player.isAlive) continue;

      final playerRow = (player.position.dy / tileSize).floor();
      final playerColumn = (player.position.dx / tileSize).floor();

      if (playerRow == row && playerColumn == column) {
        player.health--;

        if (player.health <= 0) {
          player.isAlive = false;
          player.velocity = Offset.zero;
        }
      }
    }
  }
}
