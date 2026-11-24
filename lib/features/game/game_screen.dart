
import 'package:material_ui/material_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../game_engine/game_loop.dart';
import '../../game_engine/game_state.dart';
import '../../game_engine/rendering/game_painter.dart';
import '../../game_engine/systems/player_input_system.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {

  late final Ticker _ticker;
  late final GameLoop _gameLoop;
  late final PlayerInputSystem _inputSystem;

  final FocusNode _focusNode = FocusNode();

  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();

    _gameLoop = GameLoop(GameState());
    _inputSystem = PlayerInputSystem();

    _focusNode.addListener(_handleFocusChange);

    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    final frameDelta =
        (elapsed - _lastElapsed).inMicroseconds / 1000000.0;

    _lastElapsed = elapsed;

    _gameLoop.advance(frameDelta);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus &&
        _gameLoop.state.players.isNotEmpty) {
      _inputSystem.stop(_gameLoop.state.players.first);
    }
  }

  String? _directionForKey(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.arrowUp ||
        key == LogicalKeyboardKey.keyW) {
      return 'up';
    }

    if (key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.keyS) {
      return 'down';
    }

    if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.keyA) {
      return 'left';
    }

    if (key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.keyD) {
      return 'right';
    }

    return null;
  }

  void _handleKeyEvent(KeyEvent event) {
    if (_gameLoop.state.players.isEmpty) return;

    final player = _gameLoop.state.players.first;
    final direction = _directionForKey(event.logicalKey);

    if (direction == null) return;

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      _inputSystem.press(player, direction);
    } else if (event is KeyUpEvent) {
      _inputSystem.release(player, direction);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _gameLoop.dispose();

    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();

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
        child: KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: _handleKeyEvent,
          child: CustomPaint(
            painter: GamePainter(_gameLoop),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
