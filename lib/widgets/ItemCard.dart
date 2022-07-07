import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shoppinglistclient/net/Item.dart';
import 'package:shoppinglistclient/net/socket.dart';

class ItemCard extends StatelessWidget {
  ItemCard({Key? key, required this.item}) : super(key: key);

  final Item item;

  void _doneEditingName(String newName) {
    if (item.name == newName) return;
    ClientSocket().sendItemChange(item, newName);
    item.name = newName;
  }

  void _openEditScreen(context) {
    var _nameController = TextEditingController(text: item.name);

    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Cambia el nombre"),
            content: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Nombre del producto",
                  ),
                  onSubmitted: (text) {
                    _doneEditingName(text);
                    Navigator.pop(ctx);
                  },
                ),
                TextButton(
                    onPressed: () {
                      _doneEditingName(_nameController.text);
                      Navigator.pop(ctx);
                    },
                    child: Text("Hecho"))
              ],
            ),
          );
        });
  }

  void _onDismiss(context) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(item.uuid),
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        dismissible: DismissiblePane(onDismissed: () => _onDismiss(context)),
        children: [
          SlidableAction(
            onPressed: (_) => _onDismiss(_),
            backgroundColor: Colors.red[700]!,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: "Borrar",
          ),
          SlidableAction(
            onPressed: (_) => "TODO",
            backgroundColor: Colors.grey[850]!,
            foregroundColor: Colors.white,
            icon: Icons.question_mark,
            label: "No había",
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          child: InkWell(
            onTap: () => _openEditScreen(context),
            child: Container(
              padding: EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
              child: ListTile(
                title: Text(item.name),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
