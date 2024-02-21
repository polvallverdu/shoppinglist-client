import 'package:flutter/material.dart';

class SectionTag extends StatelessWidget {
  const SectionTag({Key? key, required this.tagColor, required this.tagName})
      : super(key: key);

  final Color tagColor;
  final String tagName;
  final bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
