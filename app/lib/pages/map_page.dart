import 'package:app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: FlutterMap(
          options: MapOptions(
            center: LocationService().getCurrentLocation(),
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
              markers: [
                Marker(
                  width: 130.0,
                  height: 130.0,
                  point: LocationService().getCurrentLocation()!,
                  builder: (ctx) =>
                      const Icon(Icons.location_pin, color: Colors.cyan),
                ),
              ],
            ),
          ],
        ));
  }
}
