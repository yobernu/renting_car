import 'package:dartz/dartz.dart';
import 'package:renting_car/core/errors/failures.dart';
import 'package:renting_car/core/usecases/usecases.dart';
import 'package:renting_car/features/app/domain/entities/renter.dart';
import 'package:renting_car/features/app/domain/repository/renter_repository.dart';

class GetRenterByEmailUsecase implements UseCase<Renter, String> {
  final RenterRepository renterRepository;

  GetRenterByEmailUsecase(this.renterRepository);

  @override
  Future<Either<Failure, Renter>> call(String params) {
    return renterRepository.getRenterByEmail(params);
  }
}
