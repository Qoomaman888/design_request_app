// coordinate_calculations.dart
import 'package:flutter/material.dart';

class CoordinateCalculations {
  static double calculateXPosition(String position, Size size) {
    switch (position) {
      case "左":
        return size.width * 0.25;
      case "中央":
        return size.width * 0.5;
      case "右":
        return size.width * 0.75;
      default:
        return size.width * 0.5;
    }
  }

  static double calculateYPosition(int? floor, Size size, int totalFloors) {
    if (floor == null) return 0;
    int adjustedFloor = floor + 1;
    return (size.height / totalFloors) * (totalFloors - adjustedFloor);
  }
}
