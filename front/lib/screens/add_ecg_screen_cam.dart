import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MainApp(camera: firstCamera));
}

class MainApp extends StatelessWidget {
  final CameraDescription camera;

  const MainApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImagePickerWidget(camera: camera),
    );
  }
}

class ImagePickerWidget extends StatefulWidget {
  final CameraDescription camera;

  const ImagePickerWidget({Key? key, required this.camera}) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  late CameraController _controller;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.ultraHigh,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              color: Colors.grey,
              child: const Text(
                "Prendre une photo",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                // Prendre une photo lorsque le bouton est appuyé
                takePicture();
              },
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width, // largeur de l'écran
              height: MediaQuery.of(context).size.width / _controller.value.aspectRatio, // hauteur de la fenêtre de prévisualisation
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: CameraPreview(_controller),
              ),
            ),
                        ElevatedButton(
              onPressed: _selectedImage != null ? () {
                // Naviguer vers l'écran suivant lorsque le bouton est appuyé
              } : null,
              child: Text("Next"),
            ),
            const SizedBox(height: 20),
            _selectedImage != null
                ? Image.file(_selectedImage!)
                : const Text("Merci de choisir une photo"),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Future<void> takePicture() async {
    try {
      final XFile picture = await _controller.takePicture();
      setState(() {
        _selectedImage = File(picture.path);
      });
    } catch (e) {
      print("Erreur lors de la prise de la photo: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
