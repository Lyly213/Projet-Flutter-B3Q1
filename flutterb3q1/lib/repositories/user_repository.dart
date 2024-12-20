import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<User> signIn({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if(user == null || user.email == null) {
        throw Exception('Login failed: ${userCredential.toString()}');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Incorrect password.');
      } else {
        throw Exception('Login failed: ${e.message}');
      }
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<User> signUp({required String email, required String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((result) => result.user!);
  }

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  Stream<User?> get userChanges {
    return _firebaseAuth.authStateChanges();
  }
}
