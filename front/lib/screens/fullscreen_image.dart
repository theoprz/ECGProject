import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullscreenImage extends StatelessWidget {
  final String imagePath;

  FullscreenImage({required this.imagePath});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: imagePath.startsWith("/data/")
                ? Image.network('http://173.212.207.124:3333/imgECGs/${imagePath.split('/').last}')
                : Image.asset(imagePath),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}