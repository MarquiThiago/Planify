import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify/src/features/auth/presentation/auth_dimens.dart';
import 'package:planify/src/features/auth/presentation/auth_strings.dart';
import 'package:planify/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:planify/src/features/auth/presentation/bloc/auth_event.dart';

class OthersSignInWidget extends StatelessWidget {
  const OthersSignInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: AuthDimens.buttonHeight,
          child: OutlinedButton.icon(
            onPressed: () =>
                context.read<AuthBloc>().add(const SignInWithGoogleRequested()),
            icon: const Icon(Icons.g_mobiledata),
            label: const Text(AuthStrings.googleButton),
          ),
        ),
        const SizedBox(height: AuthDimens.spacing),
        SizedBox(
          height: AuthDimens.buttonHeight,
          child: OutlinedButton.icon(
            onPressed: () =>
                context.read<AuthBloc>().add(const SignInWithAppleRequested()),
            icon: const Icon(Icons.apple),
            label: const Text(AuthStrings.appleButton),
          ),
        ),
      ],
    );
  }
}
