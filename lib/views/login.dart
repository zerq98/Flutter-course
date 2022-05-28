import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learning_dart/constants/routes.dart';
import '../utilities/errorDialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 50),
          child: Column(
            children: [
              TextField(
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Enter your email here'),
                controller: _email,
              ),
              TextField(
                decoration:
                    InputDecoration(hintText: 'Enter your password here'),
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  try {
                    final userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email, password: password);
                    if (userCredential != null) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(homeRoute, (route) => false);
                    }
                  } on FirebaseAuthException catch (e) {
                    String error = '';
                    switch (e.code) {
                      case 'user-not-found':
                        error = 'User not found';
                        break;
                      case 'invalid-email':
                      case 'wrong-password':
                        error = 'Wrong email or password';
                        break;
                      case 'user-disabled':
                        error = 'Account with that address email is disabled';
                        break;
                    }
                    await showErrorDialog(context, error);
                  } catch (e) {
                    await showErrorDialog(context, e.toString());
                  }
                },
                child: Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                child: Text("Not registered yet? Register here!"),
              )
            ],
          ),
        ));
  }
}
