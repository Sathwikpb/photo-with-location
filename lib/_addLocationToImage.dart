/* import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:location/location.dart' as location_package;

location_package.Location location = location_package.Location();
location_package.LocationData? currentLocation;

Future<void> _addLocationToImage(String imagePath) async {
  if (currentLocation != null) {
    final file = File(imagePath);
    final image = img.decodeImage(file.readAsBytesSync())!;

    // Add location information to the image's EXIF data
    final gpsInfo = _createGpsInfo(currentLocation!);

    // Set the GPS information in the EXIF data
    final exifData = img.ExifData();
    exifData.setGpsTags(gpsInfo);

    // Create a copy of the original image with the modified EXIF data
    final modifiedImage = img.Image.from(image);
    modifiedImage.exifData = exifData;

    // Save the modified image
    file.writeAsBytesSync(img.encodeJpg(modifiedImage));
  }
}

List<int> _createGpsInfo(location_package.LocationData location) {
  final latitude = location.latitude!;
  final longitude = location.longitude!;

  final latAbs = latitude.abs();
  final lonAbs = longitude.abs();

  final latDegrees = latAbs.toInt();
  final latMinutes = ((latAbs - latDegrees) * 60).toInt();
  final latSeconds = ((((latAbs - latDegrees) * 60) - latMinutes) * 60).toInt();

  final lonDegrees = lonAbs.toInt();
  final lonMinutes = ((lonAbs - lonDegrees) * 60).toInt();
  final lonSeconds = ((((lonAbs - lonDegrees) * 60) - lonMinutes) * 60).toInt();

  final latRef = latitude >= 0 ? 'N' : 'S';
  final lonRef = longitude >= 0 ? 'E' : 'W';

  final latRational = _createRational(latDegrees, latMinutes, latSeconds);
  final lonRational = _createRational(lonDegrees, lonMinutes, lonSeconds);

  return [
    0x02, 0x02, 0x00, 0x00,
    latRational[0], latRational[1], 0x00, 0x00,
    0x02, 0x04, 0x00, 0x00,
    latRational[2], latRational[3], 0x00, 0x00,
    0x01, latRef.codeUnitAt(0), 0x00, 0x00,
    0x04, 0x04, 0x00, 0x00,
    lonRational[0], lonRational[1], 0x00, 0x00,
    0x02, 0x04, 0x00, 0x00,
    lonRational[2], lonRational[3], 0x00, 0x00,
    0x01, lonRef.codeUnitAt(0), 0x00, 0x00,
  ];
}

List<int> _createRational(int degrees, int minutes, int seconds) {
  final rationalList = <int>[];

  final rationalDegrees = Uint16List.fromList([degrees, 1]);
  final rationalMinutes = Uint16List.fromList([minutes, 1]);
  final rationalSeconds = Uint16List.fromList([seconds, 1]);

  rationalList.addAll(rationalDegrees.buffer.asUint8List());
  rationalList.addAll(rationalMinutes.buffer.asUint8List());
  rationalList.addAll(rationalSeconds.buffer.asUint8List());

  return rationalList;
}
 */