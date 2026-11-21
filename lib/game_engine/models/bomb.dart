
import 'dart:ui';

class Bomb {
  final int id;
  final int ownerId;
  final Offset position;

  double remainingTime;
  final int explosionRange;

  Bomb({
    required this.id,
    required this.ownerId,
    required this.position,
    this.remainingTime = 3.0,
    this.explosionRange = 2,
  });
}
