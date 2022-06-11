// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:app/common.dart';
import 'package:app/services/location_service.dart';
import 'package:location/location.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool useLocation = true;
  var myPostalCode = "00000-000";

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
    if (useLocation) {
      myPostalCode = LocationService().getPostalCode();
    }
    return Form(
        key: _formKey,
        child: Scaffold(resizeToAvoidBottomInset: false,
          body: Center(
              child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Separator(text: "Location"),
                TextFormField(
                  readOnly: useLocation,
                  obscureText: false,
                  controller: TextEditingController(text: myPostalCode),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      helperText: 'Postal Code',
                      enabled: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Postal Code cannot be empty";
                    }
                    RegExp validatePostalCode =
                        RegExp(LocationService().getPostalCodeRegExp());
                    // limita a avisos somente da pais da localização atual
                    if (validatePostalCode.hasMatch(value) == false) {
                      return "Invalid postal code format for your location";
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    _formKey.currentState!.validate();
                  },
                ),
                Align(
                    alignment: Alignment.center,
                    child: CheckboxListTile(
                        title: const Text("Use location"),
                        value: useLocation,
                        onChanged: (bool? value) => setState(() {
                              useLocation = value!;
                              myPostalCode = LocationService().getPostalCode();
                            }))),
                Separator(text: "Notifications"),
                // TODO: Instead of dropdown, maybe checkboxes?
                DropdownButtonFormField<String>(
                    value: currentWarningLevel,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Warning Level"),
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
        ));
  }
}
