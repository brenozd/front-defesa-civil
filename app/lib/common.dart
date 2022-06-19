import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:tuple/tuple.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:app/services/logger_service.dart';

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
  // TODO: username should be passed when login
  final String username = "brenozd";
  String region = "Itajuba";

  Future<String?> getWarnings() async {
    Response resp = await post(
      Uri.parse(apiServer + 'api/aviso/list'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    if (resp.statusCode == 200) {
      return resp.body;
    }
    return null;
  }

  Future<bool> login(String username, String password) async {
    log.info(username + " | " + password);
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
    log.info(resp.statusCode);
    if (resp.statusCode == 200) {
      return true;
    }
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
}

const Map<int, Tuple2<String, Color>> warningSeverityMap =
    <int, Tuple2<String, Color>>{
  0: Tuple2("Low", Color.fromARGB(255, 230, 224, 66)),
  1: Tuple2("Moderate", Color.fromARGB(255, 255, 196, 20)),
  2: Tuple2("High", Color.fromARGB(255, 255, 20, 20)),
};

const Map<int, IconData> warningIconMap = <int, IconData>{
  0: WeatherIcons.snowflake_cold,
  1: WeatherIcons.rain
};
