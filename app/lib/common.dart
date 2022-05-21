import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  const Separator({Key? key, this.text = "", this.spacing = 20.0})
      : super(key: key);

  final String text;
  final double spacing;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(height: spacing),
      Align(alignment: Alignment.centerLeft, child: Text(text)),
      const Divider(height: 20, thickness: 2, color: Colors.black)
    ]);
  }
}
