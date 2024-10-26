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
}

List<BusStop> busStopsNow = [];
