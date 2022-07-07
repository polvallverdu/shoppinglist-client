import 'package:flutter/material.dart';
import 'package:shoppinglistclient/net/socket.dart';

class ListHeader extends StatelessWidget {
  ListHeader({Key? key}) : super(key: key);

  TextEditingController _controller = TextEditingController();

  _add() {
    ClientSocket().sendAddItem(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: width * 0.8,
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "New item",
                suffixIcon: IconButton(
                  onPressed: _controller.clear,
                  icon: Icon(Icons.clear),
                ),
              ),
              keyboardType: TextInputType.name,
              onSubmitted: (_) => _add(),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(Icons.save),
              onPressed: _add,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
