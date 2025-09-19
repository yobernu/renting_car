// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:renting_car/features/app/domain/entities/car.dart';
// import 'package:renting_car/features/app/domain/usecases/get_cars_by_renter_id.dart';
// import 'package:renting_car/features/app/presentation/helpers/more_card.dart';

// // Enable debug logging
// void debugLog(String message) {
//   log(message, name: 'RenterCarsList');
// }

// class RenterCarsList extends StatefulWidget {
//   final String renterId;
//   final String currentCarId;

//   const RenterCarsList({
//     super.key,
//     required this.renterId,
//     required this.currentCarId,
//   });

//   @override
//   State<RenterCarsList> createState() => _RenterCarsListState();
// }

// class _RenterCarsListState extends State<RenterCarsList> {
//   late final GetCarsByRenterId _getCarsByRenterId;
//   List<Car> _cars = [];
//   bool _isLoading = true;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     debugLog(
//       'initState - RenterId: ${widget.renterId}, CurrentCarId: ${widget.currentCarId}',
//     );

//     if (widget.renterId.isEmpty) {
//       debugLog('⚠️ Error: renterId is empty');
//       if (mounted) {
//         setState(() {
//           _error = 'No renter information available';
//           _isLoading = false;
//         });
//       }
//       return;
//     }

//     _getCarsByRenterId = GetIt.instance<GetCarsByRenterId>();
//     _loadCars();
//   }

//   @override
//   void didUpdateWidget(RenterCarsList oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.renterId != oldWidget.renterId ||
//         widget.currentCarId != oldWidget.currentCarId) {
//       debugLog(
//         'didUpdateWidget - New RenterId: ${widget.renterId}, CurrentCarId: ${widget.currentCarId}',
//       );
//       _loadCars();
//     }
//   }

//   Future<void> _loadCars() async {
//     if (!mounted) return;

//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     debugLog('Loading cars for renter: ${widget.renterId}');
//     debugLog('Current car ID to filter: ${widget.currentCarId}');

//     try {
//       final result = await _getCarsByRenterId(widget.renterId);

//       if (!mounted) return;

//       result.fold(
//         (failure) {
//           debugLog('❌ Error loading cars: $failure');
//           setState(() {
//             _error = 'Failed to load cars';
//             _cars = [];
//             _isLoading = false;
//           });
//         },
//         (cars) {
//           debugLog('✅ Successfully loaded ${cars.length} cars');
//           debugLog('Car IDs: ${cars.map((c) => c.id).toList()}');
//           setState(() {
//             _cars = cars;
//             _isLoading = false;
//           });
//         },
//       );
//     } catch (e) {
//       debugLog('🔥 Exception in _loadCars: $e');
//       debugLog('Stack trace: ${StackTrace.current}');
//       if (!mounted) return;
//       setState(() {
//         _error = 'An error occurred';
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Only log in debug mode
//     assert(() {
//       debugLog('Building RenterCarsList:');
//       return true;
//     }());
//     debugLog('  - isLoading: $_isLoading');
//     debugLog('  - error: $_error');
//     debugLog('  - cars count: ${_cars.length}');
//     debugLog('  - currentCarId: ${widget.currentCarId}');
//     debugLog('  - renterId: ${widget.renterId}');

