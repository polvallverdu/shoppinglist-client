import 'package:flutter/material.dart';

class SectionSelectorList extends StatelessWidget {
  const SectionSelectorList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: <Widget>[
            Text('hi'),
            Text('hi'),
            Text('hi'),
          ])),
    );
  }
}
