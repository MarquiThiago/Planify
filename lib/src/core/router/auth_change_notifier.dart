import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Notifica o GoRouter sempre que o estado de autenticação do Supabase muda,
/// forçando a re-avaliação do redirect.
class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier(SupabaseClient client) {
    _subscription = client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
