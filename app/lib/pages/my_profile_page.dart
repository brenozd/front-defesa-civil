// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:app/common.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool useLocation = true;

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
    var warningLevelDropDown = DropdownButtonFormField<String>(
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
            }));

    var warningTypes = Column(
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
    );

    return Form(
        key: _formKey,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
              child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Separator(text: "Notifications"),
                warningLevelDropDown,
                SizedBox(height: 15),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Notificate me about")),
                warningTypes
              ],
            ),
          )),
        ));
  }
}
