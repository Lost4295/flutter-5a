import 'package:material_ui/material_ui.dart';
import 'features/game/game_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const BombermanApp());
}

class BombermanApp extends StatelessWidget {
  const BombermanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bomberman Multiplayer',

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.orange,
      ),

      home: const GameScreen(),
    );
  }
}
