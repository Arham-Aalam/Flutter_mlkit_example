import 'package:flutter_cube/flutter_cube.dart';

class BodyLandmanrks {
  late Vector3 nose;

  void addNose(String points) {
    if (points == "") {
      return;
    }
    double x = double.parse(points.split(" ")[0]);
    double y = double.parse(points.split(" ")[1]);
    double z = double.parse(points.split(" ")[2]);
    x = mapRange(x, 0, 768, -50, 50);
    y = mapRange(y, 0, 1024, -50, 50);
    nose = new Vector3(x, y, z);
  }

  double mapRange(
      double x, double in_min, double in_max, double out_min, double out_max) {
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
  }
}
