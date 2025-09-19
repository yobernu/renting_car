import 'package:dartz/dartz.dart';
import 'package:renting_car/core/errors/failures.dart';
import 'package:renting_car/core/usecases/usecases.dart';
import 'package:renting_car/features/app/domain/entities/car.dart';
import 'package:renting_car/features/app/domain/repository/car_repository.dart';

class GetAllCarsUsecase implements UseCase<List<Car>, NoParams> {
  final CarRepository carRepository;

  GetAllCarsUsecase(this.carRepository);

  @override
  Future<Either<Failure, List<Car>>> call(NoParams params) {
    return carRepository.getAllCars();
  }
}
