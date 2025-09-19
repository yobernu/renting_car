class RentersModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final Map<String, dynamic> location;
  final String imageUrl;
  final double? pricePerHour;

  RentersModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.imageUrl,
    this.pricePerHour,
  });

  factory RentersModel.fromMap(Map<String, dynamic> map) {
    return RentersModel(
      id: map['id'] ?? '',
      name: map['name'] ?? 'N/A',
      email: map['email'] ?? '',
      phone: map['phone']?.toString() ?? 'N/A',
      location: Map<String, dynamic>.from(map['location'] ?? {}),
      imageUrl: map['imageUrl'] ?? 'assets/user.png',
      pricePerHour: (map['pricePerHour'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'imageUrl': imageUrl,
      if (pricePerHour != null) 'pricePerHour': pricePerHour,
    };
  }
}
