
import 'package:material_ui/material_ui.dart';
import 'package:flutter/scheduler.dart';

import '../../game_engine/game_loop.dart';
import '../../game_engine/game_state.dart';
import '../../game_engine/rendering/game_painter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {

  late final Ticker _ticker;
  late final GameLoop _gameLoop;

  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();

    _gameLoop = GameLoop(GameState());

    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    final frameDelta =
        (elapsed - _lastElapsed).inMicroseconds / 1000000.0;

    _lastElapsed = elapsed;

    _gameLoop.advance(frameDelta);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _gameLoop.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17212B),

      appBar: AppBar(
        title: const Text('Bomberman Multiplayer'),
        backgroundColor: const Color(0xFF263746),
        foregroundColor: Colors.white,
      ),

      body: SafeArea(
        child: CustomPaint(
          painter: GamePainter(_gameLoop),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
