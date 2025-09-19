import 'package:dartz/dartz.dart';
import 'package:renting_car/core/errors/failures.dart';
import 'package:renting_car/core/usecases/usecases.dart';
import 'package:renting_car/features/app/domain/entities/car.dart';
import 'package:renting_car/features/app/domain/repository/car_repository.dart';

class GetCarByModelUsecase implements UseCase<Car, String> {
  final CarRepository carRepository;

  GetCarByModelUsecase(this.carRepository);

  @override
  Future<Either<Failure, Car>> call(String params) {
    return carRepository.getCarByModel(params);
  }
}
