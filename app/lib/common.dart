import 'dart:convert';
import 'dart:ffi';

import 'package:app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:tuple/tuple.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:app/services/logger_service.dart';

extension DefaultMap<K, V> on Map<K, V> {
  V getOrElse(K key, V defaultValue) {
    if (containsKey(key)) {
      return this[key]!;
    } else {
      return defaultValue;
    }
  }
}

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

class API {
  final String apiServer = "http://bzd.duckdns.org:5000/";
  String username = "brenozd";
  String region = "Itajuba";
  LatLng regionOffset = LatLng(0.15, 0.15);

  Future<List<Warning>> getWarnings() async {
    List<Warning> warns = <Warning>[];
    Response resp = await post(
      Uri.parse(apiServer + 'api/aviso/list'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, double?>{
        "lat_min": (LocationService().getCurrentCoordinates()!.latitude -
                regionOffset.latitude),
        "lat_max": (LocationService().getCurrentCoordinates()!.latitude +
                regionOffset.latitude),
        "lon_min": (LocationService().getCurrentCoordinates()!.longitude -
                regionOffset.longitude),
        "lon_max": (LocationService().getCurrentCoordinates()!.longitude +
                regionOffset.longitude),
      }),
    );
    if (resp.statusCode == 200) {
      var respJson = jsonDecode(resp.body)['resultado'];
      if (respJson.length <= 0) {
        return warns;
      }
      for (Map<String, dynamic> obj in respJson) {
        warns.add(Warning.fromJson(obj));
      }
    }
    return warns;
  }

  Future<bool> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return false;
    }
    Response resp = await post(
      Uri.parse(apiServer + 'api/usuario/auth'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"login": username, "senha": password}),
    );

    if (resp.statusCode == 200) {
      this.username = username;
      return true;
    }
    log.info(
        "Unable to login, response code was " + resp.statusCode.toString());
    return false;
  }
}

class Warning {
  int? severity;
  int? type;
  int? feedbacks;
  String? title;
  String? body;
  LatLng? location;
  Float? radius;
  Warning();
  Warning.fromJson(Map<String, dynamic> parsedJson) {
    severity = parsedJson['risco'];
    type = parsedJson['tipo'];
    feedbacks = parsedJson['nFeedBacks'];
    body = parsedJson['descricao'];
    title = 'Generic';
  }
}

const Map<int, Tuple2<String, Color>> warningSeverityMap =
    <int, Tuple2<String, Color>>{
  0: Tuple2("Low", Color.fromARGB(255, 230, 224, 66)),
  1: Tuple2("Moderate", Color.fromARGB(255, 255, 196, 20)),
  2: Tuple2("High", Color.fromARGB(255, 255, 20, 20)),
};

const Map<int, Tuple2<String, IconData>> warningTypeMap =
    <int, Tuple2<String, IconData>>{
  0: Tuple2("Rain", WeatherIcons.rain),
  1: Tuple2("Snow", WeatherIcons.snowflake_cold),
  2: Tuple2("Flood", WeatherIcons.flood),
  3: Tuple2("Lightning Storm", WeatherIcons.lightning),
  4: Tuple2("Landslide", WeatherIcons.strong_wind)
};
