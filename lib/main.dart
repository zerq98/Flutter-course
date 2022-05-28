import 'package:flutter/material.dart';
import 'package:learning_dart/views/login.dart';
import 'package:learning_dart/views/register.dart';
import 'package:learning_dart/views/verifyEmail.dart';
import 'views/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primaryColor: Colors.black, backgroundColor: Colors.black),
    home: const HomeView(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
      '/home/': (context) => const HomeView(),
      '/verify/': (context) => const VerifyEmailView(),
    },
  ));
}
