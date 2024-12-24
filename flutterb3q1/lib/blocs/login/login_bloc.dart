import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterb3q1/models/user.dart';
import 'package:flutterb3q1/repositories/user_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

// block manages user login and logout operations
// interacts with UserRepository to manage user data and update user interface
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;

  LoginBloc({required this.userRepository}) : super(const LoggedOut()) {
    on<SignInEvent>((event, emit) async {
      try {
        emit(const LoggingIn());
        final firebaseUser = await userRepository.signIn(
            email: event.email, 
            password: event.password);
        final appUser = AppUser(email: firebaseUser.email!);
        emit(LoggedIn(appUser));
      } catch (e) {
        emit(LoginError(e.toString()));
      }
    });

    on<SignOutEvent>((event, emit) async {
      emit(const LoggingIn());
      await userRepository.signOut();
      emit(const LoggedOut());
    });
  }
}
