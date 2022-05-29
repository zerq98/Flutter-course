import 'package:flutter/material.dart';
import 'package:learning_dart/constants/routes.dart';
import 'package:learning_dart/services/auth/authExceptions.dart';
import 'package:learning_dart/services/auth/authService.dart';
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
                    await AuthService.firebase()
                        .logIn(email: email, password: password);
                    final user = await AuthService.firebase().currentUser;
                    if (user != null) {
                      if (user.isEmailVerified) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            homeRoute, (route) => false);
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            verifyRoute, (route) => false);
                      }
                    }
                  } on WrongPasswordAuthException catch (e) {
                    await showErrorDialog(
                        context, 'Wrong username or password');
                  } on UserNotFoundAuthException catch (e) {
                    await showErrorDialog(
                        context, 'User with that login not found');
                  } catch (e) {
                    await showErrorDialog(context, 'Authentication error');
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
