import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesService {
  static const String _apiKey = 'YOUR_GOOGLE_API_KEY';

  static Future<String> getPlaceDetails(String placeName) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent(placeName)}&key=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final place = data['results'][0];
        final name = place['name'] ?? '';
        final address = place['formatted_address'] ?? '';
        final rating = place['rating']?.toString() ?? 'N/A';
        return '📍 $name\n📫 $address\n⭐ Rating: $rating';
      } else {
        return 'No details found.';
      }
    } else {
      return 'Error fetching data. Status: ${response.statusCode}';
    }
  }
}
