import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shoppinglistclient/localDb/DBClient.dart';
import 'package:shoppinglistclient/net/Item.dart';
import 'package:shoppinglistclient/net/socket.dart';
import 'package:shoppinglistclient/widgets/ItemCard.dart';
import 'package:shoppinglistclient/widgets/ListHeader.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);

  final myMenuItems = <String>['Refresh', 'Change Name', "Pol, esto no furula"];
  final ClientSocket s = ClientSocket();
  TextEditingController _nameController =
      TextEditingController(text: Settings.getName());

  _doneEditingName() async {
    Settings.setName(_nameController.text);
    await s.sendNameChange(_nameController.text);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(s.itemsProvider);
    print(items);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Shopping List"),
          actions: [
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return myMenuItems.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              onSelected: (item) {
                switch (item) {
                  case 'Refresh':
                    s.sendMessage(MessageType.REQUEST_REFRESH);
                    break;
                  case 'Change Name':
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text("Pol, esto no furula"),
                            content: Column(
                              children: [
                                TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: "New name",
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      _doneEditingName();
                                      Navigator.pop(ctx);
                                    },
                                    child: Text("Ok"))
                              ],
                            ),
                          );
                        });
                    break;
                  case 'Pol, esto no furula':
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text("Pol, esto no furula"),
                            content: Text("Te jodes :D"),
                          );
                        });
                    break;
                }
              },
            )
          ],
        ),
        body: ReorderableListView(
          onReorder: (old, neww) {
            print("Reordered $old to $neww");
          },
          header: ListHeader(),
          children: items
              .map((e) => ItemCard(
                    item: e,
                    key: Key(e.uuid),
                  ))
              .toList(),
        ));
  }
}
