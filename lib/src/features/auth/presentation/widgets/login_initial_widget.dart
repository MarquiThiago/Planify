import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:planify/src/core/router/routes.dart';

import '../auth_dimens.dart';
import '../auth_strings.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class LoginInitialWidget extends StatefulWidget {
  const LoginInitialWidget({super.key});

  @override
  State<LoginInitialWidget> createState() => _LoginInitialWidgetState();
}

class _LoginInitialWidgetState extends State<LoginInitialWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitEmail() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthBloc>().add(
      SignInWithEmailRequested(
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
              AuthStrings.pageTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AuthDimens.spacingSmall),
            Text(
              AuthStrings.pageSubtitle,
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
            const SizedBox(height: AuthDimens.spacingSmall),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.push(Routes.forgotPassword.path),
                child: const Text(AuthStrings.forgotPasswordLink),
              ),
            ),
            const SizedBox(height: AuthDimens.spacing),
            SizedBox(
              height: AuthDimens.buttonHeight,
              child: FilledButton(
                onPressed: _submitEmail,
                child: const Text(AuthStrings.signInButton),
              ),
            ),
            const SizedBox(height: AuthDimens.spacing),
            TextButton(
              onPressed: () =>
                  context.read<AuthBloc>().add(const SignUpModeEntered()),
              child: const Text(AuthStrings.createAccountButton),
            ),
            const SizedBox(height: AuthDimens.spacingLarge),
            _OrDivider(),
            const SizedBox(height: AuthDimens.spacingLarge),
            SizedBox(
              height: AuthDimens.buttonHeight,
              child: OutlinedButton.icon(
                onPressed: () => context.read<AuthBloc>().add(
                  const SignInWithGoogleRequested(),
                ),
                icon: const Icon(Icons.g_mobiledata),
                label: const Text(AuthStrings.googleButton),
              ),
            ),
            const SizedBox(height: AuthDimens.spacing),
            SizedBox(
              height: AuthDimens.buttonHeight,
              child: OutlinedButton.icon(
                onPressed: () => context.read<AuthBloc>().add(
                  const SignInWithAppleRequested(),
                ),
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
