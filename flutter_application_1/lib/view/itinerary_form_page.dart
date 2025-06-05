import 'package:flutter/material.dart';

class ItinerarySummaryPage extends StatelessWidget {
  final String from;
  final String to;
  final String cost;
  final String travelDate;
  final String returnDate;

  const ItinerarySummaryPage({
    super.key,
    required this.from,
    required this.to,
    required this.cost,
    required this.travelDate,
    required this.returnDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Planned Itinerary"),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "⚠️ This is a tentative itinerary, so please be flexible.",
              style: TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),

            _infoRow("From", from),
            _infoRow("To", to),
            _infoRow("Estimated Cost (NPR)", cost),
            _infoRow("Travel Date", travelDate),
            _infoRow("Return Date", returnDate),

            const SizedBox(height: 30),
            const Text("🗓 Day-wise Plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _dayPlan(
              day: "Day 1",
              items: [
                "Arrival in $from and check-in at hotel.",
                "Evening walk around local area.",
                "Try some street food or a popular local restaurant.",
              ],
            ),
            _dayPlan(
              day: "Day 2",
              items: [
                "Morning visit to historical monuments or temples in $from.",
                "Afternoon cultural activity or museum.",
                "Evening market exploration or local crafts.",
              ],
            ),
            _dayPlan(
              day: "Day 3",
              items: [
                "Travel from $from to $to.",
                "Check-in at hotel in $to.",
                "Short visit to a famous site nearby.",
              ],
            ),
            _dayPlan(
              day: "Day 4",
              items: [
                "Full day sightseeing in $to.",
                "Evening rest or enjoy local entertainment.",
              ],
            ),
            _dayPlan(
              day: "Day 5",
              items: [
                "Free time for personal activities or shopping.",
                "Pack and prepare for return on $returnDate.",
              ],
            ),
            const Divider(height: 40),
            const Text(
              "Note: This plan is generated based on your input. Adjust based on weather, preferences, and availability.",
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _dayPlan({required String day, required List<String> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 2),
                child: Text("• $item", style: const TextStyle(fontSize: 14)),
              )),
        ],
      ),
    );
  }
}
