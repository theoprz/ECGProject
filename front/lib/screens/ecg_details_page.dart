import 'package:flutter/material.dart';
import 'package:front/screens/fullscreen_image.dart';
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
                child: Text('Date de publication: ${ecg.date?.replaceAll("\n", " ")}'),
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
                              print(ecg.photo.path);
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
            ],
          ),
        ),
      ),
    );
  }
}

//TODO ENHANCE TOPBAR