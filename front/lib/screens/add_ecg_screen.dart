import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


class AddECGScreen extends StatefulWidget {
  final CameraDescription camera;

  const AddECGScreen({super.key, required this.camera});

  @override
  _AddECGScreenState createState() => _AddECGScreenState();
}


class _AddECGScreenState extends State<AddECGScreen> {
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
      body: SingleChildScrollView(
        child: Center(
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
              SizedBox(
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
                child: const Text("Confirmer la photo"),
              ),
              const SizedBox(height: 20),
              _selectedImage != null
                  ? Image.file(_selectedImage!)
                  : const Text("Merci de choisir une photo"),
              const SizedBox(height: 20)
            ],
          ),
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
      //print("Erreur lors de la prise de la photo: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}