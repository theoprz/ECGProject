import 'package:auth0_flutter_platform_interface/src/credentials.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/screens/add_ecg_screen.dart';
import 'package:front/screens/home_screen.dart';
import 'package:front/screens/Profile/profile_screen.dart';
import 'package:front/screens/login_screen.dart';
import 'package:front/widgets/bottom_navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MainApp(camera: firstCamera));
  });
}

//Gestion du popup de la caméra
bool hasShownPopup = false;

class MainApp extends StatelessWidget {
  final CameraDescription camera;

  const MainApp({super.key, required this.camera});

  // Root of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECG App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade600),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(camera: camera),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final CameraDescription camera;
  final Credentials credentials;

  const MyHomePage({super.key, required this.title, required this.camera, required this.credentials});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    ); // Naviguer vers la page lorsque l'élément de la barre de navigation est appuyé
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        }, // Mettre à jour l'index lorsque la page change
        children: [
          const HomeScreen(),
          AddECGScreen(camera: widget.camera, credentials: widget.credentials),
          ProfileScreen(camera: widget.camera, credentials: widget.credentials),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
