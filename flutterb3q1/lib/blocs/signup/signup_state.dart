//represent the state of the sign up process (signing up, signed up, or an error)
abstract class SignUpState {
  const SignUpState();
}

class SignUpInitial extends SignUpState {}

class SigningUp extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpError extends SignUpState {
  final String error;

  SignUpError(this.error);
}
