import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:renting_car/features/app/domain/entities/car.dart';
import 'package:renting_car/features/app/domain/entities/renter.dart';
import 'package:renting_car/features/app/domain/usecases/get_all_renters.dart';
import 'package:renting_car/features/app/domain/usecases/get_renter_by_email.dart';
import 'package:renting_car/features/app/domain/usecases/get_renter_by_id.dart';
import 'package:renting_car/features/app/presentation/bloc_provider/renter_bloc.dart';
import 'package:renting_car/features/app/presentation/helpers/more_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:renting_car/features/app/presentation/widgets/renter_cars_list.dart';

final getIt = GetIt.instance;

class CarDetails extends StatefulWidget {
  final Car car;
  const CarDetails({super.key, required this.car});

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(_controller!);
    _controller!.addListener(() {
      setState(() {});
    });
    _controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline),
            SizedBox(width: 15),
            Text('Car Details', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
          ],
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          AboutCard(car: widget.car),
          SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              color: Color(0xffF3F3F3),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // User-profile [renter]
                BlocProvider(
                  create: (context) => RenterBloc(
                    getRenterById: GetRenterById(getIt()),
                    getRenterByEmail: GetRenterByEmailUsecase(getIt()),
                    getAllRenters: GetAllRentersUsecase(getIt()),
                  )..add(GetRenterByIdEvent(widget.car.renterId)),
                  child: RenterProfile(renterId: widget.car.renterId),
                ),
                SizedBox(width: 20),

                // car lists of current provider
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/maps-details',
                        arguments: widget.car,
                      );
                    },
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: Color(0xffF3F3F3),
                        image: DecorationImage(
                          image: AssetImage('assets/maps.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Transform.scale(
                          scale: _animation!.value,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/maps.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                RenterCarsList(
                  renterId: widget.car.renterId,
                  currentCarId: widget.car.id,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AboutCard extends StatefulWidget {
  final Car car;

  const AboutCard({super.key, required this.car});

  @override
  State<AboutCard> createState() => _AboutCardState();
}

class _AboutCardState extends State<AboutCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Color(0xffF3F3F3),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: widget.car.imageUrl,
                  height: 210,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              widget.car.model,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/gps.png', width: 40, height: 40),
                    SizedBox(width: 4),
                    Text(
                      '${widget.car.distance.toStringAsFixed(0)} km',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 15),
                    Image.asset('assets/pump.png', width: 40, height: 40),
                    SizedBox(width: 4),
                    Text(
                      '${widget.car.fuelCapacity.toStringAsFixed(0)} L',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    '\$ ${widget.car.pricePerHour.toStringAsFixed(0)}/h',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4),
          Container(
            width: screenWidth * 0.4,
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xff212020),
              gradient: LinearGradient(
                colors: [Color(0xff212020), Colors.teal],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.6],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/checkout');
              },
              child: Center(
                child: Text(
                  'Book Now',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RenterProfile extends StatefulWidget {
  final String renterId;

  const RenterProfile({super.key, required this.renterId});

  @override
  State<RenterProfile> createState() => _RenterProfileState();
}

class _RenterProfileState extends State<RenterProfile> {
  @override
  void initState() {
    super.initState();
    // Trigger the event to load renter data
    context.read<RenterBloc>().add(GetRenterByIdEvent(widget.renterId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RenterBloc, RenterState>(
      listener: (context, state) {
        if (state is RenterError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is RenterLoading) {
          return _buildLoadingState();
        }

        if (state is RenterError) {
          return _buildErrorState(state.message);
        }

        if (state is RenterLoaded) {
          return _buildRenterInfo(state.renter);
        }

        return _buildInitialState();
      },
    );
  }

  Widget _buildRenterInfo(Renter renter) {
    debugPrint('Renter data received:');
    debugPrint('ID: ${renter.id}');
    debugPrint('Name: ${renter.name}');
    debugPrint('Email: ${renter.email}');
    debugPrint('Phone: ${renter.phone}');
    debugPrint('Image URL: ${renter.imageUrl}');
    debugPrint('Price per hour: ${renter.pricePerHour}');
    debugPrint('Location: ${renter.location}');

    return Expanded(
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xffF3F3F3),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: renter.imageUrl.isNotEmpty
                    ? NetworkImage(renter.imageUrl) as ImageProvider
                    : const AssetImage('assets/user.png'),
              ),
              const SizedBox(height: 10),
              Text(
                renter.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              if (renter.phone != null && renter.phone!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    renter.phone!,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              if (renter.pricePerHour != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '\$${renter.pricePerHour!.toStringAsFixed(2)}/hr',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Expanded(
      child: Center(child: CircularProgressIndicator(color: Colors.teal)),
    );
  }

  Widget _buildErrorState(String message) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            Text(
              'Error: $message',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                context.read<RenterBloc>().add(
                  GetRenterByIdEvent(widget.renterId),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return const Expanded(
      child: Center(child: Text('No renter information available')),
    );
  }
}


// provider