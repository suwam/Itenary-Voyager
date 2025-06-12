import 'package:flutter/material.dart';

class ActivityItem {
  final String time;
  final String title;
  final String description;

  ActivityItem({
    required this.time,
    required this.title,
    required this.description,
  });
}

List<ActivityItem> parseItinerary(String response) {
  final blocks = response.split('\n\n');
  return blocks.map((block) {
    final time = RegExp(r'Time:\s*(.*)').firstMatch(block)?.group(1) ?? '';
    final title = RegExp(r'Title:\s*(.*)').firstMatch(block)?.group(1) ?? '';
    final desc = RegExp(r'Description:\s*(.*)').firstMatch(block)?.group(1) ?? '';
    return ActivityItem(time: time, title: title, description: desc);
  }).where((item) => item.time.isNotEmpty && item.title.isNotEmpty).toList();
}

class ItinerarySummaryPage extends StatelessWidget {
  final String destination;
  final String cost;
  final String travelDate;
  final String returnDate;
  final String duration;
  final String transport;
  final List<String> preferences;
  final String? description;
  final String? aiResponse;

  const ItinerarySummaryPage({
    super.key,
    required this.destination,
    required this.cost,
    required this.travelDate,
    required this.returnDate,
    required this.duration,
    required this.transport,
    required this.preferences,
    this.description,
    this.aiResponse,
  });

  @override
  Widget build(BuildContext context) {
    final List<ActivityItem> activities =
        aiResponse != null ? parseItinerary(aiResponse!) : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("🗺️ Trip Summary"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _info("📍 Destination", destination),
              _info("💰 Cost (NPR)", cost),
              _info("📅 Travel Date", travelDate),
              _info("📅 Return Date", returnDate),
              _info("⏳ Duration", duration),
              _info("🚗 Transport", transport),
              _info("🎯 Preferences", preferences.join(", ")),
              if (description != null && description!.isNotEmpty)
                _info("📝 Interests", description!),
              const SizedBox(height: 20),
              Text("🧭 Trip Plan", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              if (activities.isNotEmpty)
                ...activities.map((activity) => Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(activity.time,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                )),
                            const SizedBox(height: 6),
                            Text(activity.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                )),
                            const SizedBox(height: 4),
                            Text(activity.description),
                          ],
                        ),
                      ),
                    ))
              else if (aiResponse != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(aiResponse!),
                )
              else
                const Text("❗ No detailed activities found."),
              const SizedBox(height: 24),
              const Divider(),
              const Text(
                "📝 Note: Adjust your trip based on availability, weather, and personal preferences.",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
