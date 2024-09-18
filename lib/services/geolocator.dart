import 'package:geolocator/geolocator.dart';

Future<Position> getLocation() async {
  // bool serviceEnabled
  LocationPermission permission;

  permission = await Geolocator.checkPermission();

  // checking if the permission is provided or not
  if (permission == LocationPermission.denied) {
    // Requesting for the permission
    permission = await Geolocator.requestPermission();

    // return error if permission is not provided
    if (permission == LocationPermission.denied) {
      return Future.error('Location permission are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    //   return error for always denied permission
    return Future.error(
        'Location permission are permanently denied, we cannot request permission.'
    );
  }

  // will return the data based on the position
  return await Geolocator.getCurrentPosition();
}
