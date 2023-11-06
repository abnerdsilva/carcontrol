import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  final String key = "AIzaSyA6jjk9dudag94IoR8XaQUsbFQsGFhMTV0";

  Future<String> getPlaceId(String input) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key";
    var response = await http.get(Uri.parse(url));

    var json = jsonDecode(response.body);

    var placeId = json["candidates"][0]["place_id"] as String;

    print(placeId);

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key";
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    print(results);
    return results;
  }

  Future<Map<String, dynamic>> getDirections(
      String origin, String destination) async {
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key";
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);

    // Check if the response has any routes
    if (json['routes'].isEmpty) {
      throw Exception('No routes found.');
    }

    var route = json['routes'][0];

    var results = {
      "bounds_ne": route["bounds"]["northeast"],
      "bounds_sw": route["bounds"]["southwest"],
      "start_location": route["legs"][0]["start_location"],
      "end_location": route["legs"][0]["end_location"],
      "polyline": route["overview_polyline"]["points"],
      "polyline_decoded":
          PolylinePoints().decodePolyline(route["overview_polyline"]["points"]),
    };

    return results;
  }
}
