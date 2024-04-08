import 'package:flutter/material.dart';
import 'package:front/widgets/ECGDisplayer.dart';

import '../classes/ECG_class.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<ECG> items;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    generateFakeECGList().then((value) => items = value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<ECG>> generateFakeECGList() async {
    List<ECG> ecgList = [];
    for (int i = 0; i < 20; i++) {
      ECG ecg = ECG("Title $i", "Description $i", i, "1", [], i);
      await ecg.setECGFromJson();
      ecgList.add(ecg);
    }
    return ecgList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text('Mes ECG'),
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
                width: MediaQuery.of(context).size.width * 0.80,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Rechercher un ECG',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade600, //Couleur de la bordure
                      width: 2.0, // Largeur de la bordure
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey.shade200, //Background color
                  child: FutureBuilder(
                    future: generateFakeECGList(),
                    builder: (BuildContext context, AsyncSnapshot<List<ECG>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show loading spinner while waiting for data
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}'); // Show error message if something went wrong
                      } else {
                        items = snapshot.data!; // Assign the data to items when it's loaded
                        return ListView.separated(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ECGDisplayer(ecg: snapshot.data![index]);
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },
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

//TODO WHEN USER SCROLLS, REMOVE KEYBOARD
//TODO WHEN USER CLICKS, REMOVE KEYBOARD