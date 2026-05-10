/// Controla o estado de inicialização do app em memória.
///
/// Variáveis estáticas sobrevivem ao Hot Reload (a Dart VM não reinicia),
/// mas são resetadas no Hot Restart e no cold start — exatamente o
/// comportamento desejado para a splash screen.
class AppStartup {
  AppStartup._();

  static bool _splashCompleted = false;

  static bool get splashCompleted => _splashCompleted;

  static void markSplashCompleted() => _splashCompleted = true;
}
