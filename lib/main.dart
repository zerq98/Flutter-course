import 'package:flutter/material.dart';
import 'package:learning_dart/constants/routes.dart';
import 'package:learning_dart/views/login.dart';
import 'package:learning_dart/views/notes/upsertNote.dart';
import 'package:learning_dart/views/notes/notes.dart';
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
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      homeRoute: (context) => const HomeView(),
      verifyRoute: (context) => const VerifyEmailView(),
      notesRoute: (context) => const NotesView(),
      upsertNoteRoute: (context) => const UpsertNoteView(),
    },
  ));
}
