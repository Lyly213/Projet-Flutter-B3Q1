import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'repositories/user_repository.dart';
import 'pages/login_page.dart';
import 'pages/welcome_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/card_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final userRepository = UserRepository();
  runApp(
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
      routes: {
        '/login': (context) => LoginPage(userRepository: userRepository),
        '/home': (context) => const MyHomePage(title: 'Home'),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}