import 'package:flutter/material.dart';

class ListHeader extends StatelessWidget {
  ListHeader({Key? key}) : super(key: key);

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: "New item",
        suffix: TextButton(
          child: Text("Add"),
          onPressed: null,
        ),
        suffixIcon: IconButton(
          onPressed: _controller.clear,
          icon: Icon(Icons.clear),
        ),
      ),
    );
  }
}
