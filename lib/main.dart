import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/app_bloc.dart';
import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (BuildContext context) => WeatherBloc(),
        child: HomePage(),
      )
    );
  }
}

