class ChatTrip {
  String? destination;        // ✅ replaces `to`
  String? travelDate;
  String? returnDate;
  String? cost;
  String? transport;
  List<String> preferences;
  String? duration;
  String? description;        // ✅ new: detailed travel interests

  ChatTrip({
    this.destination,
    this.travelDate,
    this.returnDate,
    this.cost,
    this.transport,
    this.preferences = const [],
    this.duration,
    this.description,
  });

  bool isComplete() {
    return destination != null &&
        travelDate != null &&
        returnDate != null &&
        cost != null &&
        transport != null &&
        preferences.isNotEmpty &&
        duration != null;
  }

  @override
  String toString() {
    return 'Trip to $destination from ${travelDate ?? "?"} for $duration, returning $returnDate. Budget: Rs.$cost by $transport. Interests: $preferences';
  }
}
