import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:renting_car/core/errors/failures.dart';
import 'package:renting_car/features/app/data/datasources/local_car_data_source.dart';
import 'package:renting_car/features/app/data/datasources/remote_data_source.dart';
import 'package:renting_car/features/app/data/models/car_models.dart';
import 'package:renting_car/features/app/domain/repository/car_repository.dart';
import 'package:renting_car/core/network/network_info.dart';

class CarRepositoryImpl implements CarRepository {
  final FirebaseCarDataSource firebaseCarDataSource;
  final LocalCarDataSource localCarDataSource;
  final NetworkInfo networkInfo;

  CarRepositoryImpl(
    this.firebaseCarDataSource,
    this.localCarDataSource,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, List<CarModels>>> getAllCars() async {
    try {
      debugPrint('🔍 CarRepositoryImpl - Checking network connection');
      final isConnected = await networkInfo.isConnected;

      if (isConnected) {
        debugPrint(
          '🌐 CarRepositoryImpl - Network available, fetching from remote',
        );
        final remoteResult = await firebaseCarDataSource.getAllCars();

        return await remoteResult.fold(
          (failure) async {
            debugPrint(
              '❌ CarRepositoryImpl - Remote data source failed: ${failure.message}',
            );
            // Fallback to local if remote fails
            debugPrint(
              '💾 CarRepositoryImpl - Falling back to local data source',
            );
            final localResult = await localCarDataSource.getAllCars();
            return localResult.fold(
              (_) =>
                  Left(CacheFailure('Failed to fetch cars from local storage')),
              (localCars) => Right(localCars),
            );
          },
          (cars) async {
            if (cars.isEmpty) {
              debugPrint(
                'ℹ️ CarRepositoryImpl - No cars found in remote, checking local',
              );
              return localCarDataSource.getAllCars();
            }

            debugPrint(
              '✅ CarRepositoryImpl - Successfully fetched ${cars.length} cars from remote',
            );
            // Cache the fetched cars
            debugPrint(
              '💾 CarRepositoryImpl - Caching ${cars.length} cars locally',
            );
            final cacheResult = await localCarDataSource.cacheCars(cars);
            cacheResult.fold(
              (cacheFailure) => debugPrint(
                '⚠️ Failed to cache cars: ${cacheFailure.message}',
              ),
              (_) => debugPrint('✅ Successfully cached ${cars.length} cars'),
            );
            return Right(cars);
          },
        );
      } else {
        debugPrint(
          '📱 CarRepositoryImpl - No network, using local data source',
        );
        final localResult = await localCarDataSource.getAllCars();
        return localResult.fold(
          (_) => Left(CacheFailure('Failed to fetch cars from local storage')),
          (localCars) => Right(localCars),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('🔥 CarRepositoryImpl - Unexpected error: $e');
      debugPrint('📝 Stack trace: $stackTrace');
      return Left(ServerFailure('Failed to fetch cars: $e'));
    }
  }

  @override
  Future<Either<Failure, CarModels>> getCarByModel(String model) async {
    try {
      debugPrint('🔍 CarRepositoryImpl - Getting car by model: $model');
      final isConnected = await networkInfo.isConnected;

      if (isConnected) {
        debugPrint(
          '🌐 CarRepositoryImpl - Network available, fetching from remote',
        );
        final remoteResult = await firebaseCarDataSource.getCarByModel(model);

        return await remoteResult.fold(
          (failure) async {
            debugPrint(
              '❌ CarRepositoryImpl - Remote data source failed: ${failure.message}',
            );
            // Fallback to local if remote fails
            debugPrint(
              '💾 CarRepositoryImpl - Falling back to local data source',
            );
            final localResult = await localCarDataSource.getCarByModel(model);
            return localResult.fold((_) {
              // If local fails, try to get all cars (which will use defaults if needed)
              // and then find the specific car
              return _handleLocalCarNotFound(model);
            }, (localCar) => Right(localCar));
          },
          (car) async {
            debugPrint(
              '✅ CarRepositoryImpl - Successfully fetched car: ${car.model}',
            );
            // Update the cache with the latest cars
            final allCarsResult = await firebaseCarDataSource.getAllCars();
            await allCarsResult.fold(
              (failure) async {
                debugPrint('⚠️ Failed to update cache: ${failure.message}');
              },
              (cars) async {
                final cacheResult = await localCarDataSource.cacheCars(cars);
                cacheResult.fold(
                  (cacheFailure) => debugPrint(
                    '⚠️ Failed to cache cars: ${cacheFailure.message}',
                  ),
                  (_) => debugPrint(
                    '✅ Successfully updated cache with ${cars.length} cars',
                  ),
                );
              },
            );
            return Right(car);
          },
        );
      } else {
        debugPrint(
          '📱 CarRepositoryImpl - No network, using local data source',
        );
        final localResult = await localCarDataSource.getCarByModel(model);
        return localResult.fold(
          (_) => _handleLocalCarNotFound(model),
          (localCar) => Right(localCar),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('🔥 CarRepositoryImpl - Unexpected error: $e');
      debugPrint('📝 Stack trace: $stackTrace');
      return Left(ServerFailure('Failed to fetch car details: $e'));
    }
  }

  // Helper method to handle when a car is not found in local storage
  Future<Either<Failure, CarModels>> _handleLocalCarNotFound(
    String model,
  ) async {
    debugPrint('🔍 Car not found in local cache, trying to get all cars');
    final allCarsResult = await getAllCars();

    return allCarsResult.fold(
      (failure) =>
          Left(CacheFailure('Car not found and could not load default cars')),
      (cars) {
        final car = cars.firstWhere(
          (car) => car.model.toLowerCase() == model.toLowerCase(),
          orElse: () => cars.first, // Return first car as fallback
        );
        return Right(car);
      },
    );
  }
}
