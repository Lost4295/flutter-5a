
import 'dart:ui';

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
    this.health = 1,
    this.bombCapacity = 1,
    this.explosionRange = 2,
    this.isAlive = true,
  });
}
