/* // recent_pictures_page.dart
import 'package:flutter/material.dart';

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
 */