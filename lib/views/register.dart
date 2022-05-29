import 'package:flutter/material.dart';
import 'package:learning_dart/constants/routes.dart';
import 'package:learning_dart/services/auth/authService.dart';
import '../utilities/errorDialog.dart';
import 'package:learning_dart/services/auth/authExceptions.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
          title: Text('Register'),
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
                    final userCredential = await AuthService.firebase()
                        .createUser(email: email, password: password);
                    Navigator.of(context).pushNamed(verifyRoute);
                  } on InvalidEmailAuthException catch (e) {
                    await showErrorDialog(
                        context, 'Please provide a valid email.');
                  } on EmailAlreadyInUseAuthException catch (e) {
                    await showErrorDialog(
                        context, 'That email is already in use.');
                  } on WeakPasswordAuthException catch (e) {
                    await showErrorDialog(
                        context, 'Pleas provide stronger password');
                  } catch (e) {
                    await showErrorDialog(context, 'Registration error');
                  }
                },
                child: Text("Register"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  },
                  child: Text('Already have an account? Log in here!'))
            ],
          ),
        ));
  }
}
