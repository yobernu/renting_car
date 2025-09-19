abstract class CarEvent {}

class GetAllCarsEvent extends CarEvent {}

class GetCarByModelEvent extends CarEvent {
  final String model;

  GetCarByModelEvent(this.model);
}
