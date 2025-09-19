import 'package:flutter/material.dart';
import 'package:renting_car/features/app/domain/entities/car.dart';

class CarDetailsCard extends StatelessWidget {
  final Car car;
  const CarDetailsCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  car.model,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.directions_car, color: Colors.white, size: 16),
                    SizedBox(width: 5),
                    Text(
                      '> ${car.distance.toStringAsFixed(0)} km',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.battery_full, color: Colors.white, size: 16),
                    SizedBox(width: 5),
                    Text(
                      '> ${car.fuelCapacity.toStringAsFixed(0)} L',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Features',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  featureIcons(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.directions_car, color: Colors.black, size: 32),
                      SizedBox(width: 5),
                      Text(
                        "\$ ${car.pricePerHour} /day",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: Text(
                          'Book Now',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget featureIcons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      featureIcon(Icons.local_gas_station, 'Diesel', 'Common Rail'),
      featureIcon(Icons.speed, 'Acceleration', '0 - 200 km/h'),
      featureIcon(Icons.ac_unit, 'Air Condition', 'temp control'),
    ],
  );
}

Widget featureIcon(IconData icon, String title, String subtitle) {
  return Container(
    width: 100,
    height: 100,
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey, width: 1),
    ),
    child: Column(
      children: [
        Icon(icon, size: 28),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    ),
  );
}
