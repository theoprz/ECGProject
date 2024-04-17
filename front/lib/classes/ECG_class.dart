import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'Tag.dart';

class ECG {
  String title;
  String description;
  int patientAge;
  String patientSex; // 0 or 1
  int patientSexId = 0;
  List<Tag> tags = [];
  String id;
  String? date;
  String quality = "Non renseignée";
  int qualityId = 0;
  String vitesse = "0";
  String  gain = "0";
  File photo;
  String photopath = "";
  List<String> listeSymptomes = [];

  ECG(this.title, this.description, this.patientAge, this.patientSex, this.tags, this.id, this.photo, this.listeSymptomes);//Constructeur de base

  ECG.withQualitySpeedGain(this.title, this.description, this.patientAge, this.patientSex, this.tags, this.id, this.quality, this.vitesse, this.gain, this.photo, this.listeSymptomes);//Constructeur avec les paramètres de qualité, vitesse et gain

  @override
  String toString() {
    return 'ECG{title: $title, description: $description, patientAge: $patientAge, patientSex: $patientSex, tags: $tags, id: $id, quality: $quality, vitesse: $vitesse, gain: $gain, listeSymptomes: $listeSymptomes}';
  }

  Future<File> downloadImage(String ecgId) async {
    final response = await http.get(Uri.parse('http://173.212.207.124:3333/api/v1/ecg/info/image?ecgId=$ecgId'));

    if (response.statusCode == 200) {
      final List<int> imageData = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final File imageFile = File('${tempDir.path}/$ecgId.jpg');

      await imageFile.writeAsBytes(imageData);

      return imageFile;
    } else {
      throw Exception('Failed to download image: ${response.statusCode}');
    }
  }

  Future<void> setECGFromQuery(i) async {
    var url = Uri.parse('http://173.212.207.124:3333/api/v1/ecg');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> dataList = jsonDecode(response.body)['content'];

        List<int> data = dataList[i]['created']['data'].cast<int>();
        String dateString = utf8.decode(data);

        String formattedDate = epochToFrenchDate(int.parse(dateString));

        if(int.parse(dateString) == 0){
           formattedDate = "Non renseignée";
        }

        id = dataList[i]['id'];
        title = dataList[i]['title'];
        title = title.replaceAll('_', ' ');//On retire tous les underscores et on les remplace par des espaces
        description = dataList[i]['contexte'];
        description = description.replaceAll('&#039;', '\'');
        patientAge = dataList[i]['age'];
        patientSex = transformSexe(dataList[i]['sexe']);
        patientSexId = dataList[i]['sexe'];
        id = dataList[i]['id'];
        date = formattedDate;
        quality = handleQuality(dataList[i]['quality']);
        qualityId = dataList[i]['quality'];
        if(dataList[i]['filename'] == ""){
          photopath = 'valeurpardefaut';
          //photo = File('assets/images/noimg.jpg');
        } else {
          photopath = dataList[i]['filename'];
          //photo = await downloadImage(dataList[i]['id']);
        }


        vitesse = dataList[i]['speed'].toString();
        gain = dataList[i]['gain'].toString();

        tags.clear();
        int tagLength = dataList[i]['tags'].length;
        for (int j = 0; j < tagLength; j++) {
          Tag tag = Tag(dataList[i]['tags'][j]['id'].toString(), dataList[i]['tags'][j]['name'].toString(), dataList[i]['tags'][j]['parentId'].toString());
          tags.add(tag);
        }
      } else {
        print('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception lors de la requête: $e');
    }
  }


  String getStringOfAllTags(){
    String result = "";
    for (Tag tag in tags){
      result += "${tag.name}     |     ";
    }
    return result;
  }
  List<String> getListOfAllTagsNamesAsStrings(){
    List<String> result = [];
    for (Tag tag in tags){
      result.add(tag.name);
    }
    return result;
  }

  void setTags(List<Tag> tags){
    this.tags = tags;
  }

}

String transformSexe(int sexe){
  if (sexe == 0){
    return "Homme";
  } else if (sexe == 1){
    return "Femme";
  } else {
    return "Non renseigné";
  }

}

String epochToFrenchDate(int epochTime) {
  // Convert epoch time to DateTime
  DateTime date = DateTime.fromMillisecondsSinceEpoch(epochTime * 1000);//En dart l'epoch fonctionne en ms et pas en s donc je multiplie par 1000


  //List<String> monthNames = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];//On définit le nom des mois

  //String monthName = monthNames[date.month - 1];//On récupère le nom du mois

  return '${date.year}';
}

String handleQuality(int quality) {
  switch (quality) {
    case 1:
      return 'Mauvaise';
    case 2:
      return 'Moyenne';
    case 3:
      return 'Bonne';
    case 4:
      return 'Très bonne';
    default:
      return 'Non renseignée';
  }
}

