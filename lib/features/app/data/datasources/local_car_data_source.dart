import 'dart:convert';
import 'package:renting_car/core/errors/failures.dart';
import 'package:renting_car/features/app/data/models/car_models.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalCarDataSource {
  Future<Either<Failure, List<CarModels>>> getAllCars();
  Future<Either<Failure, CarModels>> getCarByModel(String model);
  Future<Either<Failure, void>> cacheCars(List<CarModels> cars);
}

final String cachedCars = 'cached_cars';

class LocalCarDataSourceImpl implements LocalCarDataSource {
  final SharedPreferences sharedPreferences;

  LocalCarDataSourceImpl(this.sharedPreferences);

  @override
  Future<Either<Failure, List<CarModels>>> getAllCars() async {
    try {
      final carsJson = sharedPreferences.getStringList(cachedCars);
      if (carsJson == null || carsJson.isEmpty) {
        return Left(CacheFailure('No cached cars available'));
      }

      final cars = <CarModels>[];
      for (final carJson in carsJson) {
        try {
          final carMap = jsonDecode(carJson) as Map<String, dynamic>;
          cars.add(CarModels.fromMap(carMap));
        } catch (e) {
          print('Error parsing car JSON: $e');
          continue;
        }
      }

      if (cars.isEmpty) {
        return Left(CacheFailure('No valid cars in cache'));
      }

      return Right(cars);
    } catch (e) {
      print('Error in getAllCars: $e');
      return Left(CacheFailure('Failed to load cars from cache: $e'));
    }
  }

  @override
  Future<Either<Failure, CarModels>> getCarByModel(String model) async {
    try {
      final carsJson = sharedPreferences.getStringList(cachedCars);
      if (carsJson == null || carsJson.isEmpty) {
        return Left(CacheFailure('No cached cars available'));
      }

      for (final carJson in carsJson) {
        try {
          final carMap = jsonDecode(carJson) as Map<String, dynamic>;
          final car = CarModels.fromMap(carMap);
          if (car.model.toLowerCase() == model.toLowerCase()) {
            return Right(car);
          }
        } catch (e) {
          print('Error parsing car JSON: $e');
          continue;
        }
      }

      return Left(CacheFailure('Car with model $model not found in cache'));
    } catch (e) {
      return Left(CacheFailure('Failed to get car by model: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cacheCars(List<CarModels> cars) async {
    try {
      final jsonList = cars.map((car) => jsonEncode(car.toMap())).toList();
      await sharedPreferences.setStringList(cachedCars, jsonList);
      return Right(null);
    } catch (e) {
      print('Error caching cars: $e');
      return Left(CacheFailure('Failed to cache cars: $e'));
    }
  }
}
