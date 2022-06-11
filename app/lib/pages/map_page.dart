import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(child: Text("Map Page")),
    );
  }
}