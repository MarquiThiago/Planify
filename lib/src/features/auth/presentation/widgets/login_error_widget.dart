import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_dimens.dart';
import '../auth_strings.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import 'login_initial_widget.dart';

class LoginErrorWidget extends StatelessWidget {
  const LoginErrorWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AuthDimens.pagePadding,
            AuthDimens.spacing,
            AuthDimens.pagePadding,
            0,
          ),
          child: Container(
            padding: const EdgeInsets.all(AuthDimens.spacing),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(AuthDimens.fieldRadius),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: AuthDimens.spacingSmall),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context
                      .read<AuthBloc>()
                      .add(const SignInWithEmailRequested(
                        email: '',
                        password: '',
                      )),
                  child: const Text(AuthStrings.tryAgainButton),
                ),
              ],
            ),
          ),
        ),
        const Expanded(child: LoginInitialWidget()),
      ],
    );
  }
}
