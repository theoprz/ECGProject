import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../classes/ECG_class.dart';

class ECGDisplayer extends StatefulWidget {
  final ECG ecg;

  const ECGDisplayer({Key? key, required this.ecg}) : super(key: key);

  @override
  _ECGDisplayerState createState() => _ECGDisplayerState();
}

class _ECGDisplayerState extends State<ECGDisplayer> {
  // Controller for scrolling ListView
  final ScrollController _scrollController = ScrollController();

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
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width *
            0.95, // Set the width to the value you want
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.ecg.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(widget.ecg.description),
              const SizedBox(height: 10),
              Text("Age: ${widget.ecg.patientAge}"),
              const SizedBox(height: 10),
              Text("Sex: ${widget.ecg.patientSex}"),
              const SizedBox(height: 10),
              SizedBox(
                height: 30, // Adjust height as needed
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.ecg.tags.length * 3, // To mimic infinite scrolling
                  itemBuilder: (context, index) {
                    final itemIndex = index % widget.ecg.tags.length;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.red.shade700, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            widget.ecg
                                .getListOfAllTagsNamesAsStrings()[itemIndex],
                            style: TextStyle(fontSize: 14),
                          ),
                        )
                    )
                    );
                  },
                ),
              ),
            ],
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
//TODO: ENHANCE TAGS LOOK AND DISPLAY
//TODO: DISPLAY LESS INFORMATION ON THE CARD
//TODO: ALLOW USER TO CLICK ON THE CARD TO SEE MORE INFORMATION
