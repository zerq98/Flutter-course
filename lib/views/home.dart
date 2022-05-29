import 'package:flutter/material.dart';
import 'package:learning_dart/constants/routes.dart';
import 'package:learning_dart/services/auth/authService.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            var user = AuthService.firebase().currentUser;
            if (user != null) {
              if (!user.isEmailVerified) {
                Future.microtask(() => Navigator.of(context)
                    .pushNamedAndRemoveUntil(verifyRoute, (route) => false));
                return Text('');
              }
              Future.microtask(() => Navigator.of(context)
                  .pushNamedAndRemoveUntil(notesRoute, (route) => false));
              return Text('');
            } else {
              Future.microtask(() => Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false));
              return Text('');
            }
            break;
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
