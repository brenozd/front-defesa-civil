// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:app/common.dart';
import 'package:tuple/tuple.dart';

final profileKey = GlobalKey<FormState>();
String currentSeverity = "Low";
List<String> dropDownItens = ["Low", "Moderate", "High"];

Map<int, bool> warningItens = warningTypeMap.map((key, value) => MapEntry(key, true));

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);
  
  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool useLocation = true;

  @override
  Widget build(BuildContext context) {
    var warningLevelDropDown = DropdownButtonFormField<String>(
        value: currentSeverity,
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
              currentSeverity = value!;
            }));

    var warningTypes = Column(
      children: warningItens.keys.map((int key) {
        return CheckboxListTile(
          title: Text(warningTypeMap
              .getOrElse(key, Tuple2("Unknown", Icons.question_mark))
              .item1),
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
        key: profileKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
