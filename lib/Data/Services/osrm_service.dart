import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OSRMService {
  final String _baseUrl = 'http://router.project-osrm.org/route/v1/driving';

  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final String url = '$_baseUrl/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['routes'] == null || (data['routes'] as List).isEmpty) {
          return [];
        }

        final geometry = data['routes'][0]['geometry'];
        final coordinates = geometry['coordinates'] as List;

        return coordinates.map((coord) {
           
          return LatLng(coord[1].toDouble(), coord[0].toDouble());
        }).toList();
      } else {
        print('OSRM Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('OSRM Connection Error: $e');
      return [];
    }
  }
}
