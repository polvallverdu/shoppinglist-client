import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shoppinglistclient/consts.dart';
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

  bool _isNotFound() {
    if (item.notFound == null) {
      return false;
    } else {
      return DateTime.now().difference(item.notFound!).inHours < 24;
    }
  }

  void _onNotFound() {
    ClientSocket().sendItemNotFound(item, !_isNotFound());
  }

  @override
  Widget build(BuildContext context) {
    final bool notFound;

    // item.notFound is a DateTime. If it's null, notFound is false. if it's been 24 hours since the item was marked as not found, notFound is false. Otherwise, notFound is true.
    if (item.notFound == null) {
      notFound = false;
    } else {
      notFound = DateTime.now().difference(item.notFound!).inHours < 24;
    }

    return Slidable(
      key: Key(item.uuid),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(onDismissed: () => _onDismiss(context)),
        extentRatio: 0.001,
        openThreshold: 0.1,
        children: [
          SlidableAction(
            onPressed: (_) => _onDismiss(_),
            backgroundColor: Colors.red[700]!,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          )
        ],
      ),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        dragDismissible: false,
        children: [
          SlidableAction(
            onPressed: (_) => _onDismiss(_),
            backgroundColor: Colors.red[700]!,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
          SlidableAction(
            onPressed: (_) => _onNotFound(),
            backgroundColor: ConstColors.notfound,
            foregroundColor: Colors.white,
            icon: Icons.question_mark,
          ),
          SlidableAction(
            onPressed: (_) => _openEditScreen(_),
            backgroundColor: Colors.blue[900]!,
            foregroundColor: Colors.white,
            icon: Icons.edit,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          color: notFound ? ConstColors.notfound : Colors.white,
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
