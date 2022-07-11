// ignore: file_names
import 'package:app/pages/my_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:app/common.dart';
import 'package:app/services/logger_service.dart';
import 'package:tuple/tuple.dart';

// ignore: prefer_const_declarations

class WarningWidget extends StatelessWidget {
  const WarningWidget({
    Key? key,
    this.iconData = Icons.abc,
    this.severity = 0,
    this.warningText = "My Warning",
  }) : super(key: key);

  WarningWidget.fromWarning(Warning w, {Key? key})
      : iconData = warningTypeMap
            .getOrElse(w.type!, const Tuple2("Unknown", Icons.question_mark))
            .item2,
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
          color: warningSeverityMap
              .getOrElse(severity,
                  const Tuple2('Unknown', Color.fromARGB(255, 161, 20, 255)))
              .item2,
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
              warningSeverityMap
                  .getOrElse(
                      severity,
                      const Tuple2(
                          'Unknown', Color.fromARGB(255, 161, 20, 255)))
                  .item1,
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

class WarningFeedPage extends StatefulWidget {
  const WarningFeedPage({Key? key}) : super(key: key);

  @override
  State<WarningFeedPage> createState() => _WarningFeedPageState();
}

class _WarningFeedPageState extends State<WarningFeedPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Widget> _warnings = <Widget>[];
  late Future<void> _initialWidgetsData;

  var noWarningsWidget = const Expanded(
      child: Center(
          child: SingleChildScrollView(
              child: Text("No warnings for your current region",
                  textAlign: TextAlign.center))));

  Future<List<Widget>> _getWidgets() async {
    List<Widget> ret = <Widget>[];
    List<Warning> warns = <Warning>[];

    API().getWarnings().then((value) => warns = value).whenComplete(() {
      for (Warning warn in warns) {
        try {
          if (warn.severity! >= dropDownItens.indexOf(currentSeverity) &&
              warningItens.getOrElse(warn.type!, false) == true) {
            ret.add(WarningWidget.fromWarning(warn));
          }
        } catch (exception) {
          log.warning("Error while trying to parse widget from warning class " +
              exception.toString());
        }
      }
    });
    await Future.delayed(const Duration(seconds: 1));
    log.info("Updated warning list");

    if (ret.isEmpty) {
      ret.add(noWarningsWidget);
    }

    return ret;
  }

  Future<void> _initWidgets() async {
    final widgets = await _getWidgets();
    _warnings = widgets;
  }

  Future<void> updateWidgets() async {
    final widgets = await _getWidgets();
    _warnings = widgets;
  }

  @override
  void initState() {
    super.initState();
    _initialWidgetsData = _initWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialWidgetsData,
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              {
                return const Center(
                  child: Text('Loading...'),
                );
              }
            case ConnectionState.done:
              {
                return RefreshIndicator(
                    key: _refreshIndicatorKey,
                    displacement: 80,
                    onRefresh: () async {
                      final widgets = await _getWidgets();
                      setState(() {
                        _warnings = widgets;
                      });
                    },
                    child: ListView.separated(
                        shrinkWrap: false,
                        scrollDirection: Axis.vertical,
                        reverse: false,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _warnings.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: _warnings[index],
                          );
                        }));
              }
          }
        });
  }
}
