import 'package:chat/home.dart';
import 'package:chat/login.dart';
import 'package:chat/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: Colors.orange[900]!,
            onPrimary: Colors.white,
            secondary: Colors.pink,
            onSecondary: Colors.amber,
            error: Colors.red[900]!,
            onError: Colors.pink[200]!,
            background: Colors.white,
            onBackground: Colors.grey,
            surface: Colors.white,
            onSurface: Colors.yellow[900]!),
        textTheme: GoogleFonts.righteousTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        'login': (context) => const Login(),
        'register': (context) => const Register(),
        'home': (context) => const Home(),
      },
      home: (FirebaseAuth.instance.currentUser == null ||
              FirebaseAuth.instance.currentUser!.emailVerified == false)
          ? Login()
          : Home(),
    );
  }
}
