import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:location/location.dart' as location_package;
import 'permission_page.dart';
import 'package:animations/animations.dart';

// import 'package:image/image.dart' as img;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PermissionPage(),
    );
  }
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class RecentPicturesPage extends StatelessWidget {
  final List<String> recentPictures;

  RecentPicturesPage({required this.recentPictures});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Pictures'),
      ),
      body: ListView.builder(
        itemCount: recentPictures.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Picture ${index + 1}'),
            // You can display the image here using Image.network or Image.file
          );
        },
      ),
    );
  }
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  int selectedCameraIndex = 0;
  bool isCameraInitialized = false;
  List<String> recentPictures = [];
  late Timer _locationTimer;
  location_package.Location location = location_package.Location();
  location_package.LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    _initializeCamera(selectedCameraIndex);
    _requestLocationPermission();
  }

  @override
  void dispose() {
    _locationTimer.cancel();
    controller.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera(int cameraIndex) async {
    try {
      final cameras = await availableCameras();
      controller = CameraController(cameras[cameraIndex], ResolutionPreset.max);

      await controller.initialize();
      if (mounted) {
        setState(() {
          isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _requestLocationPermission() async {
    var status = await permission_handler.Permission.location.status;

    if (status == permission_handler.PermissionStatus.granted) {
      _updateLocation();
      // Start the timer to update location every half a second
      _locationTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
        _updateLocation();
      });
    } else {
      // Handle permission denial
    }
  }

  void _updateLocation() async {
    try {
      location_package.LocationData newLocation =
          await location_package.Location().getLocation();
      setState(() {
        currentLocation = newLocation;
        // Update UI with the new location information
      });
    } catch (e) {
      // Handle location retrieval errors
      print("Error getting location: $e");
    }
  }

  Future<void> _captureAndSave() async {
    try {
      XFile file = await controller.takePicture();
      await GallerySaver.saveImage(file.path);

      // You can add additional logic here, such as displaying a confirmation message
      print('Picture saved to gallery');
    } catch (e) {
      print('Error capturing and saving picture: $e');
    }
  }

  /* void _switchToCamera(int cameraIndex) {
    selectedCameraIndex = cameraIndex;
    _initializeCamera(selectedCameraIndex);
  } */

  void _switchCameraToggle() {
    // Toggle between cameras
    selectedCameraIndex = (selectedCameraIndex + 1) % 3;
    _initializeCamera(selectedCameraIndex);
  }

  Future<void> _requestPhotoLibraryPermission() async {
    var photoLibraryStatus = await permission_handler.Permission.storage.status;

    if (photoLibraryStatus.isGranted) {
      // Photo library permission is already granted, proceed with your logic
      _viewRecentPictures();
    } else {
      // Request photo library permission asynchronously
      var result = await permission_handler.Permission.storage.request();

      if (result.isGranted) {
        // Permission granted, proceed with your logic
        _viewRecentPictures();
      } else {
        // Handle the case where photo library permission is denied
      }
    }
  }

  void _viewRecentPictures() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Recent Pictures'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: recentPictures.length,
              itemBuilder: (context, index) {
                String imagePath = recentPictures[index];
                return ListTile(
                  title: Text('Picture ${index + 1}'),
                  // Display the image using Image.file
                  leading: Image.file(
                    File(imagePath),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /* Future<location_package.LocationData?> _getLocation() async {
    final location = location_package.Location();
    try {
      return await location.getLocation();
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  } */

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > constraints.maxHeight) {
              // Landscape
              return _buildLandscapeLayout();
            } else {
              // Portrait
              return _buildPortraitLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout() {
    Color primaryColor = const Color.fromARGB(255, 0, 0, 0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SafeArea(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              // Camera Preview
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: primaryColor,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CameraPreview(controller),
                ),
              ),

              // Grid Overlay
              Positioned.fill(
                child: CustomPaint(
                  painter: GridPainter(),
                ),
              ),

              // Location Text
              if (currentLocation != null)
                Positioned(
                  top: 16.0,
                  left: 16.0,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Location: ${currentLocation!.latitude}, ${currentLocation!.longitude}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

              // Switch Camera Button
              Positioned(
                bottom: 16.0,
                child: ElevatedButton(
                  onPressed: () => _switchCameraToggle(),
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selectedCameraIndex == 0
                            ? Icons.camera_rear
                            : selectedCameraIndex == 1
                                ? Icons.camera_front
                                : Icons.camera,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      SizedBox(width: 8),
                      Text(
                        selectedCameraIndex == 0
                            ? 'Main'
                            : selectedCameraIndex == 1
                                ? 'Front'
                                : '0.5x',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _captureAndSave(),
          style: ElevatedButton.styleFrom(
            primary: primaryColor.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color:
                    const Color.fromARGB(255, 255, 254, 254).withOpacity(0.8),
                width: 2.0,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 45, // Adjust the size as needed
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    Color primaryColor = const Color.fromARGB(255, 0, 0, 0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SafeArea(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                // Camera Preview
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: primaryColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CameraPreview(controller),
                  ),
                ),

                // Grid Overlay
                Positioned.fill(
                  child: CustomPaint(
                    painter: GridPainter(),
                  ),
                ),

                // Location Text
                if (currentLocation != null)
                  Positioned(
                    top: 16.0,
                    left: 16.0,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Location: ${currentLocation!.latitude}, ${currentLocation!.longitude}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                // Switch Camera Button
                Positioned(
                  bottom: 16.0,
                  child: ElevatedButton(
                    onPressed: () => _switchCameraToggle(),
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          selectedCameraIndex == 0
                              ? Icons.camera_rear
                              : selectedCameraIndex == 1
                                  ? Icons.camera_front
                                  : Icons.camera,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        SizedBox(width: 8),
                        Text(
                          selectedCameraIndex == 0
                              ? 'Main'
                              : selectedCameraIndex == 1
                                  ? 'Front'
                                  : '0.5x',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 20),
        Container(
          width: 100,
          child: ElevatedButton(
            onPressed: () => _captureAndSave(),
            style: ElevatedButton.styleFrom(
              primary: primaryColor.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color:
                      const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                  width: 2.0,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 45, // Adjust the size as needed
                ),
                SizedBox(width: 5),
              ],
            ),
          ),
        ),
        SizedBox(width: 20),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(1.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final double cellWidth = size.width / 3;
    final double cellHeight = size.height / 3;

    for (int i = 1; i < 3; i++) {
      final double x = cellWidth * i;
      final double y = cellHeight * i;

      // Draw vertical line
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);

      // Draw horizontal line
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
