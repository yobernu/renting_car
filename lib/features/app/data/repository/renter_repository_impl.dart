import 'package:dartz/dartz.dart';
import 'package:renting_car/core/errors/failures.dart';
import 'package:renting_car/features/app/domain/entities/car.dart';
import 'package:renting_car/features/app/domain/entities/renter.dart';
import 'package:renting_car/features/app/domain/repository/renter_repository.dart';
import 'package:renting_car/features/app/data/datasources/renters/renters_remote_datasource.dart';

class RenterRepositoryImpl implements RenterRepository {
  final FirebaseRenterDataSource remoteDataSource;

  RenterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Renter>>> getAllRenters() async {
    try {
      final result = await remoteDataSource.getAllRenters();
      return result.fold((failure) => Left(failure), (models) {
        // Map List<RentersModel> to List<Renter>
        final renters = models
            .map(
              (model) => Renter(
                id: model.id,
                name: model.name,
                email: model.email,
                phone: model.phone,
                location: model.location,
                imageUrl: model.imageUrl,
                pricePerHour: model.pricePerHour,
              ),
            )
            .toList();
        return Right(renters);
      });
    } catch (e) {
      return Left(ServerFailure('Failed to get renters: $e'));
    }
  }

  @override
  Future<Either<Failure, Renter>> getRenterByEmail(String email) async {
    try {
      final result = await remoteDataSource.getRenterByEmail(email);
      return result.fold((failure) => Left(failure), (model) {
        // Map RentersModel to Renter entity
        final renter = Renter(
          id: model.id,
          name: model.name,
          email: model.email,
          phone: model.phone,
          location: model.location,
          imageUrl: model.imageUrl,
          pricePerHour: model.pricePerHour,
        );
        return Right(renter);
      });
    } catch (e) {
      return Left(ServerFailure('Failed to get renter by email: $e'));
    }
  }

  @override
  Future<Either<Failure, Renter>> getRenterById(String id) async {
    try {
      final result = await remoteDataSource.getRenterById(id);
      return result.fold((failure) => Left(failure), (model) {
        // Map RentersModel to Renter entity
        final renter = Renter(
          id: model.id,
          name: model.name,
          email: model.email,
          phone: model.phone,
          location: model.location,
          imageUrl: model.imageUrl,
          pricePerHour: model.pricePerHour,
        );
        return Right(renter);
      });
    } catch (e) {
      return Left(ServerFailure('Failed to get renter by ID: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Car>>> getCarsByRenterId(String renterId) async {
    try {
      final result = await remoteDataSource.getCarsByRenterId(renterId);
      return result.fold((failure) => Left(failure), (res) {
        // Map List<RentersModel> to List<Car>
        final cars = res
            .map(
              (model) => Car(
                id: model.id,
                model: model
                    .model, // Using id as model since we're mapping from RentersModel
                distance: model.distance, // Default distance
                fuelCapacity: model.fuelCapacity, // Default fuel capacity
                pricePerHour: model.pricePerHour,
                imageUrl: model.imageUrl,
                renterId: renterId,
              ),
            )
            .toList();
        return Right(cars);
      });
    } catch (e) {
      return Left(ServerFailure('Failed to get cars by renter ID: $e'));
    }
  }
}
