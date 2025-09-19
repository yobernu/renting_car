import 'package:flutter/material.dart';
import 'package:renting_car/features/app/domain/entities/car.dart';

class MoreCard extends StatelessWidget {
  final Car car;

  const MoreCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/car-details', arguments: car);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xff212020),
          gradient: LinearGradient(
            colors: [Color(0xff212020), Colors.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.3, 1.0],
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
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car.model,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
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
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
