import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_cropper/image_cropper.dart';

class AddECGScreen extends StatefulWidget {
  final CameraDescription camera;

  const AddECGScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _AddECGScreenState createState() => _AddECGScreenState();
}

class _AddECGScreenState extends State<AddECGScreen> {
  late CameraController _controller;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.ultraHigh,
    );
    await _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Expanded(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              _takePicture();
            },
            icon: Icon(Icons.camera_alt),
            label: Text(
              "Prendre une photo",
              style: TextStyle(fontSize: 20), // Ajustez la taille du texte selon vos besoins
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24), // Ajustez les marges intérieures du bouton
              minimumSize: Size(200, 48), // Définissez la taille minimale du bouton
            ),
          ),
        ],
      )
          : Container(),
    );
  }

  Future<void> _takePicture() async {
    try {
      final XFile picture = await _controller.takePicture();
      setState(() {
        _selectedImage = File(picture.path);
        _cropImage();
      });
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  Future<void> _cropImage() async {
    if (_selectedImage != null) {
      File? cropped = await ImageCropper().cropImage(
          sourcePath: _selectedImage!.path);

      if (cropped != null) {
        setState(() {
          _selectedImage = File(cropped.path);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoPreviewPage(imageFile: _selectedImage!),
            ),
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class PhotoPreviewPage extends StatelessWidget {
  final File imageFile;
  static const double imageSize = 600; // Définissez la taille de l'image souhaitée

  const PhotoPreviewPage({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aperçu de la photo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(
              imageFile,
              width: imageSize,
              height: imageSize,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Age',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Sexe',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Groupe Sanguin',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddInfoPage extends StatelessWidget {
  final File imageFile;

  const AddInfoPage({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter des tags"),
      ),
      body: Center(
        child: Text("Ajoutez ici des tags"),
      ),
    );
  }
}
