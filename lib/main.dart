import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shoppinglistclient/localDb/DBClient.dart';
import 'package:shoppinglistclient/net/socket.dart';
import 'package:shoppinglistclient/screens/HomeScreen.dart';

void main() async {
  await DBClient.init();
  ClientSocket().connect();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
