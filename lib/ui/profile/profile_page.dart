import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:todo_list_app/secrets/secrets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      providerConfigs: const [
        EmailProviderConfiguration(),
        GoogleProviderConfiguration(
          clientId: googleClientID,
        ),
      ],
      actions: [
        SignedOutAction((context) {
          Navigator.pop(context);
        }),
      ],
    );
  }
}