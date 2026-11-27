
import 'dart:ui';

import '../../core/constants/game_constants.dart';
import '../models/player.dart';

class PlayerInputSystem {
  final Set<String> _pressedDirections = {};

  double get movementSpeed =>
      GameConstants.defaultPlayerSpeed * GameConstants.tileSize;

  void press(Player player, String direction) {
    _pressedDirections.add(direction);
    _updateVelocity(player);
  }

  void release(Player player, String direction) {
    _pressedDirections.remove(direction);
    _updateVelocity(player);
  }

  void stop(Player player) {
    _pressedDirections.clear();
    player.velocity = Offset.zero;
  }

  void _updateVelocity(Player player) {
    if (!player.isAlive) {
      player.velocity = Offset.zero;
      return;
    }

    double x = 0;
    double y = 0;

    if (_pressedDirections.contains('left')) x--;
    if (_pressedDirections.contains('right')) x++;
    if (_pressedDirections.contains('up')) y--;
    if (_pressedDirections.contains('down')) y++;

    final direction = Offset(x, y);

    if (direction == Offset.zero) {
      player.velocity = Offset.zero;
    } else {
      player.velocity =
          direction / direction.distance * movementSpeed;
    }
  }
}
