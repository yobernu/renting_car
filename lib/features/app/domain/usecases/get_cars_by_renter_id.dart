import 'package:dartz/dartz.dart';
import 'package:renting_car/core/errors/failures.dart';
import 'package:renting_car/features/app/domain/entities/car.dart';
import 'package:renting_car/features/app/domain/repository/renter_repository.dart';

class GetCarsByRenterId {
  final RenterRepository repository;

  GetCarsByRenterId(this.repository);

  Future<Either<Failure, List<Car>>> call(String renterId) async {
    return await repository.getCarsByRenterId(renterId);
  }
}
