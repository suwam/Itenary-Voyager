import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItinerarySummaryPage extends StatefulWidget {
  const ItinerarySummaryPage({super.key});

  @override
  State<ItinerarySummaryPage> createState() => _ItinerarySummaryPageState();
}

class _ItinerarySummaryPageState extends State<ItinerarySummaryPage> {
  String itinerary = '';
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    generateItinerary(args);
  }

  Future<void> generateItinerary(Map data) async {
    final prompt = '''
Generate a detailed travel itinerary from ${data['from']} to ${data['to']} 
for the dates ${data['travelDate']} to ${data['returnDate']} 
with an estimated cost of NPR ${data['cost']}. 
Give a day-by-day plan, split into Morning, Afternoon, and Evening.
''';

    const apiKey = 'YOUR_OPENAI_KEY_HERE'; // Replace this

    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/completions"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "text-davinci-003",
        "prompt": prompt,
        "temperature": 0.7,
        "max_tokens": 800,
      }),
    );

    final decoded = json.decode(response.body);
    setState(() {
      itinerary = decoded['choices'][0]['text'].trim();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Planned Itinerary"),
        backgroundColor: Colors.teal,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  itinerary,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              ),
            ),
    );
  }
}
