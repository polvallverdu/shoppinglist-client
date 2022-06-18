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
        final index = ClientSocket().getIndexOfItem(item);
        ClientSocket().sendRemoveItem(item);
        final snackBar = SnackBar(
          content: Text("¿Quieres cancelar la acción?"),
          action: SnackBarAction(
            label: "Cancelar",
            onPressed: () => {ClientSocket().sendAddItem(item.name, index)},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          child: Container(
            padding: EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
            child: ListTile(
              title: Text(item.name),
            ),
          ),
        ),
      ),
    );
  }
}
