import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shoppinglistclient/localDb/DBClient.dart';
import 'package:shoppinglistclient/net/socket.dart';
import 'package:shoppinglistclient/screens/CacheScreen.dart';
import 'package:shoppinglistclient/screens/HomeScreen.dart';
import 'package:shoppinglistclient/screens/PasswordScreen.dart';
import 'package:shoppinglistclient/widgets/SocketStatusDisplay.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await DBClient.init();
  ClientSocket().connect();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socketStatus = ref.watch(ClientSocket().socketStatusProvider);

    Widget screen = HomeScreen();
    switch (socketStatus) {
      case SocketStatus.CONNECTED:
        screen = PasswordScreen();
        break;
      case SocketStatus.LOGGED:
        screen = HomeScreen();
        break;
      default:
        // screen = LoadingScreen();
        screen = CacheScreen();
        break;
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              child: screen,
            ),
            SocketStatusDisplay(),
          ],
        ),
      ),
    );
  }
}
