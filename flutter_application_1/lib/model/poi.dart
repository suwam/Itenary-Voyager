class POI {
  final String name;
  final List<String> tags;
  final bool crowded;
  final double cost;
  final int duration;
  final String image;
  final double latitude;
  final double longitude;

  POI({
    required this.name,
    required this.tags,
    required this.crowded,
    required this.cost,
    required this.duration,
    required this.image,
    required this.latitude,
    required this.longitude,
  });
}
