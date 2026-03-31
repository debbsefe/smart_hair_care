import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/features/auth/notifiers/notifiers.dart';
import 'package:smart_hair_care/features/shared/shared.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// Account page handling sign-in via email OTP and sign-out.
class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation.
  static Route<void> getRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => const AuthPage(),
      settings: const RouteSettings(name: '/account'),
    );
  }

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authNotifierProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountTitle)),
      body: authAsync.when(
        data: (status) => switch (status) {
          Unauthenticated() => _SignInView(
            emailController: _emailController,
            formKey: _formKey,
            onSignIn: _handleSignIn,
          ),
          AwaitingOtp(:final email) => _OtpEntryView(
            email: email,
            otpController: _otpController,
            onVerify: () => _handleVerify(email),
            onResend: () => _handleResend(email),
          ),
          Authenticated(:final user) => _AuthenticatedView(
            email: user.email ?? '',
            onSignOut: _handleSignOut,
          ),
          AuthError(:final message) => _ErrorView(
            message: message,
            onRetry: () => ref.invalidate(authNotifierProvider),
          ),
          InvalidEmailAddress() => _ErrorView(
            message: context.l10n.invalidEmail,
            onRetry: () => ref.invalidate(authNotifierProvider),
          ),
        },
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(authNotifierProvider),
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref
          .read(authNotifierProvider.notifier)
          .signIn(_emailController.text);
    }
  }

  Future<void> _handleVerify(String email) async {
    final token = _otpController.text.trim();
    if (token.length == 6) {
      await ref
          .read(authNotifierProvider.notifier)
          .verifyOtp(email: email, token: token);
    }
  }

  Future<void> _handleResend(String email) async {
    _otpController.clear();
    await ref.read(authNotifierProvider.notifier).signIn(email);
  }

  Future<void> _handleSignOut() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.signOutConfirmTitle),
        content: Text(l10n.signOutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(authNotifierProvider.notifier).signOut();
    }
  }
}

class _SignInView extends StatelessWidget {
  const _SignInView({
    required this.emailController,
    required this.formKey,
    required this.onSignIn,
  });

  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mail_outline,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.signIn,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(
                  labelText: l10n.enterEmail,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: emailAddressValidator(l10n),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onSignIn,
                  child: Text(l10n.sendOtpCode),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpEntryView extends StatelessWidget {
  const _OtpEntryView({
    required this.email,
    required this.otpController,
    required this.onVerify,
    required this.onResend,
  });

  final String email;
  final TextEditingController otpController;
  final VoidCallback onVerify;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.enterOtpTitle,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.enterOtpHint(email),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: theme.textTheme.headlineMedium?.copyWith(
                letterSpacing: 8,
              ),
              decoration: InputDecoration(
                labelText: l10n.otpFieldLabel,
                counterText: '',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onVerify,
                child: Text(l10n.verifyCode),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onResend,
              child: Text(l10n.resendCode),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthenticatedView extends StatelessWidget {
  const _AuthenticatedView({
    required this.email,
    required this.onSignOut,
  });

  final String email;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.signedInAs(email),
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: onSignOut,
              child: Text(l10n.signOut),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.authErrorGeneric,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: onRetry,
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
