import 'package:flutter/material.dart';
import 'package:shoppinglistclient/localDb/DBClient.dart';
import 'package:shoppinglistclient/net/socket.dart';

class PasswordScreen extends StatelessWidget {
  PasswordScreen({Key? key}) : super(key: key);

  bool remember = Settings.isRemember();
  final TextEditingController _passController = TextEditingController(
      text: Settings.isRemember() ? Settings.getRememberedPassword() : "");

  void _login([String? password]) {
    password ??= _passController.text;
    Settings.setRememberedPassword(password);
    ClientSocket().sendAuth(password);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (remember) {
      _login();
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Password",
                style: Theme.of(context).textTheme.headline4,
              ),
              Container(
                width: width * 0.5,
                child: TextField(
                  obscureText: true,
                  controller: _passController,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  onSubmitted: _login,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                      value: remember,
                      onChanged: (newValue) {
                        remember = newValue ?? false;
                        Settings.setRemember(remember);
                      }),
                  Text("Recordar password"),
                ],
              ),
              TextButton(
                child: Text("Login"),
                onPressed: _login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
