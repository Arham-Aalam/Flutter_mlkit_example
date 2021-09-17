import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:mlkitexample/models/BodyLankmarks.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ML kit Example',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String data = "ABCD";
  static const platform = MethodChannel('samples.flutter.dev/pose');
  BodyLandmanrks landmanrks = new BodyLandmanrks();
  late Scene _scene;
  late Object demo;

  _MyHomePageState() {
    platform.setMethodCallHandler((call) {
      // print("Methods " + call.method);

      if (call.method == "nose") {
        landmanrks.addNose(call.arguments);

        print((landmanrks.nose.x).toString() +
            " " +
            (landmanrks.nose.y).toString() +
            " " +
            (landmanrks.nose.z).toString());
        face.position.setValues(landmanrks.nose.x, landmanrks.nose.y,
            landmanrks.nose.z); // landmanrks.nose.z
        // face.position.x += 0.002;
        // face.position.z += 0.002;
        // face.position.y += 0.002;
        face.updateTransform();
        _scene.update();
        // print(face.position);
      }
      return new Future.value("");
    });
    _callFunction();
  }

  Future<void> _callFunction() async {
    platform.invokeMethod("DEMO_METHOD");
  }

  late Object face;
  bool runFaceLoop = true;

  @override
  void initState() {
    face = Object(fileName: 'assets/human.obj');
    demo = new Object(
        name: "Demo",
        position: new Vector3(2, 2, 2),
        scale: new Vector3(2.5, 2.5, 1.5));
    // _getFaceUpdate();
    super.initState();
  }

  void _getFaceUpdate() async {
    while (runFaceLoop) {
      platform.invokeMethod("GET_FACE", "").then((value) {
        print("Receieved-> " + value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
      color: Colors.cyan,
      width: size.width,
      height: size.height,
      // child: Center(
      child: Cube(
        onSceneCreated: (Scene scene) {
          scene.world.add(face);
          scene.world.add(demo);
          scene.camera.zoom = 5;
          _scene = scene;
        },
      ),
      // ),
    ));
  }

  @override
  void dispose() {
    setState(() {
      runFaceLoop = false;
    });
    super.dispose();
  }
}
