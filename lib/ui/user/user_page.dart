import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:todo_list_app/providers/providers.dart';
import 'package:todo_list_app/ui/profile/profile_page.dart';

class UserPage extends ConsumerWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          StreamBuilder(
            stream: auth.userChanges(),
            builder: (context, AsyncSnapshot<User?> snapshot) {
              return Row(
                children: [
                  UserAvatar(
                    auth: auth,
                    size: 80,
                  ),
                  Expanded(
                    child: Text(
                      snapshot.data?.displayName ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    ),
                    icon: const Icon(Icons.settings),
                  ),
                ],
              );
            },
          ),
          //TODO: add more information
        ],
      ),
    );
  }
}
