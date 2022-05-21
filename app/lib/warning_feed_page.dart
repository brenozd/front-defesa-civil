// ignore: file_names
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

// ignore: prefer_const_declarations
final Map<int, Tuple2<String, Color>> warningSeverityMap =
    const <int, Tuple2<String, Color>>{
  0: Tuple2("Low", Color.fromARGB(255, 255, 247, 20)),
  1: Tuple2("Moderate", Color.fromARGB(255, 255, 196, 20)),
  2: Tuple2("High", Color.fromARGB(255, 255, 20, 20)),
};

class Warning extends StatelessWidget {
  const Warning({
    Key? key,
    this.iconData = Icons.abc,
    this.severity = 0,
    this.warningText = "My Warning",
  }) : super(key: key);

  final IconData iconData;
  final int severity;
  final String warningText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFC2CCD6),
          ),
          color: const Color(0xFFC2CCD6),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      height: 100,
      width: double.infinity,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                iconData,
                color: warningSeverityMap[severity]!.item2,
                size: 65,
              ),
            ),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      warningText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      warningSeverityMap[severity]!.item1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}

class WarningFeedPage extends StatelessWidget {
  const WarningFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Padding(
      padding: EdgeInsets.all(20.0),
      child: Warning(
        iconData: Icons.access_time_rounded,
        severity: 0,
        warningText:
            "Acoooordaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      ),
    ));
  }
}
