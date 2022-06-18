import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shoppinglistclient/localDb/DBClient.dart';
import 'package:shoppinglistclient/net/Item.dart';
import 'package:shoppinglistclient/net/socket.dart';
import 'package:shoppinglistclient/widgets/ItemCard.dart';
import 'package:shoppinglistclient/widgets/ListHeader.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);

  final myMenuItems = <String>[
    'Refresh',
    'Cambiar nombre',
    "Pol, esto no furula"
  ];
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

    double height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
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
                    case 'Cambiar nombre':
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text("Cambia tu nombre"),
                              content: Column(
                                children: [
                                  TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      labelText: "calvo",
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
          body: Column(
            children: [
              Container(
                height: height * 0.1,
                child: ListHeader(),
              ),
              Container(
                height: height * 0.9,
                child: ReorderableListView(
                  onReorder: (old, newIndex) {
                    s.sendIndexChange(items[old], newIndex);
                    ref
                        .read(s.itemsProvider.notifier)
                        .changeIndex(items[old].uuid, newIndex);
                  },
                  children: items
                      .map((e) => ItemCard(
                            item: e,
                            key: Key(e.uuid),
                          ))
                      .toList(),
                ),
              ),
            ],
          )),
    );
  }
}
