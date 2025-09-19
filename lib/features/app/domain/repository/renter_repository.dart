import 'package:dartz/dartz.dart';
import 'package:renting_car/core/errors/failures.dart';
import 'package:renting_car/features/app/domain/entities/car.dart';
import 'package:renting_car/features/app/domain/entities/renter.dart';

abstract class RenterRepository {
  Future<Either<Failure, List<Renter>>> getAllRenters();
  Future<Either<Failure, Renter>> getRenterByEmail(String email);
  Future<Either<Failure, Renter>> getRenterById(String id);
  Future<Either<Failure, List<Car>>> getCarsByRenterId(String renterId);
}
