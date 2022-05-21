import 'package:app/map_page.dart';
import 'package:app/my_profile_page.dart';
import 'package:app/warning_feed_page.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentIndex = 1;
  var counter = 0;
  final List<Widget> screens = [
    const MapPage(),
    const WarningFeedPage(),
    const MyProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(children: screens, index: currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.map_rounded), label: "Map"),
            BottomNavigationBarItem(
                icon: Icon(Icons.warning_rounded), label: "Warning Feed"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "My Profile"),
          ],
          onTap: (value) => setState(() {
            currentIndex = value;
          }),
        ));
  }
}
