import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CameraScreen extends StatefulWidget {
  final String userEmail;

  const CameraScreen({Key? key, required this.userEmail}) : super(key: key);

  //

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;

  final ImagePicker picker = ImagePicker();
  File? imageFile;

  File? imagePreview;

  bool isImageCaptured = false;

  String imageUrl = '';
  String currentuserId = FirebaseAuth.instance.currentUser!.uid;
  Reference ref = FirebaseStorage.instance.ref();
  final timestamp = DateTime.now().microsecondsSinceEpoch;

  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _openCamera();

    // _initializeCamera();
    // _captureImage();
  }

  // Initialize camera and start preview
  Future<void> _openCamera() async {
    if (await Permission.camera.request().isGranted) {
      try {
        cameras = await availableCameras();

        if (cameras!.isNotEmpty) {
          _cameraController = CameraController(
              cameras![0], ResolutionPreset.max,
              imageFormatGroup: ImageFormatGroup.yuv420);

          await _cameraController!.initialize();

          setState(() {}); // Trigger rebuild after camera initialized
        } else {
          print("No cameras available");
        }
      } catch (e) {
        print("Error initializing camera: $e");
      }
    } else {
      print("Permission Denied");
    }
  }

  // Capture image
  Future<void> _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile capturedImage = await _cameraController!.takePicture();
        setState(() {
          imageFile = File(capturedImage.path);
          isImageCaptured = true;
        });
      } catch (e) {
        print("Error capturing image: $e");
      }
    }
  }

  Future<void> _recaptureImage() async {
    setState(() {
      imageFile = null; // Reset image file
      isImageCaptured = false; // Update flag to indicate no image capture
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _uploadImageToFirebase(File imageFile) async {
    // for progress indicator
    setState(() {
      isUploading = true;
    });

    try {
      // Create a reference to the Firebase Storage location
      Reference storage =
          ref.child('images/${widget.userEmail}.jpg/$timestamp');

      // Upload the image file to Firebase Storage
      await storage.putFile(imageFile);

      imageUrl = await storage.getDownloadURL();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded')),
      );
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Documents')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!isImageCaptured &&
                  _cameraController != null &&
                  _cameraController!.value.isInitialized)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    child: _cameraPreviewWidget(),
                  ),
                ),
              SizedBox(height: 16),
              if (!isImageCaptured) // Show capture button only if no image is captured
                ElevatedButton(
                  onPressed: _captureImage,
                  child: Text('Capture Image'),
                ),
              if (imageFile != null) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(imageFile!),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _recaptureImage,
                        child: const Text('Recapture'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          bool uploaded =
                              await _uploadImageToFirebase(imageFile!);
                          if (uploaded) {
                            // Show the image URL below the preview image
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Image uploaded')),
                            );
                            setState(() {
                              imageUrl =
                                  imageUrl; // Set imageUrl to trigger rebuild
                            });
                          }
                        },
                        child: const Text('Upload'),
                      ),
                    ],
                  ),
                ),
                if (imageUrl.isNotEmpty) // Show image URL if available
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text('Uploaded Image:'),
                        // Preview of the uploaded image
                        Image.network(
                          imageUrl,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const CircularProgressIndicator(); // Or any loading indicator
    }

    return AspectRatio(
      aspectRatio: _cameraController!.value.aspectRatio,
      child: CameraPreview(_cameraController!),
    );
  }
}
