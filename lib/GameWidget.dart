import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mlkitexample/models/BodyLankmarks.dart';
import 'dart:ui' as ui;

class GameWidget extends StatefulWidget {
  const GameWidget({Key? key}) : super(key: key);

  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget>
    with SingleTickerProviderStateMixin {
  static const platform = MethodChannel('samples.flutter.dev/pose');
  late BodyLandmanrks landmanrks = new BodyLandmanrks();
  late AnimationController _controller;
  late Size canvasSize;

  @override
  void initState() {

    platform.setMethodCallHandler((call) {
//       print("Methods " + call.method);

      if (call.method == "nose") {
        landmanrks.addNose(call.arguments, canvasSize);
        // _controller.forward();

        print((landmanrks.nose.x).toString() +
            " " +
            (landmanrks.nose.y).toString() +
            " " +
            (landmanrks.nose.z).toString());
        setState(() {});
      }

      if (call.method == "data") {
        Map data = call.arguments;
        landmanrks.loadData(data, canvasSize);
        setState(() {});
      }
      return new Future.value("");
    });

    // _controller = AnimationController(
    //   vsync: this, // the SingleTickerProviderStateMixin
    //   duration: new Duration(microseconds: 1),
    // );

    _callFunction();
    super.initState();
  }

  Future<void> _callFunction() async {
    platform.invokeMethod("DEMO_METHOD");
  }

  @override
  Widget build(BuildContext context) {
    canvasSize = MediaQuery.of(context).size;

    return Container(
        color: Colors.black,
        child: CustomPaint(
          painter: PosePainter(landmanrks),
        )
        // AnimatedBuilder(
        //     animation: _controller,
        //     builder: (context, snapshot) {
        //       return Center(
        //         child: CustomPaint(
        //           painter: PosePainter(landmanrks),
        //         ),
        //       );
        //     }),
        );
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }
}

class PosePainter extends CustomPainter {
  late BodyLandmanrks landmarks;

  PosePainter(
    this.landmarks,
  );

