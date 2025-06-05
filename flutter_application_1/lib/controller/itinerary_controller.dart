import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/poi.dart';

class ItineraryController extends ChangeNotifier {
  List<POI> filteredPOIs = [];
  DateTime? startDate;
  DateTime? endDate;

  final List<POI> allPOIs = [
    POI(
      name: "Thamel",
      tags: ["shopping", "food"],
      crowded: true,
      cost: 20,
      duration: 90,
      image: "assets/image/thamel.jpg",
      latitude: 27.7149,
      longitude: 85.3131,
    ),
    POI(
      name: "Bouddhanath",
      tags: ["spiritual", "peaceful"],
      crowded: false,
      cost: 5,
      duration: 60,
      image: "assets/image/bouddha.jpg",
      latitude: 27.7215,
      longitude: 85.3620,
    ),
    POI(
      name: "Patan Durbar Square",
      tags: ["historical", "relax"],
      crowded: false,
      cost: 10,
      duration: 75,
      image: "assets/image/patan.webp",
      latitude: 27.6736,
      longitude: 85.3251,
    ),
  ];

  void handleInput(String input) {
    final query = input.toLowerCase();
    filteredPOIs = allPOIs.where((poi) {
      return poi.tags.any((tag) => query.contains(tag));
    }).toList();
    notifyListeners();
  }

  void setDates(DateTime start, DateTime end) {
    startDate = start;
    endDate = end;
    notifyListeners();
  }
}

// 🔮 ChatGPT Integration
class ChatService {
  static const _apiKey = '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'; // ⛔ Replace with your actual key
  static const _url = 'https://api.openai.com/v1/chat/completions';

  static Future<String> askChatGPT(String userInput) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are a helpful travel guide."},
            {"role": "user", "content": "Tell me about $userInput in 100 words."}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['choices'][0]['message']['content'].toString().trim();
      } else {
        return "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Error occurred: $e";
    }
  }
}
