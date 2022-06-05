import 'package:learning_dart/services/auth/authExceptions.dart';
import 'package:learning_dart/services/auth/authProvider.dart';
import 'package:learning_dart/services/auth/authUser.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', (() {
      expect(provider.isInitialized, false);
    }));

    test('Cannot log out if not initialized', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null', (() {
      expect(provider.currentUser, null);
    }));

    test('Should be able to initialize in less than 2 seconds', (() async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }), timeout: const Timeout(Duration(seconds: 2)));

    test('Create user should delegate to logIn function', () async {
      await provider.initialize();
      expect(provider.createUser(email: 'foo@bar.com', password: 'anypass'),
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      expect(provider.createUser(email: 'any@bar.com', password: 'foobar'),
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(email: 'foo', password: 'bar');
      expect(provider.currentUser, user);
    });

    test('Logged in user should be able to get verified', (() async {
      await provider.initialize();
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user?.isEmailVerified, true);
    }));

    test('Should be able to log out and log in again', () async {
      await provider.initialize();
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitialized) {
      throw NotInitializedException();
    }

    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn(
      {required String email, required String password}) async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    var user = AuthUser(email: email, isEmailVerified: false, id: 'my_id');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    if (_user == null) UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    final user = _user;
    if (_user == null) UserNotFoundAuthException();
    var newUser =
        AuthUser(email: 'foobar@gmail.com', isEmailVerified: true, id: 'my_id');
    _user = newUser;
    await Future.delayed(const Duration(seconds: 1));
  }
}
