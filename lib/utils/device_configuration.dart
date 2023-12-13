import 'package:design_request_app/screens/drawing_page.dart';

class DeviceConfiguration {
  DeviceType deviceType;
  String position;
  int? count;
  int? wiringFloor;

  DeviceConfiguration({
    required this.deviceType,
    required this.position,
    this.count,
    this.wiringFloor,
  });
}
