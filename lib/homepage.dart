//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:weather/api/weather_model.dart';
import 'package:weather/api/weather_repo.dart';
import 'package:weather/bloc/app_bloc.dart';
part 'location_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    final _searchController = TextEditingController();
    late String humidityComment;
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.yellow,
                  Colors.orange,
                ]
            ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Weather App - BloC'),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    weatherBloc
                  ..add(LoadCurrentWeather(lat: _currentPosition!.latitude, lon: _currentPosition!.longitude));
                    },
                  icon: const Icon(Icons.location_on_outlined,
                  ))
            ],
          ),
          resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Container(

                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    FutureBuilder<void>(
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if(snapshot.connectionState == ConnectionState.done){
                          return Row(
                            children: [
                              Expanded(
                                child: Text('Address :'),
                              ),
                              Expanded(
                                child: Text('${_currentAddress ?? ""}'),
                              ),
                            ],
                          );

                        }else if(snapshot.connectionState == ConnectionState.waiting){
                          return Text("loading ...");
                        }
                        return Text('loading...');
                      },


                      // Future that needs to be resolved
                      // inorder to display something on the Canvas
                      future: _getCurrentPosition(),
                    ),

                    /*
                    Row(
                      children: [
                        Container(
                          child: Text('Address :'),
                        ),
                        Container(
                          child: Text('${_currentAddress ?? ""}'),
                        ),
                      ],
                    ),

                     */
                            SizedBox(height: 20),

                            // BlocBuilder
                            BlocBuilder<WeatherBloc, WeatherState>(
                            builder: (context, state){
                            if(state is CurrentWeatherLoaded) {
                            if(state.getWeather.main.humidity <=55 ) {
                            humidityComment = 'Dry & Normal';
                            } else if (state.getWeather.main.humidity >55 && state.getWeather.main.humidity <=65 ) {
                            humidityComment = 'Slightly Uncomfortable';
                            } else if (state.getWeather.main.humidity >65 ) {
                            humidityComment = 'Very Uncomfortable';
                            }
                            return Container(
                            child: Column(
                            children: [
                            Container(
                            child: Text('Todays Report',
                            style: TextStyle(
                            fontSize: 30,
                            color: Colors.blueAccent,
                            ),
                            ),
                            ),
                            SizedBox(height: 30),
                            Row(
                            children: [
                            Expanded(child: Text('Temperature')),
                            Expanded(child: Text('Minimum Temperature')),
                            Expanded(child: Text('Maximum Temperature')),
                            ],
                            ),
                            SizedBox(height: 15),
                            Row(
                            children: [
                            Expanded(child: Text(state.getWeather.main.temp.toString())),
                            Expanded(child: Text(state.getWeather.main.tempMin.toString())),
                            Expanded(child: Text(state.getWeather.main.tempMax.toString())),
                            ],
                            ),

                            Row(
                            children: [
                            Expanded(
                            flex: 3,
                            child: SfRadialGauge(
                            axes: <RadialAxis>[
                            RadialAxis(minimum: 0, maximum: 100,
                            ranges: <GaugeRange>[
                            GaugeRange(startValue: 0, endValue: 55, color:Colors.green),
                            GaugeRange(startValue: 55,endValue: 65,color: Colors.orange),
                            GaugeRange(startValue: 65,endValue: 100,color: Colors.red)],
                            pointers: <GaugePointer>[
                            NeedlePointer(value: state.getWeather.main.humidity.toDouble())],
                            annotations: <GaugeAnnotation>[
                            GaugeAnnotation(widget: Container(child:
                            Text(state.getWeather.main.humidity.toString(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                            angle: 90, positionFactor: 0.5
                            )]
                            )]),
                            ),
                            Spacer(),
                            Expanded(child: Text(humidityComment), flex: 2,),
                            ],
                            ),

                            ],
                            ),
                            );
                            }else if(state is WeatherNotLoaded){
                            return Text('Find out the weather of your current location or anywehere else in the world!');
                            } else if(state is CurrentWeatherLoading) {
                            return CircularProgressIndicator();
                            }
                            else {
                            return Text('');
                            }

                            }
                            ),



                            BlocBuilder<WeatherBloc, WeatherState>(
                            builder: (context, state){
                            if(state is SearchWeatherLoaded) {
                            if(state.getWeatherFromCity.main.humidity <=55 ) {
                            humidityComment = 'Dry & Normal';
                            } else if (state.getWeatherFromCity.main.humidity >55 && state.getWeatherFromCity.main.humidity <=65 ) {
                            humidityComment = 'Slightly Uncomfortable';
                            } else if (state.getWeatherFromCity.main.humidity >65 ) {
                            humidityComment = 'Very Uncomfortable';
                            }
                            return Container(
                            child: Column(
                            children: [
                            Container(
                            child: Text('Todays Report',
                            style: TextStyle(
                            fontSize: 30,
                            color: Colors.blueAccent,
                            ),
                            ),
                            ),
                            SizedBox(height: 30),
                            Row(
                            children: [
                            Expanded(child: Text('Temperature')),
                            Expanded(child: Text('Minimum Temperature')),
                            Expanded(child: Text('Maximum Temperature')),
                            ],
                            ),
                            SizedBox(height: 15),
                            Row(
                            children: [
                            Expanded(child: Text(state.getWeatherFromCity.main.temp.toString())),
                            Expanded(child: Text(state.getWeatherFromCity.main.tempMin.toString())),
                            Expanded(child: Text(state.getWeatherFromCity.main.tempMax.toString())),
                            ],
                            ),

                            Row(
                            children: [
                            Expanded(
                            flex: 3,
                            child: SfRadialGauge(
                            axes: <RadialAxis>[
                            RadialAxis(minimum: 0, maximum: 100,
                            ranges: <GaugeRange>[
                            GaugeRange(startValue: 0, endValue: 55, color:Colors.green),
                            GaugeRange(startValue: 55,endValue: 65,color: Colors.orange),
                            GaugeRange(startValue: 65,endValue: 100,color: Colors.red)],
                            pointers: <GaugePointer>[
                            NeedlePointer(value: state.getWeatherFromCity.main.humidity.toDouble())],
                            annotations: <GaugeAnnotation>[
                            GaugeAnnotation(widget: Container(child:
                            Text(state.getWeatherFromCity.main.humidity.toString(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                            angle: 90, positionFactor: 0.5
                            )]
                            )]),
                            ),
                            Spacer(),
                            Expanded(child: Text(humidityComment), flex: 2,),
                            ],
                            )
                            ],
                            ),
                            );
                            }else if(state is WeatherNotLoaded){
                            return Text('');
                            } else if(state is SearchWeatherLoading) {
                            return CircularProgressIndicator();
                            }
                            else {
                            return Text('');
                            }
                            }
                            ),

                            TextField(
                            controller: _searchController,
                            ),

                    ElevatedButton(
                      onPressed: () {
                        weatherBloc
                          ..add(LoadSearchWeather(cityName: _searchController.text));
                      },
                      child: const Icon(Icons.search_sharp),
                    ),

                  ],
                ),
              ),
            ),
          ),
      ),
      );

  }
}




