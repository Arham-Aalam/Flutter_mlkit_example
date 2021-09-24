import 'package:flutter/cupertino.dart';
import 'package:flutter_cube/flutter_cube.dart';

class BodyLandmanrks {
  Vector3 nose = new Vector3(-1,-1,-1), leftShoulder = new Vector3(-1,-1,-1), rightShoulder = new Vector3(-1,-1,-1), leftElbow = new Vector3(-1,-1,-1), rightElbow = new Vector3(-1,-1,-1),
      leftWrist  = new Vector3(-1,-1,-1), rightWrist = new Vector3(-1,-1,-1), leftHip = new Vector3(-1,-1,-1), rightHip = new Vector3(-1,-1,-1), leftKnee = new Vector3(-1,-1,-1),
      rightKnee = new Vector3(-1,-1,-1), leftAnkle = new Vector3(-1,-1,-1), rightAnkle = new Vector3(-1,-1,-1);
  late Size canvasSize;
  double width = 768, height = 1024;

  BodyLandmanrks({this.width = 768, this.height = 1024});

  void addNose(String points, Size canvasSize) {
    if (points == "") {
      return;
    }
    double x = double.parse(points.split(" ")[0]);
    double y = double.parse(points.split(" ")[1]);
    double z = double.parse(points.split(" ")[2]);

    // x = mapRange(x, 0, 768, -1.0, 1.0);
    // y = mapRange(y, 0, 1024, -1.0, 1.0) * -1.0;
    // z = mapRange(z, -10000, 10000, -1.0, 1.0);

    x = mapRange(x, 0, 768, 0, canvasSize.width);
    y = mapRange(y, 0, 1024, 0, canvasSize.height, flip: true);
    z = mapRange(z, -10000, 10000, -1.0, 1.0);

    nose = new Vector3(x, y, z);
  }

  double mapRange(
      double x, double in_min, double in_max, double out_min, double out_max,
      {bool flip = false}) {
//    if (flip) {
//      var mid = (in_max - in_min) / 2;
//      if (mid > x) {
//        x = mid + (mid - x);
//      } else {
//        x = mid - (x - mid);
//      }
//    }
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
  }

  Vector3 convertValue(String? points) {
    if (points == "" || points == null) {
      return Vector3(-1, -1, -1);
    }
    double x = double.parse(points.split(" ")[0]);
    double y = double.parse(points.split(" ")[1]);
    double z = double.parse(points.split(" ")[2]);

    // x = mapRange(x, 0, 768, -1.0, 1.0);
    // y = mapRange(y, 0, 1024, -1.0, 1.0) * -1.0;
    // z = mapRange(z, -10000, 10000, -1.0, 1.0);

    x = mapRange(x, 0, width, 0, canvasSize.width);
    y = mapRange(y, 0, height, 0, canvasSize.height, flip: true);
    z = mapRange(z, -10000, 10000, -1.0, 1.0);

    return new Vector3(x, y, z);
  }

  void loadData(Map data, Size canvasSize) {
    this.canvasSize = canvasSize;
    nose = convertValue(data["nose"]);
    leftShoulder = convertValue(data["leftShoulder"]);
    rightShoulder = convertValue(data["rightShoulder"]);
    leftElbow = convertValue(data["leftElbow"]);
    rightElbow = convertValue(data["rightElbow"]);
    leftWrist = convertValue(data["leftWrist"]);

    rightWrist = convertValue(data["rightWrist"]);
    leftHip = convertValue(data["leftHip"]);
    rightHip = convertValue(data["rightHip"]);
    leftKnee = convertValue(data["leftKnee"]);

    rightKnee = convertValue(data["rightKnee"]);
    leftAnkle = convertValue(data["leftAnkle"]);
    rightAnkle = convertValue(data["rightAnkle"]);
  }
}
