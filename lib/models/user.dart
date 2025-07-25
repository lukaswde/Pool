class User {
  final String id;
  final String name;
  final String rfidChip;

  User({
    required this.id,
    required this.name,
    required this.rfidChip,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      rfidChip: json['rfidChip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rfidChip': rfidChip,
    };
  }
}
