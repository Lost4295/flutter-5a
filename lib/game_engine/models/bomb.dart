
import 'dart:ui';

class Bomb {
  final int id;
  final int ownerId;
  final Offset position;
  final int explosionRange;

  double remainingTime;
  bool hasExploded;

  Bomb({
    required this.id,
    required this.ownerId,
    required this.position,
    required this.explosionRange,
    this.remainingTime = 3.0,
    this.hasExploded = false,
  });
}
