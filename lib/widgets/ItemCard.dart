import 'package:flutter/material.dart';
import 'package:shoppinglistclient/net/Item.dart';
import 'package:shoppinglistclient/net/socket.dart';

class ItemCard extends StatelessWidget {
  ItemCard({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.uuid),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red[700],
        child: Icon(Icons.delete,
            color: Colors.white), // TODO: Put icon to the right, I'm lazy lol
      ),
      onDismissed: (direction) {
        ClientSocket().sendRemoveItem(item);
      },
      confirmDismiss: (_) async {
        bool cancelled = false;

        final sb = SnackBar(
          content: Text("¿Quieres cancelar la acción?"),
          action: SnackBarAction(
            label: "Cancelar",
            onPressed: () => (cancelled = true),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(sb);

        await Future.delayed(const Duration(seconds: 3));

        return !cancelled;
      },
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(item.name),
              subtitle: Text(item.addedBy),
            ),
          ],
        ),
      ),
    );
  }
}
