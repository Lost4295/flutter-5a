
import 'dart:ui';

import 'package:bomberman_multiplayer/core/constants/game_constants.dart';

class Player {
  final int id;
  Offset position;
  Offset velocity;

  int health;
  int bombCapacity;
  int explosionRange;

  bool isAlive;

  Player({
    required this.id,
    required this.position,
    this.velocity = Offset.zero,
    this.health = GameConstants.defaultPlayerHealth,
    this.bombCapacity = 3,
    this.explosionRange = GameConstants.defaultExplosionRange,
    this.isAlive = true,
  });
  // Déplacer le joueur vers une case spécifique sur la carte
  void moveToTile(int newRow, int newColumn) {
    position = Offset(
      newColumn * GameConstants.tileSize + GameConstants.tileSize / 2,
      newRow * GameConstants.tileSize + GameConstants.tileSize / 2,
    );
  }

// Mise à jour de la position selon la vitesse
void updatePosition(double dt) {
  if (!isAlive) return;

  position += velocity * dt;
}

  // Éliminer le joueur
  void eliminate() {
    isAlive = false;
  }
}
