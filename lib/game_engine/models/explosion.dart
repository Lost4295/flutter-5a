import 'dart:ui';

class Explosion {
  final Offset position;
  double remainingTime;

  Explosion({
    required this.position,
    this.remainingTime = 0.5,
  });
}