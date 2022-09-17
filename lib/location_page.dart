part of 'homepage.dart';

String? _currentAddress;
Position? _currentPosition;

Future<bool> _handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are denied forever wtf');
  }
  return true;
}


Future<void> _getCurrentPosition() async {
  final hasPermission = await _handleLocationPermission();

  if (!hasPermission) return;
  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      .then((Position position) {
    _currentPosition = position;
    _getAddressFromLatLng(_currentPosition!);
  }).catchError((e) {
    debugPrint(e);
  });
}

Future<void> _getAddressFromLatLng(Position position) async {
  await placemarkFromCoordinates(
      _currentPosition!.latitude, _currentPosition!.longitude)
      .then((List<Placemark> placemarks) {
    Placemark place = placemarks[0];
      _currentAddress =
      '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';

  }).catchError((e) {
    debugPrint(e);
  });
}


