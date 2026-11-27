
import 'dart:ui';

import '../core/constants/game_constants.dart';
import 'models/player.dart';
import 'models/tile_type.dart';
import 'systems/player_system.dart';
import 'systems/bomb_system.dart';
import 'systems/explosion_system.dart';

class GameState {
  late final List<List<TileType>> map;

  final List<Player> players = [];

  final PlayerSystem playerSystem = PlayerSystem();
  final BombSystem bombSystem = BombSystem();
  final ExplosionSystem explosionSystem = ExplosionSystem();

  double elapsedTime = 0.0;

  GameState() {
    _generateMap();

    // Création du premier joueur au centre de la case (1, 1).
    players.add(
      Player(
        id: 1,
        position: Offset(
          1.5 * GameConstants.tileSize,
          1.5 * GameConstants.tileSize,
        ),
      ),
    );
  }

  void _generateMap() {
    map = List.generate(
      GameConstants.mapRows,
      (row) => List.generate(
        GameConstants.mapColumns,
        (column) {
          if (row == 0 ||
              column == 0 ||
              row == GameConstants.mapRows - 1 ||
              column == GameConstants.mapColumns - 1) {
            return TileType.indestructibleWall;
          }

          if (row.isEven && column.isEven) {
            return TileType.indestructibleWall;
          }

          if ((row * 7 + column * 3) % 5 == 0) {
            return TileType.destructibleWall;
          }

          return TileType.empty;
        },
      ),
    );

    const spawnZones = [
      [1, 1], [1, 2], [2, 1],
      [1, 13], [1, 12], [2, 13],
      [11, 1], [11, 2], [10, 1],
      [11, 13], [11, 12], [10, 13],
    ];

    for (final zone in spawnZones) {
      map[zone[0]][zone[1]] = TileType.empty;
    }
  }

  void update(double dt) {
    elapsedTime += dt;

    // 1. Déplacement des joueurs.
    for (final player in players) {
      playerSystem.update(player, dt, map);
    }

    // 2. Mise à jour du compte à rebours des bombes.
    bombSystem.update(dt);

    // 3. Calcul des explosions et des dégâts.
    explosionSystem.update(
      bombSystem.bombs,
      map,
      players,
      dt,
    );
  }
}
