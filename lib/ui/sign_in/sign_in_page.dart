import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:todo_list_app/providers/providers.dart';
import 'package:todo_list_app/secrets/secrets.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SignInScreen(
      auth: ref.watch(authProvider),
      providerConfigs: const [
        EmailProviderConfiguration(),
        GoogleProviderConfiguration(
          clientId: googleClientID,
        ),
      ],
      footerBuilder: (context, action) {
        return TextButton(
          onPressed: () => FirebaseAuth.instance.signInAnonymously(),
          child: const Text('Skip'),
        );
      },
    );
  }
}
