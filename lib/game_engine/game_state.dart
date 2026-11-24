
import 'models/tile_type.dart';
import '../core/constants/game_constants.dart';

class GameState {
  late final List<List<TileType>> map;

  double elapsedTime = 0.0;

  GameState() {
    _generateMap();
  }

  void _generateMap() {
    map = List.generate(
      GameConstants.mapRows,
      (row) => List.generate(
        GameConstants.mapColumns,
        (column) {
          // Murs extérieurs
          if (row == 0 ||
              column == 0 ||
              row == GameConstants.mapRows - 1 ||
              column == GameConstants.mapColumns - 1) {
            return TileType.indestructibleWall;
          }

          // Murs fixes à intervalles réguliers
          if (row.isEven && column.isEven) {
            return TileType.indestructibleWall;
          }

          // Blocs destructibles
          if ((row * 7 + column * 3) % 5 == 0) {
            return TileType.destructibleWall;
          }

          return TileType.empty;
        },
      ),
    );

    // Zones de départ des quatre premiers joueurs
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
  }
}
