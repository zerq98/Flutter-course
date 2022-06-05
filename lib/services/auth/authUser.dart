import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthUser {
  final bool isEmailVerified;
  final String email;
  final String? id;
  AuthUser(
      {required this.id, required this.email, required this.isEmailVerified});

  factory AuthUser.fromFirebase(User user) => AuthUser(
      isEmailVerified: user.emailVerified, email: user.email!, id: user.uid);
}
