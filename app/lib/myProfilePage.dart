// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool useLocation = false;
  var myCEP = "00000-000";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TextFormField(
              readOnly: useLocation,
              obscureText: false,
              controller: TextEditingController(text: myCEP),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  helperText: 'CEP',
                  enabled: true),
            ),
            Align(
                alignment: Alignment.center,
                child: CheckboxListTile(
                    title: const Text("Use location"),
                    value: useLocation,
                    onChanged: (bool? value) => setState(() {
                          useLocation = value!;
                          // TODO: Get geolocation and display on textbox
                          myCEP = "12345-678";
                        }))),
            Divider(
                height: 20,
                thickness: 2,
                color: Colors.black),
          ],
        ),
      )),
    );
  }
}
