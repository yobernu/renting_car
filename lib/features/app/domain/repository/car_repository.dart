import 'package:dartz/dartz.dart';
import 'package:renting_car/core/errors/failures.dart';
import 'package:renting_car/features/app/domain/entities/car.dart';

abstract class CarRepository {
  Future<Either<Failure, List<Car>>> getAllCars();
  Future<Either<Failure, Car>> getCarByModel(String model);
}
