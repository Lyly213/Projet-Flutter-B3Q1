import '../../models/user.dart';

//Represents the state of the login process (logging in, logged in, logged out, or an error)
abstract class LoginState {
  const LoginState();
}

class LoggingIn extends LoginState {
  const LoggingIn();
}

class LoginError extends LoginState {
  final String error;

  LoginError(this.error);
}

class LoggedIn extends LoginState {
  final AppUser user;

  LoggedIn(this.user);
}

class LoggedOut extends LoginState {
  const LoggedOut();
}
