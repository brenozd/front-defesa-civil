import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
  final String apiServer = "http://bzd.duckdns.org/";
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
}

class Warning {
  int? severity;
  String? title;
  String? body;
  String? payload;
}
