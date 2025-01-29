class City {
  final int id;
  final String name;
  final String? status;

  City({
    required this.id,
    required this.name,
    this.status,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }
}

class StoreType {
  final int id;
  final String name;
  final String? status;

  StoreType({
    required this.id,
    required this.name,
    this.status,
  });

  factory StoreType.fromJson(Map<String, dynamic> json) {
    return StoreType(
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }
}
