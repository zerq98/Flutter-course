import 'package:flutter/material.dart';
import 'package:learning_dart/services/auth/authService.dart';
import '../constants/routes.dart';

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
          padding: const EdgeInsets.fromLTRB(50, 100, 50, 0),
          child: Column(children: [
            Text("We've sent you an email verification."),
            Text('Please verify your email address!\r\n'),
            Text(
                "If you haven't received a verification email yet, press the button below."),
            TextButton(
              onPressed: () async {
                var user = await AuthService.firebase().currentUser;
                if (user != null) {
                  await AuthService.firebase().sendEmailVerification();
                }
                await AuthService.firebase().logOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: Text('Send email verification'),
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: Text('Restart'),
            )
          ]),
        ),
      ),
    );
  }
}
