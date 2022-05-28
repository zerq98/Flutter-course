import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learning_dart/views/login.dart';
import 'package:learning_dart/views/verifyEmail.dart';
import '../firebase_options.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                var user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  if (!user.emailVerified) {
                    Future.microtask(() => Navigator.of(context)
                        .pushNamedAndRemoveUntil('/verify/', (route) => false));
                    return Text('');
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text('Home page'),
                          TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Future.microtask(() => Navigator.of(context)
                                    .pushNamedAndRemoveUntil(
                                        '/login/', (route) => false));
                              },
                              child: Text('Sign out'))
                        ],
                      ),
                    ),
                  );
                } else {
                  Future.microtask(() => Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login/', (route) => false));
                  return Text('');
                }
                break;
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
