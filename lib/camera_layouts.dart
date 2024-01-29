/* 
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'main.dart';

Widget buildPortraitLayout(_CameraAppState state) {
 
    return Column(
      children: [
        SizedBox(height: 20),
        Stack(
          children: [
            // Camera Preview
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: CameraPreview(controller),
            ),

            // Location Text
            if (currentLocation != null)
              Positioned(
                top: 16.0,
                left: 16.0,
                child: Text(
                  'Location: ${currentLocation!.latitude}, ${currentLocation!.longitude}',
                  style: TextStyle(color: Colors.white),
                ),
              ),

            // Switch Camera Button
            Positioned(
              bottom: 16.0,
              right: 130,
              child: ElevatedButton(
                onPressed: () => _switchCameraToggle(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 255, 240, 156),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      selectedCameraIndex == 0
                          ? Icons.camera_rear
                          : selectedCameraIndex == 1
                              ? Icons.camera_front
                              : Icons.camera,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text(
                      selectedCameraIndex == 0
                          ? 'Main'
                          : selectedCameraIndex == 1
                              ? 'Front'
                              : '0.5x',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(8),
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(255, 93, 136, 255),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _captureAndSave(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 0, 0, 0), // Text color
                ),
                child: Icon(Icons.party_mode, color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () => _viewRecentPictures(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple,
                ),
                child: Icon(Icons.photo_library, color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }


Widget buildLandscapeLayout(_CameraAppState state) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: const Color.fromARGB(
                    255, 255, 255, 255), // Set border color
                width: 10.0, // Set border width
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CameraPreview(controller),
            ),
          ),
        ),
        Container(
          width: 135,
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color.fromARGB(0, 255, 0, 0), // Set border color
              width: 10.0, // Set border width
            ),
            color: Color.fromARGB(255, 149, 165, 254),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _switchCameraToggle(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.green, // Text color
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      selectedCameraIndex == 0
                          ? Icons.camera_rear
                          : selectedCameraIndex == 1
                              ? Icons.camera_front
                              : Icons.camera,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text(
                      selectedCameraIndex == 0
                          ? 'Main'
                          : selectedCameraIndex == 1
                              ? 'Front'
                              : '0.5x',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 50),
              ElevatedButton(
                onPressed: () => _captureAndSave(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      const Color.fromARGB(255, 0, 0, 0), // Text color
                ),
                child: Icon(Icons.party_mode_outlined, color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () => _requestPhotoLibraryPermission(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple,
                ),
                child: Icon(Icons.photo_library, color: Colors.white),
              ),

              // Add more buttons or widgets as needed
            ],
          ),
        ),
      ],
    );
}
 */