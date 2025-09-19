import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renting_car/features/app/presentation/bloc_provider/bloc_events.dart';
import 'package:renting_car/features/app/presentation/bloc_provider/car_bloc.dart';
import 'package:renting_car/features/app/presentation/navigation/navigation.dart';
import 'firebase_options.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CarBloc>()..add(GetAllCarsEvent()),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        onGenerateRoute: Navigation.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}
