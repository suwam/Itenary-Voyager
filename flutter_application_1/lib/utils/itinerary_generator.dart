// lib/utils/itinerary_generator.dart

String generateManualPlan({
  required String destination,
  required String duration,
  required List<String> preferences,
}) {
  final buffer = StringBuffer();
  final isHourly = duration.contains("hour");
  final isDaily = duration.contains("day");
  final num = int.tryParse(RegExp(r'\d+').firstMatch(duration)?.group(0) ?? '1') ?? 1;

  if (isHourly) {
    buffer.writeln("Time: 9:00 AM\nTitle: Arrival at \$destination\nDescription: Start your quick exploration.");
    if (preferences.contains("religious")) {
      buffer.writeln("\nTime: 10:00 AM\nTitle: Visit Temple\nDescription: Explore Krishna Mandir or nearby shrines.");
    }
    if (preferences.contains("food")) {
      buffer.writeln("\nTime: 11:30 AM\nTitle: Street Food Tasting\nDescription: Try local Newari snacks.");
    }
    buffer.writeln("\nTime: 12:30 PM\nTitle: Return\nDescription: Head back after exploring \$destination.");
  } else if (isDaily) {
    for (int day = 1; day <= num; day++) {
      buffer.writeln("Time: 9:00 AM\nTitle: Day \$day Start\nDescription: Begin exploration of \$destination.");
      if (preferences.contains("religious")) {
        buffer.writeln("Time: 10:30 AM\nTitle: Religious Tour\nDescription: Krishna Mandir, Golden Temple.");
      }
      if (preferences.contains("food")) {
        buffer.writeln("Time: 1:00 PM\nTitle: Lunch\nDescription: Enjoy local Newari dishes.");
      }
      if (preferences.contains("sightseeing")) {
        buffer.writeln("Time: 3:00 PM\nTitle: Local Walk\nDescription: Explore nearby alleys, shops, and art spots.");
      }
      buffer.writeln("Time: 4:30 PM\nTitle: Wrap-up\nDescription: Return or relax in a local café.\n");
    }
  }

  return buffer.toString().trim();
}
