import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'repositories/user_repository.dart';
import 'pages/login_page.dart';
import 'pages/welcome_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/card_repository.dart';
import 'pages/signup_page.dart';

// Main entry point for the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the default options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final userRepository = UserRepository();
  runApp(
    // Provides an instance of CardRepository that will be available to the entire application
    RepositoryProvider(
      create: (context) => CardRepository(),
      child: MyApp(userRepository: userRepository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primaryColor: const Color(0xFF6B8E23),
        scaffoldBackgroundColor: const Color(0xFFFFFCE0),
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 130, 176, 146)),
        useMaterial3: true,
      ),
      initialRoute: userRepository.currentUser != null ? '/home' : '/login',
      // Define the routes for the application
      routes: {
        '/login': (context) => LoginPage(userRepository: userRepository),
        '/home': (context) {
          final userId = userRepository.currentUser?.uid ?? '';
          return MyHomePage(title: 'Home', userId: userId);
        },
        '/signup': (context) => SignUpPage(userRepository: userRepository),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}