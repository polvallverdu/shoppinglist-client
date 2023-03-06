import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shoppinglistclient/localDb/DBClient.dart';
import 'package:shoppinglistclient/net/Item.dart';
import 'package:shoppinglistclient/net/socket.dart';
import 'package:shoppinglistclient/widgets/ItemCard.dart';
import 'package:shoppinglistclient/widgets/ListHeader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:clipboard/clipboard.dart';

class CacheScreen extends ConsumerWidget {
  const CacheScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    List<Item> items =
        Cache.getCachedItems().map((e) => Item.fromJson(e)).toList();

    List<Widget> children = items
        .map((e) => ItemCard(
              item: e,
              key: Key(e.uuid),
            ))
        .toList();

    print(items);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Offline Shopping List"),
        ),
        body: Column(
          children: [
            Container(
              height: height,
              child: ListView(
                children: children,
              ),
            ),
          ],
        ));
  }
}
