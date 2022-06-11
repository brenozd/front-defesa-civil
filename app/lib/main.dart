import 'package:app/pages/map_page.dart';
import 'package:app/pages/my_profile_page.dart';
import 'package:app/pages/warning_feed_page.dart';
import 'package:app/services/location_service.dart';
import 'package:app/services/notification_service.dart';

import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  // await NotificationService()
  //     .show("Notificação teste", "Notificação Body", "Notificação Payload");
  await LocationService().init();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PageController(),
    );
  }
}

class PageController extends StatefulWidget {
  const PageController({Key? key}) : super(key: key);

  @override
  State<PageController> createState() => _PageControllerState();
}

class _PageControllerState extends State<PageController> {
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
        resizeToAvoidBottomInset: false,
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
