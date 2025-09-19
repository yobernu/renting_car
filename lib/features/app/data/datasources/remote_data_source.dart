import 'package:dartz/dartz.dart';
import 'package:renting_car/core/errors/failures.dart';
import 'package:renting_car/features/app/data/models/car_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCarDataSource {
  final FirebaseFirestore firestore;

  FirebaseCarDataSource(this.firestore);

  Future<Either<Failure, List<CarModels>>> getAllCars() async {
    try {
      final cars = await firestore.collection('cars').get();
      final carList = cars.docs.map((doc) {
        final data = doc.data();
        if (data.isEmpty) {
          throw Exception('Empty document data for car');
        }
        return CarModels.fromMap(Map<String, dynamic>.from(data));
      }).toList();
      
      if (carList.isEmpty) {
        return Left(ServerFailure('No cars found in the database'));
      }
      
      return Right(carList);
    } on FirebaseException catch (e) {
      return Left(ServerFailure('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch cars: $e'));
    }
  }

  Future<Either<Failure, CarModels>> getCarByModel(String model) async {
    try {
      final doc = await firestore.collection('cars').doc(model).get();
      
      if (!doc.exists) {
        return Left(ServerFailure('Car with model "$model" not found'));
      }
      
      final data = doc.data();
      if (data == null || data.isEmpty) {
        return Left(ServerFailure('Empty document data for car: $model'));
      }
      
      return Right(CarModels.fromMap(Map<String, dynamic>.from(data)));
    } on FirebaseException catch (e) {
      return Left(ServerFailure('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch car: $e'));
    }
  }
}
