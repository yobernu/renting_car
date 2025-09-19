import 'package:equatable/equatable.dart';
import 'package:renting_car/features/app/domain/entities/car.dart';

class CarModels extends Equatable implements Car {
  @override
  final String id;
  @override
  final String model;
  @override
  final double distance;
  @override
  final double fuelCapacity;
  @override
  final double pricePerHour;
  @override
  final String imageUrl;
  @override
  final String renterId;

  const CarModels({
    required this.id,
    required this.model,
    required this.distance,
    required this.fuelCapacity,
    required this.pricePerHour,
    required this.imageUrl,
    required this.renterId,
  });

  @override
  List<Object?> get props => [
    id,
    model,
    distance,
    fuelCapacity,
    pricePerHour,
    imageUrl,
    renterId,
  ];

  factory CarModels.fromMap(Map<String, dynamic> map) {
    // Helper function to safely convert dynamic to double, handling both int and double
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return CarModels(
      id: map['id'].toString(),
      model: map['model']?.toString() ?? 'Unknown',
      distance: toDouble(map['distance']),
      fuelCapacity: toDouble(map['fuelCapacity']),
      pricePerHour: toDouble(map['pricePerHour']),
      imageUrl: map['imageUrl']?.toString() ?? '',
      renterId: map['renterId']?.toString() ?? '',
    );
  }

  @override
  String toString() {
    return 'CarModels(id: $id, model: $model, distance: $distance, fuelCapacity: $fuelCapacity, pricePerHour: $pricePerHour, imageUrl: $imageUrl, renterId: $renterId)';
  }

  @override
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
