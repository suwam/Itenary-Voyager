class ActivityItem {
  final String time;
  final String title;
  final String description;

  ActivityItem({required this.time, required this.title, required this.description});
}

List<ActivityItem> parseItinerary(String response) {
  final blocks = response.split('\n\n');
  return blocks.map((block) {
    final time = RegExp(r'Time:\s*(.*)').firstMatch(block)?.group(1) ?? '';
    final title = RegExp(r'Title:\s*(.*)').firstMatch(block)?.group(1) ?? '';
    final desc = RegExp(r'Description:\s*(.*)').firstMatch(block)?.group(1) ?? '';
    return ActivityItem(time: time, title: title, description: desc);
  }).toList();
}
