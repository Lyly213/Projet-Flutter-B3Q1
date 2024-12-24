import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterb3q1/blocs/login/login_bloc.dart';
import 'package:flutterb3q1/blocs/login/login_event.dart';
import 'package:flutterb3q1/blocs/login/login_state.dart';

// Main widget for the login page
// Listen to the LoginBloc and display the login form
class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoggedIn) {
                SnackBar snackBar = SnackBar(
                  content: Text('Welcome back  ${state.user.email} !'),
                  duration: const Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: Container()),
        BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
          if (state is LoggingIn) {
            return const CircularProgressIndicator();
          }
          return Column(
            children: [
              if (state is LoginError) ...[
                const Text("Status : "),
                Text(state.error),
                LoginForm()
              ] else if (state is LoggedOut) ...[
                LoginForm(),
              ]
            ],
          );
        }),
      ],
    );
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();

    return SizedBox(
      width: 450,
      child: Container(
        decoration: const BoxDecoration(
          border: Border.fromBorderSide(BorderSide(color: Colors.black54)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            const Text('Enter your name and password'),
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              controller: nameController,
              onSubmitted: (value) => _tryLogin(loginBloc),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              controller: passwordController,
              obscureText: true,
              onSubmitted: (value) => _tryLogin(loginBloc),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _tryLogin(loginBloc);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  // Function that adds the login event to the LonginBloc
  void _tryLogin(loginBloc) {
    loginBloc.add(SignInEvent(
        email: nameController.text, password: passwordController.text));
  }
}
