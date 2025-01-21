class BusStop {
  final String number;
  final String name;
  final String id;


  BusStop({
    required this.number,
    required this.name,
    required this.id,
  });

  @override
  String toString() {
    return '$number $name';
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is BusStop) {
      return id == other.id;
    }
    if (other is String) {
      return name == other;
    }
    return false;
  }
}

List<BusStop> busStopsNow = [];
