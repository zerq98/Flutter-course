import 'package:flutter/material.dart';
import 'views/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primaryColor: Colors.black, backgroundColor: Colors.black),
    home: const HomeView(),
  ));
}
