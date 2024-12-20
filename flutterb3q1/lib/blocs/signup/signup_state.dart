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
