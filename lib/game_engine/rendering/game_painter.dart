import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../core/constants/game_constants.dart';
import '../game_loop.dart';
import '../models/tile_type.dart';

class GamePainter extends CustomPainter {
  final GameLoop gameLoop;

  final Paint _backgroundPaint = Paint()..color = const Color(0xFF17212B);

  final Paint _emptyPaint = Paint()..color = const Color(0xFF34495E);

  final Paint _wallPaint = Paint()..color = const Color(0xFF687C8F);

  final Paint _blockPaint = Paint()..color = const Color(0xFFB97745);
  final Paint _playerPaint = Paint()..color = const Color(0xFF3498DB);

  final Paint _playerBorderPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  final Paint _gridPaint = Paint()
    ..color = const Color(0xFF263746)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  GamePainter(this.gameLoop) : super(repaint: gameLoop);

  @override
  void paint(Canvas canvas, Size size) {
    final map = gameLoop.state.map;

    final rows = GameConstants.mapRows;
    final columns = GameConstants.mapColumns;

    // Adaptation de la taille de la carte à l'écran
    final tileSize = math.min(size.width / columns, size.height / rows);

    final boardWidth = tileSize * columns;
    final boardHeight = tileSize * rows;

    final offsetX = (size.width - boardWidth) / 2;
    final offsetY = (size.height - boardHeight) / 2;

    canvas.drawRect(Offset.zero & size, _backgroundPaint);

    canvas.save();
    canvas.translate(offsetX, offsetY);

    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        final tile = map[row][column];

        final rect = Rect.fromLTWH(
          column * tileSize,
          row * tileSize,
          tileSize,
          tileSize,
        );

        switch (tile) {
          case TileType.empty:
            canvas.drawRect(rect, _emptyPaint);
            break;

          case TileType.indestructibleWall:
            canvas.drawRect(rect, _wallPaint);
            break;

          case TileType.destructibleWall:
            canvas.drawRect(rect, _blockPaint);
            break;

          default:
            canvas.drawRect(rect, _emptyPaint);
            break;
        }

        canvas.drawRect(rect, _gridPaint);
      }
    }
    // Échelle entre les coordonnées du jeu et celles de l'écran
    final scale = tileSize / GameConstants.tileSize;

    for (final player in gameLoop.state.players) {
      if (!player.isAlive) continue;

      final playerCenter = Offset(
        player.position.dx * scale,
        player.position.dy * scale,
      );

      final radius = 14.0 * scale;

      canvas.drawCircle(playerCenter, radius, _playerPaint);

      canvas.drawCircle(playerCenter, radius, _playerBorderPaint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    return oldDelegate.gameLoop != gameLoop;
  }
}
