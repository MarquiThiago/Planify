import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_dimens.dart';
import '../auth_strings.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class LoginSignUpWidget extends StatefulWidget {
  const LoginSignUpWidget({super.key});

  @override
  State<LoginSignUpWidget> createState() => _LoginSignUpWidgetState();
}

class _LoginSignUpWidgetState extends State<LoginSignUpWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthBloc>().add(
          SignUpWithEmailRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AuthDimens.pagePadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AuthDimens.spacingXLarge),
            Text(
              AuthStrings.signUpPageTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AuthDimens.spacingSmall),
            Text(
              AuthStrings.signUpPageSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AuthDimens.spacingLarge),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: AuthStrings.emailLabel,
                hintText: AuthStrings.emailHint,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe seu e-mail';
                }
                return null;
              },
            ),
            const SizedBox(height: AuthDimens.spacing),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: AuthStrings.passwordLabel,
                hintText: AuthStrings.passwordHint,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe sua senha';
                }
                return null;
              },
            ),
            const SizedBox(height: AuthDimens.spacing),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: AuthStrings.confirmPasswordLabel,
                hintText: AuthStrings.confirmPasswordHint,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirme sua senha';
                }
                if (value != _passwordController.text) {
                  return AuthStrings.passwordMismatchError;
                }
                return null;
              },
            ),
            const SizedBox(height: AuthDimens.spacingLarge),
            SizedBox(
              height: AuthDimens.buttonHeight,
              child: FilledButton(
                onPressed: _submit,
                child: const Text(AuthStrings.createAccountButton),
              ),
            ),
            const SizedBox(height: AuthDimens.spacing),
            SizedBox(
              height: AuthDimens.buttonHeight,
              child: TextButton(
                onPressed: () => context
                    .read<AuthBloc>()
                    .add(const SignUpModeCancelled()),
                child: const Text(AuthStrings.backToLoginButton),
              ),
            ),
            const SizedBox(height: AuthDimens.spacingLarge),
            _OrDivider(),
            const SizedBox(height: AuthDimens.spacingLarge),
            SizedBox(
              height: AuthDimens.buttonHeight,
              child: OutlinedButton.icon(
                onPressed: () => context
                    .read<AuthBloc>()
                    .add(const SignInWithGoogleRequested()),
                icon: const Icon(Icons.g_mobiledata),
                label: const Text(AuthStrings.googleButton),
              ),
            ),
            const SizedBox(height: AuthDimens.spacing),
            SizedBox(
              height: AuthDimens.buttonHeight,
              child: OutlinedButton.icon(
                onPressed: () => context
                    .read<AuthBloc>()
                    .add(const SignInWithAppleRequested()),
                icon: const Icon(Icons.apple),
                label: const Text(AuthStrings.appleButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AuthDimens.dividerSpacing,
          ),
          child: Text(
            AuthStrings.orDivider,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
