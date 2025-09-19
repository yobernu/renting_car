import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:renting_car/features/app/domain/entities/car.dart';
import 'package:renting_car/features/app/domain/usecases/get_all_renters.dart';
import 'package:renting_car/features/app/domain/usecases/get_renter_by_email.dart';
import 'package:renting_car/features/app/domain/usecases/get_renter_by_id.dart';
import 'package:renting_car/features/app/presentation/bloc_provider/renter_bloc.dart';
import 'package:renting_car/features/app/presentation/helpers/car_details_card.dart';
import 'package:url_launcher/url_launcher.dart';

final sl = GetIt.instance;

class MapsDetailsPage extends StatelessWidget {
  final Car car;
  const MapsDetailsPage({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RenterBloc(
        getRenterById: sl<GetRenterById>(),
        getRenterByEmail: sl<GetRenterByEmailUsecase>(),
        getAllRenters: sl<GetAllRentersUsecase>(),
      )..add(GetRenterByIdEvent(car.renterId)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(
            margin: EdgeInsets.only(left: 22, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        body: Stack(
          children: [
            BlocBuilder<RenterBloc, RenterState>(
              builder: (context, state) {
                LatLng defaultLocation = const LatLng(51.5, -0.09);
                LatLng? renterLocation;

                if (state is RenterLoaded) {
                  final location = state.renter.location;
                  if (location.isNotEmpty &&
                      location['lat'] != null &&
                      location['long'] != null) {
                    renterLocation = LatLng(
                      (location['lat'] as num).toDouble(),
                      (location['long'] as num).toDouble(),
                    );
                  }
                }

                return FlutterMap(
                  options: MapOptions(
                    center: renterLocation ?? defaultLocation,
                    zoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.yoseph.renting_car',
                    ),
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () async {
                            final url = Uri.parse(
                              'https://www.openstreetmap.org/copyright',
                            );
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CarDetailsCard(car: car),
            ),
            Positioned(
              bottom: 200,
              right: 20,
              child: Image.asset('assets/white_car.png', height: 100),
            ),
          ],
        ),
      ),
    );
  }
}



// book now