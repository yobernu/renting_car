import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renting_car/core/usecases/usecases.dart';
import 'package:renting_car/core/utils/input_converter.dart';
import 'package:renting_car/features/app/domain/usecases/get_all_cars_usecase.dart';
import 'package:renting_car/features/app/domain/usecases/get_car_by_model_usecase.dart';
import 'package:renting_car/features/app/presentation/bloc_provider/bloc_events.dart';
import 'package:renting_car/features/app/presentation/bloc_provider/bloc_states.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  final GetAllCarsUsecase getAllCars;
  final GetCarByModelUsecase getCarByModel;
  final InputConverter inputConverter;

  CarBloc(this.getAllCars, this.getCarByModel, this.inputConverter)
    : super(CarsLoading()) {
    debugPrint('🚀 CarBloc - Initialized');

    on<GetAllCarsEvent>((event, emit) async {
      debugPrint('🔄 CarBloc - Processing GetAllCarsEvent');
      emit(CarsLoading());

      try {
        debugPrint('📡 CarBloc - Calling getAllCars usecase');
        final result = await getAllCars.call(NoParams());

        result.fold(
          (failure) {
            debugPrint('❌ CarBloc - Error: ${failure.message}');
            emit(CarsError(failure.message));
          },
          (cars) {
            debugPrint('✅ CarBloc - Successfully loaded ${cars.length} cars');
            emit(CarsLoaded(cars));
          },
        );
      } catch (e, stackTrace) {
        debugPrint('🔥 CarBloc - Unexpected error: $e');
        debugPrint('📝 Stack trace: $stackTrace');
        debugPrint('📝 Stack trace: $stackTrace');
        emit(CarsError('An unexpected error occurred'));
      }
    });
    on<GetCarByModelEvent>((event, emit) async {
      debugPrint(
        '🔄 CarBloc - Processing GetCarByModelEvent for model: ${event.model}',
      );
      emit(CarsLoading());

      try {
        final result = await getCarByModel.call(event.model);
        result.fold(
          (failure) {
            debugPrint(
              '❌ CarBloc - Error loading car ${event.model}: ${failure.message}',
            );
            emit(CarsError(failure.message));
          },
          (car) {
            debugPrint('✅ CarBloc - Successfully loaded car: ${car.model}');
            emit(CarsLoaded([car]));
          },
        );
      } catch (e, stackTrace) {
        debugPrint('🔥 CarBloc - Unexpected error in GetCarByModelEvent: $e');
        debugPrint('📝 Stack trace: $stackTrace');
        emit(CarsError('Failed to load car details'));
      }
    });
  }
}
