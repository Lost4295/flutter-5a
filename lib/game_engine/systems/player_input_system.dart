
import 'dart:ui';

import '../models/player.dart';

class PlayerInputSystem {
  void moveUp(Player player) {
    player.velocity = Offset(
      player.velocity.dx,
      -144,
    );
  }

  void moveDown(Player player) {
    player.velocity = Offset(
      player.velocity.dx,
      144,
    );
  }

  void moveLeft(Player player) {
    player.velocity = Offset(
      -144,
      player.velocity.dy,
    );
  }

  void moveRight(Player player) {
    player.velocity = Offset(
      144,
      player.velocity.dy,
    );
  }

  void stopHorizontal(Player player) {
    player.velocity = Offset(
      0,
      player.velocity.dy,
    );
  }

  void stopVertical(Player player) {
    player.velocity = Offset(
      player.velocity.dx,
      0,
    );
  }

  void stop(Player player) {
    player.velocity = Offset.zero;
  }
}
