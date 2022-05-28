import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:learning_dart/constants/routes.dart';
import 'package:learning_dart/views/home.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Column(children: [
            Text('Please verify your email address!'),
            TextButton(
              onPressed: () async {
                var user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: Text('Send email verification'),
            )
          ]),
        ),
      ),
    );
  }
}
