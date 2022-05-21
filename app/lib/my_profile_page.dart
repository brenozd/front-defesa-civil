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
  var currentWarningLevel = "Low";
  List<String> dropDownItens = ["Low", "Moderate", "High"];
  Map<String, bool> warningItens = {
    "Rain": true,
    "Flood": true,
    "Lightning Storm": true,
    "Landslide" "Wind storm": true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Column(children: <Widget>[
              SizedBox(height: 20),
              Align(alignment: Alignment.centerLeft, child: Text("Location")),
              Divider(height: 20, thickness: 2, color: Colors.black)
            ]),
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
            Column(children: <Widget>[
              SizedBox(height: 20),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Notifications")),
              Divider(height: 20, thickness: 2, color: Colors.black)
            ]),
            // TODO: Instead of dropdown, maybe checkboxes?
            DropdownButtonFormField<String>(
                value: currentWarningLevel,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Warning Level"),
                icon: const Icon(Icons.arrow_drop_down_rounded),
                items: dropDownItens.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) => setState(() {
                      currentWarningLevel = value!;
                    })),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Notificate me about"),
            ),
            Column(
              children: warningItens.keys.map((String key) {
                return CheckboxListTile(
                  title: Text(key),
                  value: warningItens[key],
                  onChanged: (bool? value) {
                    setState(() {
                      warningItens[key] = value!;
                    });
                  },
                );
              }).toList(),
            )
          ],
        ),
      )),
    );
  }
}
