import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullscreenImage extends StatelessWidget {
  final String imagePath;
  final int gainEcg;
  final int vitesseEcg;

  FullscreenImage({required this.imagePath, required this.gainEcg, required this.vitesseEcg});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Stack(
          children: <Widget>[
            Center(
              child: Hero(
                tag: 'imageHero',
                child: imagePath.startsWith("/data/")
                    ? Image.network(
                      'http://173.212.207.124:3333/imgECGs/${imagePath.split('/').last}',
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      //Retourne une image de secours en cas d'erreur
                      return Image.asset('assets/images/noimg.jpg');
                  },
                )
                    : Image.asset(imagePath),
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Vitesse : ${vitesseEcg} mm/s    Gain : ${gainEcg} mm/mV',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}