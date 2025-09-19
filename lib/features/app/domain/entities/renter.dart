class Renter {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final Map<String, dynamic> location;
  final String imageUrl;
  final double? pricePerHour;
  final String? bio;
  final double? rating;
  final int? totalRentals;

  Renter({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    Map<String, dynamic>? location,
    this.imageUrl = 'assets/user.png',
    this.pricePerHour,
    this.bio,
    this.rating,
    this.totalRentals,
  }) : location = location ?? {};

  // Add copyWith method for immutability
  Renter copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    Map<String, dynamic>? location,
    String? imageUrl,
    double? pricePerHour,
    String? bio,
    double? rating,
    int? totalRentals,
  }) {
    return Renter(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      totalRentals: totalRentals ?? this.totalRentals,
    );
  }
}
