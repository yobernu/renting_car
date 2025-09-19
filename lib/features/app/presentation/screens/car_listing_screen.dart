import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renting_car/features/app/presentation/bloc_provider/bloc_events.dart';
import 'package:renting_car/features/app/presentation/bloc_provider/bloc_states.dart';
import 'package:renting_car/features/app/presentation/bloc_provider/car_bloc.dart';
import 'package:renting_car/features/app/presentation/helpers/car_card.dart';

class CarListingScreen extends StatefulWidget {
  const CarListingScreen({super.key});

  @override
  State<CarListingScreen> createState() => _CarListingScreenState();
}

class _CarListingScreenState extends State<CarListingScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint('🔵 CarListingScreen - initState');
    // Load cars when the screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🔄 CarListingScreen - Dispatching GetAllCarsEvent');
      context.read<CarBloc>().add(GetAllCarsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final carBloc = BlocProvider.of<CarBloc>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextButton(
          onPressed: () => carBloc.add(GetAllCarsEvent()),
          child: Text(
            'Phos Motors',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [Color(0xff212020), Colors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1.0],
                ).createShader(Rect.fromLTWH(0, 0, 200, 200)),
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => carBloc.add(GetAllCarsEvent()),
          ),
        ],
      ),
      body: BlocConsumer<CarBloc, CarState>(
        listener: (context, state) {
          if (state is CarsError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          debugPrint(
            '🔄 CarListingScreen - State changed: ${state.runtimeType}',
          );

          if (state is CarsLoading) {
            debugPrint('⏳ CarListingScreen - Loading cars...');
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CarsLoaded) {
            debugPrint('✅ CarListingScreen - Loaded ${state.cars.length} cars');
            return RefreshIndicator(
              onRefresh: () async {
                carBloc.add(GetAllCarsEvent());
                await carBloc.stream.firstWhere((s) => s is! CarsLoading);
              },
              child: ListView(
                children: [
                  const MySliderPage(),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Available Cars',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (state.cars.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No cars available at the moment.'),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.cars.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 0.75,
                          ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemBuilder: (context, index) {
                        final car = state.cars[index];
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/car-details',
                            arguments: car,
                          ),
                          child: CarCard(car: car),
                        );
                      },
                    ),
                ],
              ),
            );
          }

          // Error state
          if (state is CarsError) {
            debugPrint('❌ CarListingScreen - Error: ${state.message}');
          } else {
            debugPrint(
              '❓ CarListingScreen - Unexpected state: ${state.runtimeType}',
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load cars'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    debugPrint('🔄 CarListingScreen - Retry loading cars');
                    carBloc.add(GetAllCarsEvent());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MySliderPage extends StatelessWidget {
  const MySliderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView(
        children: <Widget>[
          BannerCard(
            imageUrl: 'assets/car_image.png',
            discountText: 'Welcome Discount',
          ),
          BannerCard(
            imageUrl: 'assets/white_car.png',
            discountText: 'Welcome Discount',
          ),
          BannerCard(
            imageUrl: 'assets/car_image.png',
            discountText: 'Welcome Discount',
          ),
        ],
      ),
    );
  }
}

class BannerCard extends StatelessWidget {
  final String imageUrl;
  final String discountText;

  const BannerCard({
    super.key,
    required this.imageUrl,
    required this.discountText,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.all(16.0),
      height: screenWidth * 0.5, // Responsive height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Image.asset(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: _AnimatedDiscountButton(text: discountText),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedDiscountButton extends StatefulWidget {
  final String text;

  const _AnimatedDiscountButton({required this.text});

  @override
  State<_AnimatedDiscountButton> createState() =>
      _AnimatedDiscountButtonState();
}

class _AnimatedDiscountButtonState extends State<_AnimatedDiscountButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(2.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        height: 40,
        width: screenWidth * 0.36,
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(4),
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
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
