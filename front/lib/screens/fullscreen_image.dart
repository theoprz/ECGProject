import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FullscreenImage extends StatefulWidget {
  final ImageProvider image;
  final String gainEcg;
  final String vitesseEcg;

  const FullscreenImage({Key? key, required this.image, required this.gainEcg, required this.vitesseEcg}) : super(key: key);

  @override
  _FullscreenImageState createState() => _FullscreenImageState();
}

class _FullscreenImageState extends State<FullscreenImage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return super.didPopRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Stack(
          children: <Widget>[
            Center(
              child: Hero(
                tag: 'imageHero',
                child: Image(image: widget.image),
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
                    'Vitesse : ${widget.vitesseEcg} mm/s    Gain : ${widget.gainEcg} mm/mV',
                    style: const TextStyle(
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