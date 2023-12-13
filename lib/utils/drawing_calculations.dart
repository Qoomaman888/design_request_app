import 'package:flutter/material.dart';


// 制御盤のX座標を計算する関数
double calculateControlBoardX(Size size, String position) {
  switch (position) {
    case "左":
      return size.width * 0.25;
    case "中央":
      return size.width / 2;
    case "右":
      return size.width * 0.75;
    default:
      return size.width / 2;
  }
}

// 各盤のY座標を計算する関数
double calculateControlBoardY(
    Size size, int? floor, int totalFloors, double rfLineY) {
  if (floor == null) return 0;
  return floor == totalFloors
      ? rfLineY
      : (size.height / totalFloors) * (totalFloors - (floor + 1));
}

// 制御盤のデフォルト幅を定義
const double defaultControlBoardWidth = 50.0;

// 制御盤の幅を計算する関数
double calculateControlBoardWidth(List<int?>? wiringFloors, List<String> remoteBoardSelections, double wiringSpacing, double defaultWidth) {
  int activeWiringCount = 0;
  if (wiringFloors != null) {
    for (int i = 0; i < wiringFloors.length; i++) {
      if (wiringFloors[i] != null && remoteBoardSelections[i] == "制御盤") {
        activeWiringCount++;
      }
    }
  }

  return activeWiringCount > 0
      ? wiringSpacing * activeWiringCount
      : defaultWidth;
}


// RS盤のデフォルト幅を定義
const double defaultRSBoardWidth = 50.0;


// RS盤の幅を計算する関数
double calculateRSBoardWidth(List<int?>? wiringFloors, List<String> remoteBoardSelections, String boardType, double wiringSpacing, double defaultWidth) {
  int activeWiringCount = 0;
  if (wiringFloors != null) {
    for (int i = 0; i < wiringFloors.length; i++) {
      if (wiringFloors[i] != null && remoteBoardSelections[i] == boardType) {
        activeWiringCount++;
      }
    }
  }

  return activeWiringCount > 0 ? wiringSpacing * activeWiringCount : defaultWidth;
}


// RS盤のX座標を計算する関数
double calculateRSBoardX(
    Size size,
    String RSBoardPosition,
    String controlBoardPosition,
    double controlBoardX,
    double controlBoardWidth,
    int? controlBoardFloor,
    int? RSBoardFloor,
    double offset) {
  double RSBoardX = calculateControlBoardX(size, RSBoardPosition);

  if (controlBoardFloor == RSBoardFloor &&
      RSBoardPosition == controlBoardPosition) {
    RSBoardX += offset; // 重複がある場合にオフセットを加える
  }

  return RSBoardX;
}
