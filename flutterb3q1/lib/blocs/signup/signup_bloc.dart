import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/user_repository.dart';
import 'signup_event.dart';
import 'signup_state.dart';

// block manages user sign up operations
// interacts with UserRepository to manage user data and update user interface
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository userRepository;

  SignUpBloc({required this.userRepository}) : super(SignUpInitial()) {
    on<SignUpRequested>((event, emit) async {
      emit(SigningUp());
      try {
        await userRepository.signUp(
          email: event.email,
          password: event.password,
        );
        emit(SignUpSuccess());
      } catch (e) {
        emit(SignUpError(e.toString()));
      }
    });
  }
}

