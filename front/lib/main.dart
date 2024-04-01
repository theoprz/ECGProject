import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:front/screens/add_ecg_screen.dart';
import 'package:front/screens/home_screen.dart';
import 'package:front/screens/Profile/profile_screen.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade600),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'We will delete this topbar later on', camera: camera,),
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
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      HomeScreen(),
      AddECGScreen(camera: widget.camera),
      ProfileScreen(),
    ];
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
      print('Current index $index');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
