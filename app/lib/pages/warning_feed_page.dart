// ignore: file_names
import 'package:flutter/material.dart';
import 'package:app/common.dart';
import 'package:weather_icons/weather_icons.dart';

// ignore: prefer_const_declarations

class WarningWidget extends StatelessWidget {
  const WarningWidget({
    Key? key,
    this.iconData = Icons.abc,
    this.severity = 0,
    this.warningText = "My Warning",
  }) : super(key: key);

  WarningWidget.fromWarning(Warning w, {Key? key})
      : iconData = warningIconMap[w.type]!,
        severity = w.severity!,
        warningText = w.body!,
        super(key: key);

  final IconData iconData;
  final int severity;
  final String warningText;

  @override
  Widget build(BuildContext context) {
    var warningIcon = Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Icon(
          iconData,
          color: warningSeverityMap[severity]!.item2,
          size: 60,
        ),
      ),
    );

    var warningBody = Expanded(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              warningText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
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
    );

    return SingleChildScrollView(
        child: Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFC2CCD6),
          ),
          color: const Color(0xFFC2CCD6),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      height: 120,
      width: double.infinity,
      child: Center(
        child: Row(
          children: [
            warningIcon,
            warningBody,
          ],
        ),
      ),
    ));
  }
}

// We should pass a json containing all warnings
class WarningFeedPage extends StatelessWidget {
  const WarningFeedPage({
    Key? key,
  }) : super(key: key);

  static const List<Widget> feed = <Widget>[
    Separator(
      text: "Today",
      spacing: 0,
    ),
    WarningWidget(
      iconData: WeatherIcons.snowflake_cold,
      severity: 1,
      warningText:
          "Cold wave, expect temperatures between 0 and 5 degrees celsius",
    ),
    WarningWidget(
      iconData: WeatherIcons.rain,
      severity: 2,
      warningText: "Heavy rainfall ahead, expect 40 to 50mm",
    ),
    Separator(
      text: "Tomorrow",
      spacing: 5,
    ),
    WarningWidget(
      iconData: WeatherIcons.snowflake_cold,
      severity: 2,
      warningText:
          "Cold wave, expect temperatures between 0 and 5 degrees celsius",
    ),
    WarningWidget(
      iconData: WeatherIcons.rain,
      severity: 0,
      warningText: "Heavy rainfall ahead, expect 40 to 50mm",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: 1,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) => Container(
            padding: const EdgeInsets.all(12),
            child: ListView(
                shrinkWrap: true,
                children: feed.map((item) => ListTile(title: item)).toList())));
  }
}
