import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shoppinglistclient/localDb/DBClient.dart';
import 'package:shoppinglistclient/net/socket.dart';

class PasswordScreen extends HookWidget {
  PasswordScreen({Key? key}) : super(key: key);

  final TextEditingController _passController = TextEditingController(
      text: Settings.isRemember() ? Settings.getRememberedPassword() : "");

  void _login(bool remember, [String? password]) {
    password ??= _passController.text;
    Settings.setRemember(remember);
    Settings.setRememberedPassword(password);
    ClientSocket().sendAuth(password);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var remember = useState(Settings.isRemember());
    if (remember.value) {
      _login(true);
    }

    return Scaffold(
      body: Container(
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
                onSubmitted: (_) => _login(remember.value),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                    value: remember.value,
                    onChanged: (newValue) {
                      final val = newValue ?? false;
                      remember.value = val;
                    }),
                Text("Recordar password"),
              ],
            ),
            TextButton(
              child: Text("Login"),
              onPressed: () => _login(remember.value),
            ),
          ],
        ),
      ),
    );
  }
}
