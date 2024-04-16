import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../classes/ECG_class.dart';
import '../screens/ecg_details_page.dart';

class ECGDisplayer extends StatefulWidget {
  final ECG ecg;

  const ECGDisplayer({Key? key, required this.ecg}) : super(key: key);

  @override
  _ECGDisplayerState createState() => _ECGDisplayerState();
}

class _ECGDisplayerState extends State<ECGDisplayer> {
  // Controller for scrolling ListView
  final ScrollController _scrollController = ScrollController();
  double _borderHeight = 0;

  @override
  void initState() {
    super.initState();


    //scrolling animation
    Timer.periodic(const Duration(milliseconds: 1000), (timer) { //Plus les duration sont élevées, plus le défilement est fluide (jusqu'à un certain point)
      if(_scrollController.position.userScrollDirection == ScrollDirection.idle) {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(0); // Jump back to the start
        } else {
          _scrollController.animateTo(
            _scrollController.position.pixels + 80,
            //Changer la valeur pour changer la distance de défilement à chaque fois -> joue sur la vitesse
            duration: const Duration(milliseconds: 1000),
            //Changer la valeur pour changer la vitesse de défilement
            curve: Curves.linear,
          );
        }
      }
    });

    // Récupérer la hauteur de la bordure
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_borderKey.currentContext != null) {
        final RenderBox renderBox = _borderKey.currentContext!.findRenderObject() as RenderBox;
        final size = renderBox.size;
        setState(() {
          // Mettez à jour la hauteur de la bordure avec la hauteur de la vignette
          _borderHeight = size.height;
        });
      }
    });
  }

  // Définissez cette clé globale en haut de votre widget
  final GlobalKey _borderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(widget.ecg.getStringOfAllTags());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ECGDetailsPage(ecg: widget.ecg),
          ),
        );
      },
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.96,
          child: Container(
            key: _borderKey,
            padding: const EdgeInsets.only(top: 20, left: 6, right: 6, bottom: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 5),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        child: Column(
                          children: [
                            Text(
                              widget.ecg.date ?? '',
                              style: const TextStyle(fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      //BORDURE DE QUALITÉ DE L ECG
                      Container(
                        width: 3,
                        height: _borderHeight,
                        decoration: BoxDecoration(
                          color: getQualityColor(widget.ecg.quality),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(50),
                            bottom: Radius.circular(50),
                          ),
                      ),
                    ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.ecg.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      Text(widget.ecg.description),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 26,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.ecg.tags.length > 4
                              ? widget.ecg.tags.length * 2
                              : widget.ecg.tags.length,
                          itemBuilder: (context, index) {
                            final itemIndex = index % widget.ecg.tags.length;
                            return Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.blue.shade200,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.ecg.getListOfAllTagsNamesAsStrings()[itemIndex],
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}


Color getQualityColor(String quality) {
  switch (quality) {
    case 'Mauvaise':
      return Colors.red;
    case 'Moyenne':
      return Colors.orange.shade400;
    case 'Bonne':
      return Colors.green.shade300;
    case 'Très bonne':
      return Colors.blue.shade300;
    default:
      return Colors.grey.shade900;
  }
}

