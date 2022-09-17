

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/api/weather_repo.dart';
import 'package:equatable/equatable.dart';

import '../api/weather_model.dart';

@immutable
abstract class WeatherEvent {
  const WeatherEvent();
}

@immutable
class LoadCurrentWeather implements WeatherEvent {
  final double lat;
  final double lon;

  const LoadCurrentWeather({
    required this.lat,
    required this.lon,
  });
}

@immutable
class LoadSearchWeather implements WeatherEvent {
  final String cityName;

  const LoadSearchWeather({
    required this.cityName,
  });
}
@immutable
class ResetWeather implements WeatherEvent {

}

@immutable
abstract class WeatherState {
  const WeatherState();
}

@immutable
class SearchWeatherLoaded extends WeatherState {
  final _searchweather;
  const SearchWeatherLoaded(this._searchweather);

  List<Object> get props => [_searchweather];

  Welcome  get getWeatherFromCity => _searchweather;
}

@immutable
class CurrentWeatherLoading extends WeatherState {
  const CurrentWeatherLoading();
}

@immutable
class CurrentWeatherLoaded extends WeatherState {
  final _weather;
  const CurrentWeatherLoaded(this._weather);

  List<Object> get props => [_weather];

  Welcome  get getWeather => _weather;
}

@immutable
class SearchWeatherLoading extends WeatherState {
  const SearchWeatherLoading();
}

@immutable
class WeatherNotLoaded extends WeatherState {
  const WeatherNotLoaded();
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super (const WeatherNotLoaded()) {
    //handle LoadCurrentWeather event
  on<LoadCurrentWeather> ((event, emit) async {
    emit(const CurrentWeatherLoading());

      final weather = await getWeather(event.lat, event.lon);

      emit(CurrentWeatherLoaded(weather));
  });

  //handle LoadSearchWeather event

  on<LoadSearchWeather> ((event, emit) async {
    emit(const SearchWeatherLoading());

    final weather = await getWeatherFromCity(event.cityName);

    emit(SearchWeatherLoaded(weather));
  });

  }
}