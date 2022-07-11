import 'package:app/services/logger_service.dart';
import 'package:app/services/notification_service.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:app/common.dart';
import 'dart:convert';

class MQTTClient {
  static final MQTTClient _service = MQTTClient._internal();
  static const String mqttBroker = "bzd.duckdns.org";

  MqttServerClient? client;

  factory MQTTClient() {
    return _service;
  }

  MQTTClient._internal();

  Future<void> init() async {
    client = MqttServerClient(mqttBroker, API().username);
    client!.logging(on: false);
    client!.onSubscribeFail = _onSubscribeFail;
    client!.onConnected = _onConnected;
    client!.onDisconnected = _onDisconnected;
    client!.onSubscribed = _onSubscribed;

    final connMessage = MqttConnectMessage().startClean();
    client!.connectionMessage = connMessage;
    try {
      await client!.connect();
    } catch (e) {
      client!.disconnect();
    }

    if (client!.subscribe(API().region.toLowerCase(), MqttQos.exactlyOnce) ==
        null) {
      log.severe("Failed to subscribe to topic ${API().region.toLowerCase()}");
      client!.disconnect();
    }
  }

  Future<void> listen() async {
    client!.updates!.listen(_onData);
  }

  Warning? mqttMessageToWarning(MqttReceivedMessage<MqttMessage> c) {
    Warning n = Warning();
    final MqttPublishMessage recMsg = c.payload as MqttPublishMessage;
    String payload = utf8.decode(recMsg.payload.message);

    try {
      final parsedMessage = jsonDecode(payload);
      List<String> requiredFields = [
        'risco',
        'descricao',
        'tipo',
      ];
      for (String field in requiredFields) {
        if (!parsedMessage.containsKey(field)) {
          log.warning('Recevied MQTT message doesn\'t have field [$field]');
          return null;
        }
      }

      n.severity = parsedMessage['risco'];
      n.body = parsedMessage['descricao'];
      n.type = parsedMessage['tipo'];
      n.title = 'Novo aviso em sua região';

      log.info(n.body);
    } on Exception catch (exception) {
      log.severe(
          "Unknown exception while parsing json: " + exception.toString());
    } catch (error) {
      log.severe("Unknown error while parsing json: " + error.toString());
    }

    return n;
  }

  void _onData(List<MqttReceivedMessage<MqttMessage>> c) {
    for (MqttReceivedMessage<MqttMessage> msg in c) {
      Warning? n = mqttMessageToWarning(msg);
      if (n != null) {
        NotificationService().show(n);
      }
    }
  }

  void _onSubscribeFail(String topic) {
    log.severe('Failed to subscribe $topic');
  }

  void _onSubscribed(String topic) {
    log.fine('Subscribed topic: $topic');
  }

  void _onConnected() {
    log.fine('Connected to $mqttBroker');
  }

  void _onDisconnected() {
    log.fine('Disconnected to $mqttBroker');
  }
}
