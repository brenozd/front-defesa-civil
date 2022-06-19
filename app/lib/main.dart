import 'package:app/pages/login_page.dart';
import 'package:app/services/location_service.dart';
import 'package:app/services/logger_service.dart';
import 'package:app/services/notification_service.dart';
import 'package:app/services/mqtt_service.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LoggingService().init(Level.INFO);
  await LocationService().init();
  await NotificationService().init();
  await MQTTClient().init();
  MQTTClient().listen();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}
