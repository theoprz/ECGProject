import 'dart:io';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:front/widgets/ECGDisplayer.dart';
import 'package:http/http.dart' as http;

import '../classes/ECG_class.dart';

class HomeScreen extends StatefulWidget {
  final Credentials credentials;
  const HomeScreen({super.key, required this.credentials});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<ECG> items;
  final TextEditingController _controller = TextEditingController();
  List<ECG> filteredItems = [];
  Future<List<ECG>>? _ecgListFuture;
  late bool myEcgFilter = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
    _ecgListFuture = generateFakeECGList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<ECG>> generateFakeECGList() async {

    var url = Uri.parse('http://173.212.207.124:3333/api/v1/ecg/info/count');

    List<ECG> ecgList = [];

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        for(int i = 0; i < int.parse(response.body); i++){
          ECG ecg = ECG("Titre", "Description", 0, "1", [], "0", File(''), [], "0");
          await ecg.setECGFromQuery(i);
          ecgList.add(ecg);
        }

      } else {
        print('Erreur generateFakeECGList : ${response.statusCode}');
      }
    } catch (e) {
      print('Exception lors de la requête generateFakeECGList: $e');
    }
    return ecgList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          title: const Text('Électrocardiogrammes'),
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
                height: 50,
                width: MediaQuery.of(context).size.width * 0.97,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0, right: 10, bottom: 10),
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            labelText: 'Rechercher un ECG',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _controller.clear();
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10),
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO:AJOUTER FILTRAGE PAR UTILISATEUR
                          setState(() {
                            myEcgFilter = !myEcgFilter;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: myEcgFilter ? Colors.green.shade300 : Colors.blue.shade300,
                          side: BorderSide(color: myEcgFilter ? Colors.green.shade300 : Colors.blue.shade300, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(50, 35), // This is the size of the button
                        ),
                        child: const Text('Mes ECG'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: myEcgFilter ? Colors.green.shade300 : Colors.blue.shade300, //Couleur de la bordure
                      width: 2.0, // Largeur de la bordure
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey.shade200, //Background color
                  child: FutureBuilder(
                    future: _ecgListFuture,
                    builder: (BuildContext context, AsyncSnapshot<List<ECG>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 20),
                              Text('Chargement'),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        print('Erreur FutureBuilder : ${snapshot.error}');
                        return const Center(
                          child: Text('Erreur de chargement'),
                        );
                      } else {
                        items = snapshot.data!;
                        if(myEcgFilter){
                          items = items.where((ecg) => ecg.postedby == widget.credentials.toString()).toList();
                        }
                        filteredItems = items
                            .where((ecg) =>
                            ecg.title.toLowerCase().contains(_controller.text.toLowerCase()) ||//Recherche par titre
                            ecg.tags.any((tag) => tag.name.toLowerCase().contains(_controller.text.toLowerCase()))//Recherche par tag
                        )
                            .toList();
                        return GestureDetector(
                          onVerticalDragDown: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: ListView.separated(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              return ECGDisplayer(ecg: filteredItems[index]);
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 10);
                            },
                          ),
                        );
                      }
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