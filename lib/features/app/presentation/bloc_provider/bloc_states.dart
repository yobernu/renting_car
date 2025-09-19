import 'package:renting_car/features/app/domain/entities/car.dart';

abstract class CarState {}

class CarsLoading extends CarState {}

class CarsLoaded extends CarState {
  final List<Car> cars;

  CarsLoaded(this.cars);
}

class CarsError extends CarState {
  final String message;

  CarsError(this.message);
}
