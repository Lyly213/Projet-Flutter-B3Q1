import '../models/user.dart';

class UserRepository {
  Future<User> signIn({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (password == 'password') {
      return User(email: email);
    }
    throw Exception('Login failed');
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
