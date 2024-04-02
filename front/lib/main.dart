import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:front/screens/add_ecg_screen.dart';
import 'package:front/screens/home_screen.dart';
import 'package:front/screens/Profile/profile_screen.dart';
import 'package:front/screens/login_screen.dart';
import 'package:front/widgets/bottom_navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MainApp(camera: firstCamera));
}

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
      home: LoginScreen(camera: camera), //Lance l'application sur cet écran
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final CameraDescription camera;

  const MyHomePage({super.key, required this.title, required this.camera});


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
          AddECGScreen(camera: widget.camera),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
