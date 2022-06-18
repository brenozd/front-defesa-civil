import 'package:app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:app/common.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  Marker warningToMarker(Warning warn) {
    return Marker(
      width: 130.0,
      height: 130.0,
      point: warn.location!,
      builder: (ctx) => Icon(warningIconMap[warn.type]!,
          color: warningSeverityMap[warn.severity]!.item2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: FlutterMap(
          options: MapOptions(
            center: LocationService().getCurrentCoordinates(),
            zoom: 13.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
              attributionBuilder: (_) {
                return const Text("© OpenStreetMap contributors");
              },
            ),
            MarkerLayerOptions(
              // TODO: generate a mark from a Warning and get those warnings from API
              markers: [
                Marker(
                  width: 130.0,
                  height: 130.0,
                  point: LocationService().getCurrentCoordinates()!,
                  builder: (ctx) =>
                      const Icon(Icons.location_pin, color: Colors.cyan),
                ),
              ],
            ),
          ],
        ));
  }
}
