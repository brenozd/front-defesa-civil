import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('App Defesa Civil');

class LoggingService {
  static final LoggingService _service = LoggingService._internal();

  factory LoggingService() {
    return _service;
  }

  LoggingService._internal();

  Future<void> init(Level loggingLevel) async {
    Logger.root.level = loggingLevel; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
  }
}
