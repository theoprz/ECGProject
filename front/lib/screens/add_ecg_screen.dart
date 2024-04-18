import 'dart:io';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

import '../classes/ECG_class.dart';
import '../main.dart';
import '../widgets/tag_selection_page.dart';

class AddECGScreen extends StatefulWidget {
  final CameraDescription camera;
  final Credentials credentials;

  const AddECGScreen({super.key, required this.camera, required this.credentials});

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
    await Future.delayed(const Duration(milliseconds: 300));
    await _controller.initialize();
    if (mounted) {
      setState(() {});
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomePopup(context);
    });
  }


  void _showWelcomePopup(BuildContext context) {
    if (!hasShownPopup) {
      showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: const Text("Attention"),
          content: const Text("Merci de garantir l'anonymat du patient, en prenant une photo ne présentant aucune information personnelle"),
          actions: <Widget>[
            BasicDialogAction(
              onPressed: () {
                Navigator.pop(context);
                hasShownPopup = true; // Set the flag to true after showing the popup
              },
              title: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //Bloquer la rotation de l'écran
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un ECG"),
      ),
      body: _controller.value.isInitialized
          ? Column(//REGLER LE PROBLEME D ETIREMENT DE L IMAGE
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: CameraPreview(_controller),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    _takePicture();
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Prendre une photo", style: TextStyle(fontSize: 20)),
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
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(10)), // Espacement intérieur du bouton
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0), // Bord arrondi
                  // Facultatif : ajoute une ombre au bouton
                  side: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
          ),
              const SizedBox(height: 20),
        ],
      )
          : const Center(
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
        const SnackBar(
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
              builder: (context) => PhotoPreviewPage(imageFile: _selectedImage!, credentials: widget.credentials),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Aucune image sélectionnée"),
            duration: Duration(seconds: 3),
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

class PhotoPreviewPage extends StatefulWidget {
  final File imageFile;
  final Credentials credentials;

  const PhotoPreviewPage({Key? key, required this.imageFile, required this.credentials}) : super(key: key);

  @override
  _PhotoPreviewPageState createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  String? _selectedSex;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final ageController = TextEditingController();
  String? _speedECG = '25';
  String? _gainECG = '10';
  String? _imageQuality;
  //TODO appliquer filtre anti injection sql sur les champs de texte

  // ** PARTIE SYMPTOMES **
  List<String> selectedSymptoms = [];

  void toggleSelection(String item) {
    setState(() {
      if (selectedSymptoms.contains(item)) {
        selectedSymptoms.remove(item);
      } else {
        selectedSymptoms.add(item);
      }
    });
  }

  //Widget pour les éléments sélectionnables
  Widget buildSelectableItem(String item) {
    bool isSelected = selectedSymptoms.contains(item);
    Color color = isSelected ? Colors.blue.shade300 : Colors.white;

    return GestureDetector(
      onTap: () => toggleSelection(item),
      child: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue.shade300, width: 2),
        ),
        child: Center(
          child: Text(
            item,
            style: TextStyle(color: color = !isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
// ** FIN PARTIE SYMPTOMES **

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aperçu de la photo"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Titre",
                labelText: "Titre",
              ),
              maxLength: 24,//Limite de caractères, potientiellement à ajuster
            ),
            const SizedBox(height: 2),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: "Contexte",
                labelText: "Contexte",
              ),
              maxLength: 400,//Limite de caractères, potientiellement à ajuster
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.51,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Image.file(widget.imageFile, fit: BoxFit.contain), // Change BoxFit.cover to BoxFit.contain
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  child: TextField(
                    controller: ageController,
                    decoration: const InputDecoration(
                      hintText: "Âge",
                      labelText: "Âge",
                    ),
                    keyboardType: TextInputType.number, //Clavier numérique
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], //Permet de filtrer les caractères pour n'avoir que des chiffres
                    maxLength: 3,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 30)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Sexe",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                      DropdownButton<String>(
                        hint: const Text('Sexe'),
                        value: _selectedSex,
                        items: <String>['Masculin', 'Féminin', 'Inconnu'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSex = newValue;
                          });
                        },
                     ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(left: 30)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Qualité de l'ECG",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    DropdownButton<String>(
                      hint: const Text('Qualité ECG'),
                      value: _imageQuality,
                      items: <String>['Mauvaise', 'Moyenne', 'Bonne', 'Très bonne'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _imageQuality = newValue;
                        });
                      },
                    ),
                ],
              ),

              ],
            ),

            const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

                const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Vitesse (mm/s)",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  DropdownButton<String>(
                    hint: const Text('Vitesse (mm/s)'),
                    value: _speedECG,
                    items: <String>['12.5', '25', '50', '100', '200'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _speedECG = newValue;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(width: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Gain (mm/mV)",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  DropdownButton<String>(
                    hint: const Text('Gain (mm/mV)'),
                    value: _gainECG,
                    items: <String>['5', '10', '20'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _gainECG = newValue;
                      });
                    },
                  ),
                ],
              ),
              ],
            ),
            const SizedBox(height: 20),
              Text("Symptômes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                height: 200, // Adjust this value as needed
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSelectableItem('Douleur thoracique'),
                        SizedBox(width: 8),
                        buildSelectableItem('Dyspnée'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSelectableItem('Palpitations'),
                        SizedBox(width: 8),
                        buildSelectableItem('Syncope'),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if(titleController.text.isEmpty || _imageQuality == null || _speedECG == null || _gainECG == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Veuillez entrer au moins un titre, la qualité de l'image, la vitesse et le gain de l'ECG"),
                    ),
                  );
                  return;
                }
                ECG tmpECG = ECG.withQualitySpeedGain(titleController.text, descriptionController.text, ageController.text.isEmpty ? 0 : int.parse(ageController.text), _selectedSex ?? "Inconnu", [], "0", _imageQuality ?? "Non renseignée", _speedECG ?? "0", _gainECG ?? "0", widget.imageFile, selectedSymptoms, widget.credentials.user.sub);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TagSelectionPage(ecg: tmpECG, credentials: widget.credentials),
                  ),
                );
                print(tmpECG);


                /*Ancien code de Paul, je garde pour le moment pour me souvenir de ce qu'il a fait
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddInfoPage(imageFile: widget.imageFile),
                  ),
                );
                */
              },
              child: const Text("Ajouter des tags"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.greenAccent; //Couleur quand le bouton est pressé
                    }
                    return Colors.green.shade300; //Couleur par défaut
                  },
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), //Couleur du texte
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(10)), //Espacement intérieur du bouton
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0), //Bord arrondi
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }




  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }


}

class AddInfoPage extends StatelessWidget {
  final File imageFile;

  const AddInfoPage({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter des tags"),
      ),
      body: const Center(
        child: Text("Ajoutez ici des informations sur l'ECG"),
      ),
    );
  }
}
// ici ca renvoi sur une page a la con a toi de renvoyer sur les tags du coup chef