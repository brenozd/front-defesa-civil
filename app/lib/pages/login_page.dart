import 'package:flutter/material.dart';
import 'package:app/pages/page_controller.dart' as pg;

import '../common.dart';
import '../services/logger_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var usernameTextField = Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
          key: _formKey,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'username'),
          controller: _username,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return "Username must not be empty";
            }
            return null;
          }),
    );

    var passwordTextField = Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: 'Password'),
        controller: _password,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "Password must not be empty";
          }
          return null;
        },
      ),
    );

    var loginButton = Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(20)),
        child: ElevatedButton(
          onPressed: () {
            // BUG: Somehow _formKey.currentState is null, so i'm ignoring form validation
            // and just return false
            bool success = false;
            API()
                .login(_username.text, _password.text)
                .then((value) => success = value)
                .whenComplete(() {
              if (success) {
                log.info("Logged in");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const pg.PageController()));
              } else {
                log.info("Invalid username or password");
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Unable to login"),
                        content: const Text("Invalid username or password"),
                        actions: [
                          TextButton(
                            child: const Text("Ok"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
              }
            });
          },
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ));

    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            key: _formKey,
            children: <Widget>[
              usernameTextField,
              passwordTextField,
              loginButton,
            ],
          )),
        ),
      ),
    );
  }
}