//     if (_isLoading) {
//       debugPrint('Showing loading indicator');
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_error != null) {
//       debugPrint('Showing error: $_error');
//       return Center(child: Text(_error!));
//     }

//     // Filter out invalid cars (empty IDs)
//     final validCars = _cars.where((car) => car.id.isNotEmpty).toList();

//     // If no valid cars, return empty widget
//     if (validCars.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     // Filter out the current car and get up to 3 other cars
//     final currentCarId = widget.currentCarId;
//     final otherCars = currentCarId.isEmpty ||
//         !validCars.any((car) => car.id == currentCarId)
//         ? validCars.take(3).toList()
//         : validCars
//             .where((car) => car.id != currentCarId)
//             .take(3)
//             .toList();

//     debugLog('✅ Filtered cars count: ${otherCars.length}');

//     if (otherCars.isEmpty) {
//       debugLog('ℹ️ No other cars to show');
//       return const SizedBox.shrink(); // Return empty widget instead of text
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const Padding(
//           padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
//           child: Text(
//             'Other cars from this renter',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(
//           height: 180, // Fixed height for the horizontal list
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: otherCars.length,
//             shrinkWrap: true,
//             physics: const ClampingScrollPhysics(),
//             itemBuilder: (context, index) {
//               final car = otherCars[index];
//               return Padding(
//                 padding: const EdgeInsets.only(right: 8.0),
//                 child: MoreCard(car: car),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:renting_car/features/app/domain/entities/car.dart';
import 'package:renting_car/features/app/domain/usecases/get_cars_by_renter_id.dart';
import 'package:renting_car/features/app/presentation/helpers/more_card.dart';

// Use conditional debugging - only log in debug mode
void debugLog(String message) {
  assert(() {
    log(message, name: 'RenterCarsList');
    return true;
  }());
}

class RenterCarsList extends StatefulWidget {
  final String renterId;
  final String currentCarId;

  const RenterCarsList({
    super.key,
    required this.renterId,
    required this.currentCarId,
  });

  @override
  State<RenterCarsList> createState() => _RenterCarsListState();
}

class _RenterCarsListState extends State<RenterCarsList> {
  late final GetCarsByRenterId _getCarsByRenterId;
  List<Car> _cars = [];
  bool _isLoading = true;
  String? _error;
  bool _isLoadingData = false;

  @override
  void initState() {
    super.initState();
    debugLog('initState - RenterId: ${widget.renterId}');

    if (widget.renterId.isEmpty) {
      debugLog('⚠️ Error: renterId is empty');
      if (mounted) {
        setState(() {
          _error = 'No renter information available';
          _isLoading = false;
        });
      }
      return;
    }

    _getCarsByRenterId = GetIt.instance<GetCarsByRenterId>();
    _loadCars();
  }

  @override
  void didUpdateWidget(RenterCarsList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only reload if the renterId actually changed and we're not already loading
    if ((widget.renterId != oldWidget.renterId && widget.renterId.isNotEmpty) &&
        !_isLoadingData) {
      debugLog('didUpdateWidget - Reloading for new renter');
      _loadCars();
    }
  }

  Future<void> _loadCars() async {
    if (!mounted || _isLoadingData) return;

    setState(() {
      _isLoadingData = true;
      _isLoading = true;
      _error = null;
    });

    debugLog('Loading cars for renter: ${widget.renterId}');

    try {
      final result = await _getCarsByRenterId(widget.renterId);

      if (!mounted) return;

      result.fold(
        (failure) {
          debugLog('❌ Error loading cars: $failure');
          setState(() {
            _error = 'No additional cars available for renter';
            _cars = [];
            _isLoading = false;
            _isLoadingData = false;
          });
        },
        (cars) {
          debugLog('✅ Successfully loaded ${cars.length} cars');
          setState(() {
            _cars = cars;
            _isLoading = false;
            _isLoadingData = false;
          });
        },
      );
    } catch (e) {
      debugLog('🔥 Exception in _loadCars: $e');
      if (!mounted) return;
      setState(() {
        _error = 'An error occurred';
        _isLoading = false;
        _isLoadingData = false;
      });
    }
  }

  List<Car> _getFilteredCars() {
    // Filter out invalid cars first
    final validCars = _cars.where((car) => car.id.isNotEmpty).toList();

    if (validCars.isEmpty) return [];

    // If currentCarId is empty or not found, show first 3 cars
    if (widget.currentCarId.isEmpty ||
        !validCars.any((car) => car.id == widget.currentCarId)) {
      return validCars.take(3).toList();
    }

    // Filter out current car and take up to 3 others
    return validCars
        .where((car) => car.id != widget.currentCarId)
        .take(3)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Moved debug logs inside assert to prevent production performance issues
    assert(() {
      debugLog('Building RenterCarsList:');
      debugLog('  - isLoading: $_isLoading');
      debugLog('  - error: $_error');
      debugLog('  - cars count: ${_cars.length}');
      return true;
    }());

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Padding(padding: 
      
        const EdgeInsets.all(8.0),
        child: Text(
          _error!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.teal),
        ),
      ));
    }

    final otherCars = _getFilteredCars();

    if (otherCars.isEmpty) {
      return const SizedBox.shrink();
    }

  return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: [
    const Padding(
      padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        'Other cars from this renter',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    
    SizedBox( // ← Constrain with fixed height
      height: 300, // Adjust based on your needs
      child: ListView.builder(
        itemCount: otherCars.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final car = otherCars[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: MoreCard(car: car),
          );
        },
      ),
    ),
  ],
);
  }
}




// failed to load cars