  @override
  void paint(Canvas canvas, Size size) {
    try {
      if(landmarks.nose.x != -1) {
        var offset = Offset(landmarks.nose.x, landmarks.nose.y);
        var paintBrush = Paint()
          ..color = Colors.white;
        canvas.drawCircle(offset, 6, paintBrush);
      }

        if(landmarks.leftShoulder.x != -1) {
          var offset = Offset(landmarks.leftShoulder.x, landmarks.leftShoulder.y);
          var paintBrush = Paint()..color = Colors.white;
          canvas.drawCircle(offset, 6, paintBrush);
        }

      if(landmarks.rightShoulder.x != -1) {
        var offset = Offset(landmarks.rightShoulder.x, landmarks.rightShoulder.y);
        var paintBrush = Paint()..color = Colors.white;
        canvas.drawCircle(offset, 6, paintBrush);
      }

      if(landmarks.leftElbow.x != -1) {
        var offset = Offset(landmarks.leftElbow.x, landmarks.leftElbow.y);
        var paintBrush = Paint()..color = Colors.white;
        canvas.drawCircle(offset, 6, paintBrush);
      }

      if(landmarks.rightElbow.x != -1) {
        var offset = Offset(landmarks.rightElbow.x, landmarks.rightElbow.y);
        var paintBrush = Paint()..color = Colors.white;
        canvas.drawCircle(offset, 6, paintBrush);
      }

      if(landmarks.leftWrist.x != -1) {
        var offset = Offset(landmarks.leftWrist.x, landmarks.leftWrist.y);
        var paintBrush = Paint()..color = Colors.white;
        canvas.drawCircle(offset, 6, paintBrush);
      }

      if(landmarks.rightWrist.x != -1) {
        var offset = Offset(landmarks.rightWrist.x, landmarks.rightWrist.y);
        var paintBrush = Paint()..color = Colors.white;
        canvas.drawCircle(offset, 6, paintBrush);
      }

      if(landmarks.leftHip.x != -1) {
        var offset = Offset(landmarks.leftHip.x, landmarks.leftHip.y);
        var paintBrush = Paint()..color = Colors.white;
        canvas.drawCircle(offset, 6, paintBrush);
      }

      if(landmarks.rightHip.x != -1) {
        var offset = Offset(landmarks.rightHip.x, landmarks.rightHip.y);
        var paintBrush = Paint()..color = Colors.white;
        canvas.drawCircle(offset, 6, paintBrush);
      }

      if(landmarks.leftKnee.x != -1) {
        var offset = Offset(landmarks.rightHip.x, landmarks.rightHip.y);
        var paintBrush = Paint()..color = Colors.white;
        canvas.drawCircle(offset, 6, paintBrush);
      }

      if(landmarks.rightKnee.x != -1) {
        var offset = Offset(landmarks.rightKnee.x, landmarks.rightKnee.y);
        var paintBrush = Paint()..color = Colors.white..strokeWidth = 3;
        canvas.drawCircle(offset, 6, paintBrush);
      }

      if(landmarks.leftAnkle.x != -1) {
        var offset = Offset(landmarks.leftAnkle.x, landmarks.leftAnkle.y);
        var paintBrush = Paint()..color = Colors.white;
        canvas.drawCircle(offset, 6, paintBrush);
      }

      if(landmarks.rightAnkle.x != -1) {
        var offset = Offset(landmarks.rightAnkle.x, landmarks.rightAnkle.y);
        var paintBrush = Paint()..color = Colors.white..strokeWidth = 3;
        canvas.drawCircle(offset, 6, paintBrush);
      }

      if(landmarks.leftShoulder.x != -1 && landmarks.leftElbow.x != -1) {
        var offset1 = Offset(landmarks.leftShoulder.x, landmarks.leftShoulder.y);
        var offset2 = Offset(landmarks.leftElbow.x, landmarks.leftElbow.y);
        var paintBrush = Paint()..color = Colors.cyan..strokeWidth = 3;
        canvas.drawLine(offset1, offset2, paintBrush);
      }

      if(landmarks.rightShoulder.x != -1 && landmarks.rightElbow.x != -1) {
        var offset1 = Offset(landmarks.rightShoulder.x, landmarks.rightShoulder.y);
        var offset2 = Offset(landmarks.rightElbow.x, landmarks.rightElbow.y);
        var paintBrush = Paint()..color = Colors.cyan..strokeWidth = 3;
        canvas.drawLine(offset1, offset2, paintBrush);
      }

      if(landmarks.leftWrist.x != -1 && landmarks.leftElbow.x != -1) {
        var offset1 = Offset(landmarks.leftWrist.x, landmarks.leftWrist.y);
        var offset2 = Offset(landmarks.leftElbow.x, landmarks.leftElbow.y);
        var paintBrush = Paint()..color = Colors.cyan..strokeWidth = 3;
        canvas.drawLine(offset1, offset2, paintBrush);
      }

      if(landmarks.rightWrist.x != -1 && landmarks.rightElbow.x != -1) {
        var offset1 = Offset(landmarks.rightWrist.x, landmarks.rightWrist.y);
        var offset2 = Offset(landmarks.rightElbow.x, landmarks.rightElbow.y);
        var paintBrush = Paint()..color = Colors.cyan..strokeWidth = 3;
        canvas.drawLine(offset1, offset2, paintBrush);
      }

      if(landmarks.leftShoulder.x != -1 && landmarks.rightShoulder.x != -1) {
        var offset1 = Offset(landmarks.leftShoulder.x, landmarks.leftShoulder.y);
        var offset2 = Offset(landmarks.rightShoulder.x, landmarks.rightShoulder.y);
//        var paintBrush = Paint()..color = Colors.cyan;

        var paintBrush = Paint()..shader = ui.Gradient.linear(
          offset1,
          offset2,
          [
            Colors.red,
            Colors.cyan,
          ],
        )..strokeWidth = 3;
        canvas.drawLine(offset1, offset2, paintBrush);
      }

      if(landmarks.leftShoulder.x != -1 && landmarks.leftHip.x != -1) {
        var offset1 = Offset(landmarks.leftShoulder.x, landmarks.leftShoulder.y);
        var offset2 = Offset(landmarks.leftHip.x, landmarks.leftHip.y);
        var paintBrush = Paint()..color = Colors.cyan;
        canvas.drawLine(offset1, offset2, paintBrush);
      }

      if(landmarks.rightHip.x != -1 && landmarks.rightShoulder.x != -1) {
        var offset1 = Offset(landmarks.rightHip.x, landmarks.rightHip.y);
        var offset2 = Offset(landmarks.rightShoulder.x, landmarks.rightShoulder.y);
        var paintBrush = Paint()..color = Colors.cyan..strokeWidth = 3;
        canvas.drawLine(offset1, offset2, paintBrush);
      }

    } catch (e) {
      print(e);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
