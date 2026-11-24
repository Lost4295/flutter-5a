
import 'dart:ui';

import '../../core/constants/game_constants.dart';
import '../models/player.dart';
import '../models/tile_type.dart';

class PlayerSystem {
  // Taille approximative du joueur
  static const double playerRadius = 16.0;

  void update(
    Player player,
    double dt,
    List<List<TileType>> map,
  ) {
    if (!player.isAlive) return;

    // Déplacement horizontal
    final horizontalPosition = Offset(
      player.position.dx + player.velocity.dx * dt,
      player.position.dy,
    );

    if (!_isBlocked(horizontalPosition, map)) {
      player.position = horizontalPosition;
    }

    // Déplacement vertical
    final verticalPosition = Offset(
      player.position.dx,
      player.position.dy + player.velocity.dy * dt,
    );

    if (!_isBlocked(verticalPosition, map)) {
      player.position = verticalPosition;
    }
  }

  bool _isBlocked(
    Offset position,
    List<List<TileType>> map,
  ) {
    final radius = playerRadius;
    final tileSize = GameConstants.tileSize;

    // Les quatre coins de la hitbox
    final points = [
      Offset(position.dx - radius, position.dy - radius),
      Offset(position.dx + radius, position.dy - radius),
      Offset(position.dx - radius, position.dy + radius),
      Offset(position.dx + radius, position.dy + radius),
    ];

    for (final point in points) {
      final column = (point.dx / tileSize).floor();
      final row = (point.dy / tileSize).floor();

      if (row < 0 || row >= map.length ||
          column < 0 || column >= map[row].length) {
        return true;
      }

      final tile = map[row][column];

      if (tile == TileType.indestructibleWall ||
          tile == TileType.destructibleWall) {
        return true;
      }
    }

    return false;
  }
}
