
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/game_constants.dart';
import '../game_loop.dart';
import '../models/tile_type.dart';

class GamePainter extends CustomPainter {
  final GameLoop gameLoop;

  final Paint _backgroundPaint =
      Paint()..color = const Color(0xFF17212B);

  final Paint _emptyPaint =
      Paint()..color = const Color(0xFF34495E);

  final Paint _wallPaint =
      Paint()..color = const Color(0xFF687C8F);

  final Paint _blockPaint =
      Paint()..color = const Color(0xFFB97745);

  final Paint _playerPaint =
      Paint()..color = const Color(0xFF3498DB);

  final Paint _playerBorderPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  final Paint _gridPaint = Paint()
    ..color = const Color(0xFF263746)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  final Paint _bombPaint =
      Paint()..color = const Color(0xFF202020);

  final Paint _bombHighlightPaint =
      Paint()..color = const Color(0xFF626262);

  final Paint _fusePaint = Paint()
    ..color = const Color(0xFFFFD166)
    ..strokeWidth = 3
    ..strokeCap = StrokeCap.round;

  final Paint _fireOuterPaint =
      Paint()..color = const Color(0xFFFF6B00);

  final Paint _fireInnerPaint =
      Paint()..color = const Color(0xFFFFD43B);

  GamePainter(this.gameLoop) : super(repaint: gameLoop);

  @override
  void paint(Canvas canvas, Size size) {
    final map = gameLoop.state.map;

    final rows = GameConstants.mapRows;
    final columns = GameConstants.mapColumns;

    final tileSize = math.min(
      size.width / columns,
      size.height / rows,
    );

    final boardWidth = tileSize * columns;
    final boardHeight = tileSize * rows;

    final offsetX = (size.width - boardWidth) / 2;
    final offsetY = (size.height - boardHeight) / 2;

    canvas.drawRect(Offset.zero & size, _backgroundPaint);

    canvas.save();
    canvas.translate(offsetX, offsetY);

    // 1. Dessin de la carte.
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

    // Échelle entre les coordonnées du jeu et celles de l'écran.
    final scale = tileSize / GameConstants.tileSize;

    // 2. Dessin des explosions.
    for (final explosion
        in gameLoop.state.explosionSystem.explosions) {
      final center = Offset(
        explosion.position.dx * scale,
        explosion.position.dy * scale,
      );

      final outerRect = Rect.fromCenter(
        center: center,
        width: tileSize * 0.85,
        height: tileSize * 0.85,
      );

      final innerRect = Rect.fromCenter(
        center: center,
        width: tileSize * 0.48,
        height: tileSize * 0.48,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          outerRect,
          Radius.circular(tileSize * 0.2),
        ),
        _fireOuterPaint,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          innerRect,
          Radius.circular(tileSize * 0.2),
        ),
        _fireInnerPaint,
      );
    }

    // 3. Dessin des bombes non encore explosées.
    for (final bomb in gameLoop.state.bombSystem.bombs) {
      if (bomb.hasExploded) continue;

      final center = Offset(
        bomb.position.dx * scale,
        bomb.position.dy * scale,
      );

      final radius = 13.0 * scale;

      canvas.drawCircle(center, radius, _bombPaint);

      canvas.drawCircle(
        Offset(
          center.dx - radius * 0.3,
          center.dy - radius * 0.3,
        ),
        radius * 0.3,
        _bombHighlightPaint,
      );

      // Petite mèche.
      final fuseStart = Offset(
        center.dx + radius * 0.5,
        center.dy - radius * 0.7,
      );

      final fuseEnd = Offset(
        center.dx + radius * 0.9,
        center.dy - radius * 1.2,
      );

      canvas.drawLine(fuseStart, fuseEnd, _fusePaint);
    }

    // 4. Dessin des joueurs au premier plan.
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
