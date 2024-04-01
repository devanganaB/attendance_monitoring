import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  // final String userEmail;

  const CameraScreen({Key? key}) : super(key: key);

  // , required this.userEmail

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;

  final ImagePicker picker = ImagePicker();
  File? imageFile;

  File? imagePreview;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  //initializing camera
  Future<void> _initializeCamera() async {
    // if (await Permission.camera.request().isGranted) {
    try {
      cameras = await availableCameras();

      if (cameras!.isNotEmpty) {
        _cameraController = CameraController(cameras![0], ResolutionPreset.max,
            imageFormatGroup: ImageFormatGroup.yuv420);

        await _cameraController!.initialize();
      } else {
        print("no cameras available");
      }
    } catch (e, stackTrace) {
      print("Error initializing camera: $e");
      print("Stack Trace: $stackTrace");
    }
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  //capture image using camera
  Future<void> _captureImage() async {
    if (!_cameraController!.value.isInitialized) {
      await _initializeCamera();
    }

    if (_cameraController!.value.isInitialized) {
      try {
        XFile capturedImage = await _cameraController!.takePicture();
        setState(() {
          imageFile = File(capturedImage.path);
        });
      } catch (e) {
        print("Error capturing image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera')),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_cameraController != null &&
                _cameraController!.value.isInitialized)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  child: _cameraPreviewWidget(),
                ),
              ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _captureImage();
                  },
                  child: Text('Click Image of Notes'),
                ),
              ],
            ),
            if (imageFile != null) ...[
              SizedBox(height: 16),
              _capturedImagePreviewWidget(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return CircularProgressIndicator(); // Or any loading indicator
    }

    return AspectRatio(
      aspectRatio: _cameraController!.value.aspectRatio,
      child: CameraPreview(_cameraController!),
    );
  }

  Widget _capturedImagePreviewWidget() {
    return Column(
      children: [
        Image.file(imageFile!),
        SizedBox(height: 16),
        Text('Preview of Captured Image'),
      ],
    );
  }
}
