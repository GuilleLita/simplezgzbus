class BusStop {
  final String number;
  final String name;


  BusStop({
    required this.number,
    required this.name,
  });

  @override
  String toString() {
    return '$number $name';
  }
}

List<BusStop> busStopsNow = [];
