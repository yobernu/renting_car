import 'package:dartz/dartz.dart';
import 'package:renting_car/core/errors/failures.dart';
import 'package:renting_car/features/app/domain/entities/renter.dart';
import 'package:renting_car/features/app/domain/repository/renter_repository.dart';

class GetRenterById {
  final RenterRepository repository;

  GetRenterById(this.repository);

  Future<Either<Failure, Renter>> call(String renterId) async {
    return await repository.getRenterById(renterId);
  }
}
