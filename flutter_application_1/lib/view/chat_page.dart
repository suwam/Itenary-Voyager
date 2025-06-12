import 'package:flutter/material.dart';
import '../model/chat_trip_model.dart';
import '../view/itinerary_summary_page.dart';
import '../utils/itinerary_generator.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  final ChatTrip trip = ChatTrip();
  bool isTyping = false;

  void handleUserInput(String input) {
    if (input.trim().isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': input});
      isTyping = true;
    });

    _controller.clear();
    input = input.toLowerCase();

    Future.delayed(const Duration(milliseconds: 600), () {
      if (trip.destination == null) {
        trip.destination = extractLocation(input);
        addAssistantMessage("Nice! When are you planning to travel to ${trip.destination}?");
        return;
      }
      if (trip.travelDate == null) {
        trip.travelDate = extractDate(input);
        addAssistantMessage("Great. How long will your trip be? (e.g., 2 days or 6 hours)");
        return;
      }
      if (trip.duration == null) {
        trip.duration = extractDuration(input);
        trip.returnDate = calculateReturnDate(trip.travelDate!, trip.duration!);
        addAssistantMessage("Understood. What's your estimated budget?");
        return;
      }
      if (trip.cost == null) {
        trip.cost = extractCost(input);
        addAssistantMessage("What kind of transport will you use? (e.g., bus, car, flight)");
        return;
      }
      if (trip.transport == null) {
        trip.transport = extractTransport(input);
        addAssistantMessage("Any travel interests? (e.g., food, culture, religious)?");
        return;
      }
      if (trip.preferences.isEmpty) {
        trip.preferences = extractPreferences(input);
        trip.description = input;
        addAssistantMessage("Perfect! Here's your itinerary summary.");
        goToSummary();
        return;
      }
      if (!trip.isComplete()) {
        addAssistantMessage("Please provide the missing details to complete your trip plan.");
      }
    });
  }

  void addAssistantMessage(String text) {
    setState(() {
      messages.add({'role': 'assistant', 'text': text});
      isTyping = false;
    });
  }

  void goToSummary() {
    final generatedPlan = generateManualPlan(
      destination: trip.destination!,
      duration: trip.duration!,
      preferences: trip.preferences,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItinerarySummaryPage(
          destination: trip.destination!,
          travelDate: trip.travelDate!,
          returnDate: trip.returnDate!,
          duration: trip.duration!,
          cost: trip.cost!,
          transport: trip.transport!,
          preferences: trip.preferences,
          description: trip.description,
          aiResponse: generatedPlan,
        ),
      ),
    );
  }

  String extractLocation(String input) {
    final locations = ['pokhara', 'lumbini', 'chitwan', 'kathmandu', 'bandipur', 'patan'];
    for (var loc in locations) {
      if (input.contains(loc)) return loc[0].toUpperCase() + loc.substring(1);
    }
    return 'Unknown';
  }

  String extractDate(String input) {
    final months = ['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august'];
    for (var month in months) {
      if (input.contains(month)) {
        return "2025-${(months.indexOf(month) + 1).toString().padLeft(2, '0')}-10";
      }
    }
    return "2025-06-15";
  }

  String extractDuration(String input) {
    final match = RegExp(r'(\d+)\s*(day|days|hour|hours)').firstMatch(input);
    return match != null ? '${match.group(1)} ${match.group(2)}' : '1 day';
  }

  String calculateReturnDate(String travelDate, String duration) {
    try {
      final date = DateTime.parse(travelDate);
      final num = int.parse(duration.split(' ')[0]);
      final unit = duration.contains('hour') ? 'hour' : 'day';
      final returnDate = unit == 'hour'
          ? date.add(Duration(hours: num))
          : date.add(Duration(days: num));
      return returnDate.toIso8601String().substring(0, 10);
    } catch (e) {
      return travelDate;
    }
  }

  String extractCost(String input) {
    final match = RegExp(r'rs\.?\s?(\d{3,6})').firstMatch(input);
    return match != null ? match.group(1)! : '5000';
  }

  String extractTransport(String input) {
    if (input.contains("bus")) return "Bus";
    if (input.contains("car")) return "Car";
    if (input.contains("flight")) return "Flight";
    if (input.contains("bike")) return "Bike";
    return "Other";
  }

  List<String> extractPreferences(String input) {
    final interests = ['nature', 'culture', 'hiking', 'temple', 'food', 'religious', 'sightseeing'];
    return interests.where((interest) => input.contains(interest)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Travel Assistant"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE0F2F1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: messages.length + (isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (isTyping && index == messages.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.teal,
                            child: Icon(Icons.smart_toy, color: Colors.white, size: 18),
                          ),
                          SizedBox(width: 10),
                          Text("Typing...", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  final msg = messages[index];
                  final isUser = msg['role'] == 'user';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment:
                          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (!isUser)
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.teal,
                            child: Icon(Icons.smart_toy, color: Colors.white, size: 18),
                          ),
                        if (!isUser) const SizedBox(width: 10),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: isUser
                                ? const EdgeInsets.only(left: 50)
                                : const EdgeInsets.only(right: 50),
                            decoration: BoxDecoration(
                              color: isUser ? Colors.teal[300] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              msg['text'] ?? '',
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        if (isUser) const SizedBox(width: 10),
                        if (isUser)
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.teal,
                            child: Icon(Icons.person, color: Colors.white, size: 18),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type your travel plan...",
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: handleUserInput,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (_controller.text.trim().isNotEmpty) {
                        handleUserInput(_controller.text.trim());
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
