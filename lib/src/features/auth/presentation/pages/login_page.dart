import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_error_widget.dart';
import '../widgets/login_initial_widget.dart';
import '../widgets/login_loading_widget.dart';
import '../widgets/login_sign_up_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: const Scaffold(
        body: SafeArea(
          child: _LoginBody(),
        ),
      ),
    );
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return switch (state) {
          AuthInitial() => const LoginInitialWidget(),
          AuthSignUpMode() => const LoginSignUpWidget(),
          AuthLoading() => const LoginLoadingWidget(),
          AuthError(:final message) => LoginErrorWidget(message: message),
        };
      },
    );
  }
}
