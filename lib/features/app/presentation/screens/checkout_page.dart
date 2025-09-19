import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 320),
            Padding(
              padding: EdgeInsets.all(40),
              child: Icon(
                Icons.hourglass_empty_outlined,
                size: 100,
                color: Colors.white38,
              ),
            ),
            Center(
              child: Text(
                'Checkout Page',
                style: TextStyle(fontSize: 24, color: Colors.white38),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Coming soon',
                style: TextStyle(fontSize: 24, color: Colors.white38),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
