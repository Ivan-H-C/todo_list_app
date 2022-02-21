import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list_app/providers/providers.dart';
import 'package:todo_list_app/ui/home.dart';
import 'package:todo_list_app/ui/sign_in/sign_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xff51abcb),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(selectedItemColor: Color(0xff51abcb)),
        scaffoldBackgroundColor: const Color(0xffF1F9F9),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Color(0xff51abcb)),
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      home: StreamBuilder(
        stream: ref.watch(authStateChangesProvider.stream),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          }
          return const SignInPage();
        },
      ),
    );
  }
}
