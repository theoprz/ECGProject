import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:front/screens/fullscreen_image.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classes/ECG_class.dart';
import '../widgets/TagDisplayer.dart';

class ECGDetailsPage extends StatelessWidget {
  final ECG ecg;

  const ECGDetailsPage({super.key, required this.ecg});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          title: Text(ecg.title),
          centerTitle: true,
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                child: Text('Contexte : ${ecg.description}'),
              ),
              Container(
                child: Text('Année de publication: ${ecg.date?.replaceAll("\n", " ")}'),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.blue.shade300, //Change this color to change the color of the border
                      width: 2.0, // Change this value to change the width of the border
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(right: 10),
                      child: Text('Âge: ${ecg.patientAge}', style: const TextStyle(fontSize: 14)),
                    ),
                    Padding(padding: EdgeInsets.only(right: 10),
                      child: Text('Sexe: ${ecg.patientSex}', style: const TextStyle(fontSize: 14))
                    ),
                    Padding(padding: EdgeInsets.only(right: 10),
                        child: Text('Qualité: ${ecg.quality}', style: const TextStyle(fontSize: 14))
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey.shade200,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    itemCount: ecg.tags.length + 1, // Increase the itemCount by 1 to account for the image
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // If it's the first item, return the image
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return FullscreenImage(imagePath: ecg.photo.path, vitesseEcg: ecg.vitesse, gainEcg: ecg.gain);
                            }));
                          },
                          child: ecg.photo.path == 'assets/images/noimg.jpg'
                              ? Image.asset('assets/images/noimg.jpg', width: 300, height: 200)
                              : Image.network('http://173.212.207.124:3333/imgECGs/${ecg.id}.jpg', width: 300, height: 200, errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                //Retourne une image de secours en cas d'erreur
                                return Image.asset('assets/images/noimg.jpg', width: 300, height: 200);
                            },
                          ),
                        );
                      } else {
                        // Otherwise, return the TagDisplayer
                        return TagDisplayer(tag: ecg.tags[index - 1]); // Subtract 1 from the index to account for the image
                      }
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  sharePDF(context);
                },
                child: Text('Partager'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> sharePDF(BuildContext context) async {
    final url = Uri.parse('http://173.212.207.124:3333/api/v1/ecg/${ecg.id}/pdf');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final url = Uri.parse('http://173.212.207.124:3333/pdfs/${ecg.id}.pdf');
        final response = await http.get(url);
        print(response.body);
        print(response.statusCode);
        print(response.bodyBytes);
        final Directory? directory = await getExternalStorageDirectory();
        final String filePath = '${directory?.path}/${ecg.id}.pdf';
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        Share.shareFiles([filePath], text: 'Partage de PDF');
      } else {
        throw Exception('Erreur lors du partage du PDF');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Une erreur est survenue lors du partage du PDF: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
//TODO ENHANCE TOPBAR