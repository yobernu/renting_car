import 'package:dartz/dartz.dart';
import 'package:renting_car/core/errors/failures.dart';
import 'package:renting_car/core/usecases/usecases.dart';
import 'package:renting_car/features/app/domain/entities/renter.dart';
import 'package:renting_car/features/app/domain/repository/renter_repository.dart';

class GetAllRentersUsecase implements UseCase<List<Renter>, NoParams> {
  final RenterRepository renterRepository;

  GetAllRentersUsecase(this.renterRepository);

  @override
  Future<Either<Failure, List<Renter>>> call(NoParams params) {
    return renterRepository.getAllRenters();
  }
}
