class Car {
  final String id;
  final String model;
  final double distance;
  final double fuelCapacity;
  final double pricePerHour;
  final String imageUrl;
  final String renterId;

  Car({
    required this.id,
    required this.model,
    required this.distance,
    required this.fuelCapacity,
    required this.pricePerHour,
    required this.imageUrl,
    required this.renterId,
  });

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'] ?? '',
      model: map['model'] ?? '',
      distance: (map['distance'] ?? 0.0).toDouble(),
      fuelCapacity: (map['fuelCapacity'] ?? 0.0).toDouble(),
      pricePerHour: (map['pricePerHour'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      renterId: map['renterId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'model': model,
      'distance': distance,
      'fuelCapacity': fuelCapacity,
      'pricePerHour': pricePerHour,
      'imageUrl': imageUrl,
      'renterId': renterId,
    };
  }
}
