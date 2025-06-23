import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EOMapScreen extends StatelessWidget {
  const EOMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SentinelHub Satellite View'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(51.509364, -0.128928), // Changed from 'center' to 'initialCenter'
          initialZoom: 5.0, // Changed from 'zoom' to 'initialZoom'
          maxZoom: 18.0,
          minZoom: 1.0,
        ),
        children: [
          TileLayer(
            wmsOptions: WMSTileLayerOptions(
              baseUrl: 'https://services.sentinel-hub.com/ogc/wms/2554c58e-ae0e-4594-9453-26296e359c06?',
              layers: const ['TRUE_COLOR'],
              version: '1.3.0',
              format: 'image/jpeg',
              transparent: false,
              crs: const Epsg3857(), // Changed from string to Crs object
            ),
            userAgentPackageName: 'com.example.aerohealth',
            tileProvider: NetworkTileProvider(),
          ),
          const MarkerLayer(
            markers: [
              // You can add markers here if needed
            ],
          ),
        ],
      ),
    );
  }
}