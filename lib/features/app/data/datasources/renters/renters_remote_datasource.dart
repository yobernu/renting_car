import 'package:dartz/dartz.dart';
import 'package:renting_car/core/errors/failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renting_car/features/app/data/models/renters_model.dart';
import 'package:renting_car/features/app/domain/entities/car.dart';

class FirebaseRenterDataSource {
  final FirebaseFirestore firestore;
  static const String defaultRenterId = 'o3kvAbZgtTfSNfaMiLH6';

  FirebaseRenterDataSource(this.firestore);

  Future<Either<Failure, List<RentersModel>>> getAllRenters() async {
    try {
      // First try to get the default renter
      final defaultRenterDoc = await firestore
          .collection('users')
          .doc(defaultRenterId)
          .get();

      if (!defaultRenterDoc.exists) {
        return Left(ServerFailure('Default renter not found'));
      }

      final defaultRenterData = defaultRenterDoc.data();
      if (defaultRenterData == null || defaultRenterData.isEmpty) {
        return Left(ServerFailure('Default renter data is empty'));
      }

      // Convert to RentersModel
      final defaultRenter = RentersModel.fromMap({
        ...defaultRenterData,
        'id': defaultRenterDoc.id,
      });

      return Right([defaultRenter]);
    } on FirebaseException catch (e) {
      return Left(ServerFailure('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch renters: $e'));
    }
  }

  Future<Either<Failure, RentersModel>> getRenterByEmail(String email) async {
    try {
      // If no email is provided, use the default renter ID
      if (email.isEmpty) {
        return getRenterById(''); // This will use the defaultRenterId
      }

      final querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return Left(ServerFailure('Renter with email "$email" not found'));
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data();
      if (data.isEmpty) {
        return Left(ServerFailure('Empty document data for renter: $email'));
      }

      return Right(RentersModel.fromMap({...data, 'id': doc.id}));
    } on FirebaseException catch (e) {
      return Left(ServerFailure('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch renter: $e'));
    }
  }

  Future<Either<Failure, RentersModel>> getRenterById(String id) async {
    try {
      final doc = await firestore.collection('users').doc(id).get();

      if (!doc.exists || doc.data() == null || doc.data()!.isEmpty) {
        return Left(ServerFailure('Default renter not found or data is empty'));
      }

      final data = doc.data()!;
      return Right(RentersModel.fromMap({...data, 'id': doc.id}));
    } on FirebaseException catch (e) {
      return Left(ServerFailure('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch default renter: $e'));
    }
  }

  Future<Either<Failure, List<Car>>> getCarsByRenterId(String renterId) async {
    try {
      // First check if renter exists
      final renterDoc = await firestore.collection('users').doc(renterId).get();
      if (!renterDoc.exists) {
        return Left(
          ServerFailure('Renter with renterId "$renterId" not found'),
        );
      }

      // Query cars collection where renterId matches
      final querySnapshot = await firestore
          .collection('cars')
          .where('renterId', isEqualTo: renterId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return Right([]); // Return empty list if no cars found
      }

      final cars = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID to the data
        return Car.fromMap(data);
      }).toList();

      return Right(cars);
    } on FirebaseException catch (e) {
      return Left(ServerFailure('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch cars: $e'));
    }
  }
}
