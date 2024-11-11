// ignore_for_file: file_names, prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class OpenCamera extends StatefulWidget {
  const OpenCamera({super.key});

  @override
  OpenCameraState createState() => OpenCameraState();
}

class OpenCameraState extends State<OpenCamera> {
  late CameraController cameraController;

  int permissionStatus = 0;

  @override
  void initState() {
    super.initState();
    permissionInit();
  }

  permissionInit() async {
    await Permission.camera
        .onDeniedCallback(() {})
        .onGrantedCallback(() {
          setState(() {
            permissionStatus = 1;
          });
        })
        .onPermanentlyDeniedCallback(() {})
        .onRestrictedCallback(() {})
        .onLimitedCallback(() {})
        .onProvisionalCallback(() {})
        .request();
  }

  Future<CameraController> configCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.low);
    await cameraController.initialize();
    return cameraController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kamera'),
      ),
      body: permissionStatus == 1
          ? FutureBuilder<CameraController>(
              future: configCamera(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final controller = snapshot.data!;
                return CameraPreview(controller);
              },
            )
          : Center(
              child: Text('Permission denied!'),
            ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
