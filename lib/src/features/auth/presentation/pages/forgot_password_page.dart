import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:planify/src/core/di/injection.dart';
import 'package:planify/src/core/router/routes.dart';

import '../auth_dimens.dart';
import '../auth_strings.dart';
import '../bloc/password_recovery/password_recovery_bloc.dart';
import '../bloc/password_recovery/password_recovery_event.dart';
import '../bloc/password_recovery/password_recovery_state.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PasswordRecoveryBloc>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatelessWidget {
  const _ForgotPasswordView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go(Routes.login.path)),
      ),
      body: SafeArea(
        child: BlocConsumer<PasswordRecoveryBloc, PasswordRecoveryState>(
          listener: (context, state) {
            if (state is PasswordResetSuccess) {
              context.go(Routes.login.path);
            }
          },
          builder: (context, state) => switch (state) {
            PasswordRecoveryInitial() => const _EmailStep(),
            PasswordRecoveryLoading() => const _LoadingStep(),
            OtpSentSuccess(:final email) => _OtpStep(email: email),
            OtpVerifiedSuccess() => const _NewPasswordStep(),
            PasswordResetSuccess() => const _LoadingStep(),
            PasswordRecoveryError(:final step, :final email, :final message) =>
              switch (step) {
                RecoveryStep.email => _EmailStep(errorMessage: message),
                RecoveryStep.otp =>
                  _OtpStep(email: email ?? '', errorMessage: message),
                RecoveryStep.newPassword =>
                  _NewPasswordStep(errorMessage: message),
              },
          },
        ),
      ),
    );
  }
}

// ── Loading ──────────────────────────────────────────────────────────────────

class _LoadingStep extends StatelessWidget {
  const _LoadingStep();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

// ── Step 1: Email ─────────────────────────────────────────────────────────────

class _EmailStep extends StatefulWidget {
  const _EmailStep({this.errorMessage});

  final String? errorMessage;

  @override
  State<_EmailStep> createState() => _EmailStepState();
}

class _EmailStepState extends State<_EmailStep> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context
        .read<PasswordRecoveryBloc>()
        .add(SendOtpRequested(_controller.text.trim()));
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
            const SizedBox(height: AuthDimens.spacingLarge),
            Text(
              AuthStrings.forgotPasswordTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AuthDimens.spacingSmall),
            Text(
              AuthStrings.forgotPasswordSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AuthDimens.spacingLarge),
            TextFormField(
              controller: _controller,
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
            if (widget.errorMessage != null) ...[
              const SizedBox(height: AuthDimens.spacingSmall),
              Text(
                widget.errorMessage!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ],
            const SizedBox(height: AuthDimens.spacingLarge),
            SizedBox(
              height: AuthDimens.buttonHeight,
              child: FilledButton(
                onPressed: _submit,
                child: const Text(AuthStrings.sendCodeButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 2: OTP verification ──────────────────────────────────────────────────

class _OtpStep extends StatefulWidget {
  const _OtpStep({required this.email, this.errorMessage});

  final String email;
  final String? errorMessage;

  @override
  State<_OtpStep> createState() => _OtpStepState();
}

class _OtpStepState extends State<_OtpStep> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 6; i++) {
      final index = i;
      _focusNodes[index].onKeyEvent = (_, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            _controllers[index].text.isEmpty &&
            index > 0) {
          _focusNodes[index - 1].requestFocus();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      };
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) { c.dispose(); }
    for (final f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length == 1) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _submit() {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < 6) return;
    context.read<PasswordRecoveryBloc>().add(
          VerifyOtpRequested(email: widget.email, otp: otp),
        );
  }

  void _resend() {
    for (final c in _controllers) { c.clear(); }
    _focusNodes.first.requestFocus();
    context
        .read<PasswordRecoveryBloc>()
        .add(SendOtpRequested(widget.email));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AuthDimens.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AuthDimens.spacingLarge),
          Text(
            AuthStrings.otpTitle,
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AuthDimens.spacingSmall),
          Text.rich(
            TextSpan(
              text: AuthStrings.otpSubtitlePrefix,
              style: theme.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: widget.email,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: AuthDimens.spacingLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              6,
              (i) => _OtpBox(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                onChanged: (v) => _onChanged(i, v),
                autofocus: i == 0,
              ),
            ),
          ),
          if (widget.errorMessage != null) ...[
            const SizedBox(height: AuthDimens.spacingSmall),
            Text(
              widget.errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: AuthDimens.spacingLarge),
          SizedBox(
            height: AuthDimens.buttonHeight,
            child: FilledButton(
              onPressed: _submit,
              child: const Text(AuthStrings.otpVerifyButton),
            ),
          ),
          const SizedBox(height: AuthDimens.spacing),
          TextButton(
            onPressed: _resend,
            child: const Text(AuthStrings.otpResendButton),
          ),
        ],
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: AuthDimens.otpBoxWidth,
      height: AuthDimens.otpBoxHeight,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        maxLength: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthDimens.otpBoxRadius),
            borderSide: BorderSide(color: scheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthDimens.otpBoxRadius),
            borderSide: BorderSide(color: scheme.primary, width: 2),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

// ── Step 3: New password ──────────────────────────────────────────────────────

class _NewPasswordStep extends StatefulWidget {
  const _NewPasswordStep({this.errorMessage});

  final String? errorMessage;

  @override
  State<_NewPasswordStep> createState() => _NewPasswordStepState();
}

class _NewPasswordStepState extends State<_NewPasswordStep> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context
        .read<PasswordRecoveryBloc>()
        .add(SetNewPasswordRequested(_passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AuthDimens.pagePadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AuthDimens.spacingLarge),
            Text(
              AuthStrings.newPasswordTitle,
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AuthDimens.spacingSmall),
            Text(
              AuthStrings.newPasswordSubtitle,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AuthDimens.spacingLarge),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: AuthStrings.newPasswordLabel,
                hintText: AuthStrings.newPasswordHint,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe a nova senha';
                }
                if (value.length < 6) {
                  return 'A senha deve ter pelo menos 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: AuthDimens.spacing),
            TextFormField(
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: AuthStrings.confirmNewPasswordLabel,
                hintText: AuthStrings.newPasswordHint,
              ),
              validator: (value) {
                if (value != _passwordController.text) {
                  return AuthStrings.passwordMismatchError;
                }
                return null;
              },
            ),
            if (widget.errorMessage != null) ...[
              const SizedBox(height: AuthDimens.spacingSmall),
              Text(
                widget.errorMessage!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: AuthDimens.spacingLarge),
            SizedBox(
              height: AuthDimens.buttonHeight,
              child: FilledButton(
                onPressed: _submit,
                child: const Text(AuthStrings.savePasswordButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
