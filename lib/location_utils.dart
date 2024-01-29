// location_utils.dart
import 'package:location/location.dart' as location_package;

class LocationUtils {
  static Future<location_package.LocationData?> getCurrentLocation() async {
    location_package.Location location = location_package.Location();
    try {
      return await location.getLocation();
    } catch (e) {
      // Handle location retrieval errors
      return null;
    }
  }
}
