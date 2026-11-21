
class GameConstants {
  GameConstants._();

  // Configuration de la partie
  static const int maxPlayers = 8;

  // Dimensions de la carte
  static const int mapRows = 13;
  static const int mapColumns = 15;

  // Dimensions graphiques
  static const double tileSize = 48.0;

  // Simulation
  static const double targetUpdateRate = 60.0;
  static const double fixedDeltaTime = 1.0 / targetUpdateRate;

  // Bombes
  static const double bombExplosionDelay = 3.0;
  static const int defaultExplosionRange = 2;

  // Joueurs
  static const double defaultPlayerSpeed = 3.0;
  static const int defaultPlayerHealth = 1;
}
