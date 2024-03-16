class Activity {
  String id = '';
  String name = '';
  String description = '';
  String location = '';
  String date = '';
  String associationId = '';

  Activity({
    required this.name,
    required this.description,
    required this.location,
    required this.date,
    required this.associationId,
  });

  Activity.empty();

  Activity.fromMap(Map<String, dynamic> map) {
    id = map['id'] ?? '';
    name = map['name'] ?? '';
    description = map['description'] ?? '';
    location = map['location'] ?? '';
    date = map['date'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'date': date,
      'associationId': associationId,
    };
  }
}
