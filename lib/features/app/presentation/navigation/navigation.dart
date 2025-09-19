import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renting_car/features/app/domain/entities/car.dart';
import 'package:renting_car/features/app/presentation/bloc_provider/bloc_events.dart';
import 'package:renting_car/features/app/presentation/bloc_provider/bloc_states.dart';
import 'package:renting_car/features/app/presentation/bloc_provider/car_bloc.dart';
import 'package:renting_car/features/app/presentation/screens/car-details.dart';
import 'package:renting_car/features/app/presentation/screens/car_listing_screen.dart';
import 'package:renting_car/features/app/presentation/screens/checkout_page.dart';
import 'package:renting_car/features/app/presentation/screens/maps_details_page.dart';
import 'package:renting_car/features/app/presentation/screens/onboarding.dart';
import 'package:get_it/get_it.dart';

class Routes {
  static const onboarding = '/';
  static const listing = '/listing-page';
  static const carDetails = '/car-details';
  static const checkout = '/checkout';
  static const mapsDetails = '/maps-details';
}

class Navigation {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final di = GetIt.instance;
    switch (settings.name) {
      case Routes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const Onboarding(),
          settings: settings,
        );
      case Routes.listing:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di<CarBloc>()..add(GetAllCarsEvent()),
            child: CarListingScreen(),
          ),
          settings: settings,
        );

      case Routes.carDetails:
        final car = settings.arguments as Car;
        return MaterialPageRoute(
          builder: (_) => MultiBlocListener(
            listeners: [
              BlocListener<CarBloc, CarState>(
                listener: (context, state) {
                  if (state is CarsError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
              ),
            ],
            child: CarDetails(car: car),
          ),
          settings: settings,
        );
      case Routes.checkout:
        return MaterialPageRoute(
          builder: (_) => CheckoutPage(),
          settings: settings,
        );

      case Routes.mapsDetails:
        final car = settings.arguments as Car;
        return MaterialPageRoute(
          builder: (_) => MultiBlocListener(
            listeners: [
              BlocListener<CarBloc, CarState>(
                listener: (context, state) {
                  if (state is CarsError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
              ),
            ],
            child: MapsDetailsPage(car: car),
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Onboarding(),
          settings: settings,
        );
    }
  }
}
