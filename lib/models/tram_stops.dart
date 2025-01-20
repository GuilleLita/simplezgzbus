class TramStop{
  final String id;
  String id2 = '';
  final String name;

  set setId2(String _id){
    id2 = _id;
  }

  TramStop({
    required this.id,
    required this.name,
    this.id2 = '',
  });

  @override
  String toString() {
    if(name == 'PLAZA ESPANA'){
      return 'PLAZA ESPAÑA';
    }
    return name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is TramStop) {
      return name == other.name;
    }
    if (other is String) {
      return name == other;
    }
    return false;
  }

}

class NexTrams{
  final String name;
  final String direction1;
  late String direction2;
  final String time_direction1;
  late String time_direction2;
  late String second_time_direction1;
  late String second_time_direction2;

  int numOfdirections = 0;

  NexTrams({required this.name, required this.direction1, required this.time_direction1});
}

List<TramStop> tramStopsNow = [];