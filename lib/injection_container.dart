import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:renting_car/core/network/network_info.dart';
import 'package:renting_car/core/utils/input_converter.dart';
import 'package:renting_car/features/app/data/datasources/local_car_data_source.dart';
import 'package:renting_car/features/app/data/datasources/remote_data_source.dart';
import 'package:renting_car/features/app/data/datasources/renters/renters_remote_datasource.dart';
import 'package:renting_car/features/app/data/repository/car_repository_impl.dart';
import 'package:renting_car/features/app/data/repository/renter_repository_impl.dart';
import 'package:renting_car/features/app/domain/repository/car_repository.dart';
import 'package:renting_car/features/app/domain/repository/renter_repository.dart';
import 'package:renting_car/features/app/domain/usecases/get_all_cars_usecase.dart';
import 'package:renting_car/features/app/domain/usecases/get_all_renters.dart';
import 'package:renting_car/features/app/domain/usecases/get_car_by_model_usecase.dart';
import 'package:renting_car/features/app/domain/usecases/get_renter_by_id.dart';
import 'package:renting_car/features/app/domain/usecases/get_renter_by_email.dart';
import 'package:renting_car/features/app/domain/usecases/get_cars_by_renter_id.dart';
import 'package:renting_car/features/app/presentation/bloc_provider/car_bloc.dart';
import 'package:renting_car/features/app/presentation/bloc_provider/renter_bloc.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

Future<void> initInjection() async {
  try {
    // External dependencies
    final sharedPrefs = await SharedPreferences.getInstance();
    final httpClient = http.Client();
    final connectivity = Connectivity();

    // Register core services
    sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
    sl.registerLazySingleton<http.Client>(() => httpClient);
    sl.registerLazySingleton<Connectivity>(() => connectivity);

    // Register network info with http client
    sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(
        connectivity: sl<Connectivity>(),
        client: sl<http.Client>(),
      ),
    );

    // Firebase
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );

    // Data sources
    sl.registerLazySingleton<FirebaseCarDataSource>(
      () => FirebaseCarDataSource(sl()),
    );

    // Register LocalCarDataSource
    sl.registerLazySingleton<LocalCarDataSource>(
      () => LocalCarDataSourceImpl(sl()),
    );

    sl.registerLazySingleton<CarRepository>(
      () => CarRepositoryImpl(
        sl<FirebaseCarDataSource>(),
        sl<LocalCarDataSource>(),
        sl<NetworkInfo>(),
      ),
    );

    // usecases
    sl.registerLazySingleton<GetAllCarsUsecase>(() => GetAllCarsUsecase(sl()));
    sl.registerLazySingleton<GetCarByModelUsecase>(
      () => GetCarByModelUsecase(sl()),
    );

    // Renter
    sl.registerLazySingleton<FirebaseRenterDataSource>(
      () => FirebaseRenterDataSource(sl()),
    );

    sl.registerLazySingleton<RenterRepository>(
      () => RenterRepositoryImpl(
        remoteDataSource: sl<FirebaseRenterDataSource>(),
      ),
    );
    sl.registerLazySingleton<GetRenterById>(() => GetRenterById(sl()));
    sl.registerLazySingleton<GetAllRentersUsecase>(
      () => GetAllRentersUsecase(sl()),
    );
    sl.registerLazySingleton<GetRenterByEmailUsecase>(
      () => GetRenterByEmailUsecase(sl()),
    );
    
    // Register GetCarsByRenterId use case
    sl.registerLazySingleton<GetCarsByRenterId>(
      () => GetCarsByRenterId(sl()),
    );

    // Utils
    sl.registerLazySingleton<InputConverter>(() => InputConverter());

    // bloc
    sl.registerFactory<CarBloc>(
      () => CarBloc(
        sl<GetAllCarsUsecase>(),
        sl<GetCarByModelUsecase>(),
        sl<InputConverter>(),
      ),
    );

    sl.registerFactory<RenterBloc>(
      () => RenterBloc(
        getRenterById: sl<GetRenterById>(),
        getAllRenters: sl<GetAllRentersUsecase>(),
        getRenterByEmail: sl<GetRenterByEmailUsecase>(),
      ),
    );
  } catch (e, st) {
    print('❌ Dependency injection error: $e');
    print(st);
  }
}
