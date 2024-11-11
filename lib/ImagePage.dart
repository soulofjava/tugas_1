// ignore_for_file: file_names, use_super_parameters

import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Page'),
      ),
      body: Center(
        child: Image.asset('lib/assets/koi.jpg'), // Display the image from assets
      ),
    );
  }
}
