import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _showWelcomePopup(context);
    });
  }

  void _showWelcomePopup(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text("Ajout d'ECG"),
        content: Text("Merci de garantir l'anonymat du patient, en prenant une photo qui ne présente aucune information personnelle"),
        actions: <Widget>[
          BasicDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            title: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un ECG"),
      ),
      body: _controller.value.isInitialized
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _takePicture();
            },
            icon: Icon(Icons.camera_alt),
            label: Text(
              "Prendre une photo",
              style: TextStyle(fontSize: 20),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.blueAccent; // Couleur au survol
                  }
                  return Colors.blue; // Couleur par défaut
                },
              ),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Couleur du texte
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(10)), // Espacement intérieur du bouton
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0), // Bord arrondi
                  // Facultatif : ajoute une ombre au bouton
                  side: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de la prise de photo"),
        ),
      );
    }
  }

  Future<void> _cropImage() async {
    if (_selectedImage != null) {
      File? cropped = await ImageCropper().cropImage(
        sourcePath: _selectedImage!.path,
      );

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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Aucune image sélectionnée"),
          ),
        );
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
  static const double imageSize = 300;

  const PhotoPreviewPage({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aperçu de la photo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: imageSize,
              width: imageSize,
              child: Image.file(imageFile, fit: BoxFit.cover),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Sexe',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Groupe Sanguin',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddInfoPage(imageFile: imageFile),
                  ),
                );
              },
              child: Text("Ajouter des tags"),
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
        child: Text("Ajoutez ici des informations sur l'ECG"),
      ),
    );
  }
}
// ici ca renvoi sur une page a la con a toi de renvoyer sur les tags du coup chef