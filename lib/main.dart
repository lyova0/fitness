import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/SignUp.dart';
import 'pages/signIn.dart';
import 'pages/home.dart';
import 'pages/workouts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrangeAccent,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Signup(),
        '/signin': (context) => const SignIn(),
        '/home': (context) => const Home(),
        // '/workouts': (context) => const Workouts(level: 'Light'), // лучше через MaterialPageRoute
      },
    );
  }
}
