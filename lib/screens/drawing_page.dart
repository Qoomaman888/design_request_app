import 'package:flutter/material.dart';
import 'package:design_request_app/screens/request_page.dart';
import 'package:design_request_app/utils/dropdown_helpers.dart';
import 'package:design_request_app/utils/drawing_calculations.dart';
import 'package:design_request_app/utils/widgets.dart';
import 'package:design_request_app/utils/drawing_utilities.dart';
import 'package:design_request_app/utils/coordinate_calculations.dart';

enum DeviceType { PAC, VRV, HEX }

class DrawingPage extends StatefulWidget {
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  List<DeviceType> deviceTypes = List.generate(8, (index) => DeviceType.PAC);
  int? controlBoardFloor;
  int? RSBoardFloor1;
  int? RSBoardFloor2;
  String? RSBoardType1 = '空調'; // RS盤1の区分を格納する変数
  String? RSBoardType2 = '空調'; // RS盤2の区分を格納する変数
  List<int?> wiringFloors = List.generate(8, (index) => null);
  List<String?> devicePositions = List.generate(8, (index) => "左");
  List<int?> deviceCounts = List.generate(8, (index) => null);
  int? undergroundFloors = 1;
  int abovegroundFloors = 1;
  String controlBoardPosition = "中央";
  String RSBoardPosition1 = "中央";
  String RSBoardPosition2 = "中央";
  String? selectedMonitoringDevice = 'DK-CONNECT'; // 初期値を設定
  List<String> remoteBoardSelections = List.generate(8, (index) => "制御盤");

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double drawingHeight = 500.0;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Drawing Page'),
          backgroundColor: Color(0xFF008080), // Teal color for the AppBar
        ),
        body: SingleChildScrollView(
          child: Row(
            children: [
              Container(
                width: screenWidth * 0.4, // この部分で screenWidth を使用
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border:
                      Border(right: BorderSide(width: 1, color: Colors.grey)),
                  color: Color(0xFFEAFAEA), // Lime Green light color for the background // 背景色を追加
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "建物情報",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("地上階数"),
// 地上階数のドロップダウン
                    buildFloorDropdown(abovegroundFloors, 15, (newValue) {
                      setState(() {
                        abovegroundFloors = newValue!;
                      });
                    }, isUnderground: false), // 地上階数の場合

                    Text("地下階数"),
// 地下階数のドロップダウン
                    buildFloorDropdown(undergroundFloors!, 5, (newValue) {
                      setState(() {
                        undergroundFloors = newValue;
                      });
                    }, isUnderground: true), // 地下階数の場合

                    SizedBox(height: 20),
                    Text(
                      "盤情報",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("監視盤"),
                    Row(
                      children: [
                        Text("設置位置"),
                        DropdownButton<int?>(
                          value: controlBoardFloor,
                          items: [
                            ...List.generate(
                                    abovegroundFloors, (index) => index + 1)
                                .map((int value) {
                              return DropdownMenuItem<int?>(
                                value: value,
                                child: Text('$value F'),
                              );
                            }).toList(),
                            DropdownMenuItem<int?>(
                              value: abovegroundFloors + 1,
                              child: Text('RF'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              controlBoardFloor = value;
                            });
                          },
                        ),
                        Text("配置"),
                        DropdownButton<String>(
                          value: controlBoardPosition,
                          items: ["左", "中央", "右"].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              controlBoardPosition = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    Text("RS盤1"),
                    Row(
                      children: [
                        Text("設置位置"),
                        DropdownButton<int?>(
                          value: RSBoardFloor1,
                          items: [
                            ...List.generate(
                                    abovegroundFloors, (index) => index + 1)
                                .map((int value) {
                              return DropdownMenuItem<int?>(
                                value: value,
                                child: Text('$value F'),
                              );
                            }).toList(),
                            DropdownMenuItem<int?>(
                              value: abovegroundFloors + 1,
                              child: Text('RF'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              RSBoardFloor1 = value;
                            });
                          },
                        ),
                        Text("配置"),
                        DropdownButton<String>(
                          value: RSBoardPosition1,
                          items: ["左", "中央", "右"].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              RSBoardPosition1 = value!;
                            });
                          },
                        ),
                        Text("区分"),
                        DropdownButton<String>(
                          value: RSBoardType1,
                          onChanged: (String? newValue) {
                            setState(() {
                              RSBoardType1 = newValue;
                            });
                          },
                          items: <String>['空調', '換気', '衛生', '電気', '消火']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Text("RS盤2"),
                    Row(
                      children: [
                        Text("設置位置"),
                        DropdownButton<int?>(
                          value: RSBoardFloor2,
                          items: [
                            ...List.generate(
                                    abovegroundFloors, (index) => index + 1)
                                .map((int value) {
                              return DropdownMenuItem<int?>(
                                value: value,
                                child: Text('$value F'),
                              );
                            }).toList(),
                            DropdownMenuItem<int?>(
                              value: abovegroundFloors + 1,
                              child: Text('RF'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              RSBoardFloor2 = value;
                            });
                          },
                        ),
                        Text("配置"),
                        DropdownButton<String>(
                          value: RSBoardPosition2,
                          items: ["左", "中央", "右"].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              RSBoardPosition2 = value!;
                            });
                          },
                        ),
                        Text("区分"),
                        DropdownButton<String>(
                          value: RSBoardType2, // この変数は状態変数として定義する
                          onChanged: (String? newValue) {
                            setState(() {
                              RSBoardType2 = newValue;
                            });
                          },
                          items: <String>['空調', '換気', '衛生', '電気', '消火']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "機器情報",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    // ここに監視装置のドロップダウンを追加
                    SizedBox(height: 20),
                    Text(
                      "監視装置",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: selectedMonitoringDevice, // この変数は状態変数として定義する
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMonitoringDevice = newValue;
                        });
                      },
                      items: <String>[
                        'DK-CONNECT',
                        'iTM',
                        'iTC',
                        'iTM(壁付け)',
                        'iTC(壁付け)'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    // 系統のリストを生成
                    Column(
                      children: List.generate(8, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text('系統${index + 1}'),
                              SizedBox(width: 10),
                              DropdownButton<int?>(
                                value: wiringFloors[index],
                                items: (index == 0 ||
                                        wiringFloors[index - 1] != null)
                                    ? List.generate(abovegroundFloors,
                                        (index) => index + 1).map((int value) {
                                        return DropdownMenuItem<int?>(
                                          value: value,
                                          child: Text('$value F'),
                                        );
                                      }).toList()
                                    : [],
                                onChanged: (value) {
                                  setState(() {
                                    wiringFloors[index] = value;
                                  });
                                },
                              ),
                              DropdownButton<DeviceType>(
                                value: deviceTypes[index],
                                items: DeviceType.values.map((DeviceType type) {
                                  return DropdownMenuItem<DeviceType>(
                                    value: type,
                                    child:
                                        Text(type.toString().split('.').last),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    deviceTypes[index] = value!;
                                  });
                                },
                              ),
                              DropdownButton<String>(
                                value: devicePositions[index],
                                items: ["左", "右"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    devicePositions[index] = value;
                                  });
                                },
                              ),
                              DropdownButton<int>(
                                value: deviceCounts[index],
                                items: List.generate(64, (index) => index + 1)
                                    .map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text('$value 台'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    deviceCounts[index] = value!;
                                  });
                                },
                              ),
                              DropdownButton<String>(
                                value: remoteBoardSelections[index],
                                items: <String>["制御盤", "RS1", "RS2"]
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  // 型を String? に変更
                                  setState(() {
                                    if (value != null) {
                                      // null チェックを追加
                                      remoteBoardSelections[index] = value;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Container(
                width: screenWidth * 0.6,
                height: drawingHeight, // ここで描画領域の高さを指定
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: CustomPaint(
                  size: Size(screenWidth * 0.6, drawingHeight),
                  // ここでも描画領域の高さを指定
                  painter: MyPainter(
                    controlBoardFloor: controlBoardFloor,
                    wiringFloors: wiringFloors,
                    devicePositions: devicePositions,
                    undergroundFloors: undergroundFloors!,
                    abovegroundFloors: abovegroundFloors,
                    controlBoardPosition: controlBoardPosition,
                    deviceCounts: deviceCounts,
                    deviceTypes: deviceTypes,
                    RSBoardPosition1: RSBoardPosition1,
                    // この行を追加
                    RSBoardPosition2: RSBoardPosition2,
                    // この行を追加
                    RSBoardFloor1: RSBoardFloor1,
                    // この行を追加
                    RSBoardFloor2: RSBoardFloor2,
                    // この行を追加
                    remoteBoardSelections: remoteBoardSelections,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RequestPage()),
            );
          },
          backgroundColor: Color(0xFF32CD32),
          // Vivid Cerulean Blue color for the FAB
          child: Icon(Icons.navigate_next,
              color: Colors.white), // Icon color changed to white
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final int? controlBoardFloor;
  final int? RSBoardFloor1;
  final int? RSBoardFloor2;
  final List<int?>? wiringFloors;
  final List<String?> devicePositions;
  final List<int?> deviceCounts;
  final int undergroundFloors;
  final int abovegroundFloors;
  final String controlBoardPosition;
  final double wiringSpacing;
  final List<DeviceType> deviceTypes;
  final String RSBoardPosition1;
  final String RSBoardPosition2;
  final int totalFloors;
  final double boardWidth = 30.0;
  final List<String> remoteBoardSelections;

  MyPainter({
    this.controlBoardFloor,
    this.RSBoardFloor1,
    this.RSBoardFloor2,
    this.wiringFloors,
    required this.devicePositions,
    required this.deviceCounts,
    required this.undergroundFloors,
    required this.abovegroundFloors,
    required this.controlBoardPosition,
    this.wiringSpacing = 20.0,
    required this.deviceTypes,
    required this.RSBoardPosition1,
    required this.RSBoardPosition2,
    required this.remoteBoardSelections,
  }) : totalFloors = undergroundFloors + abovegroundFloors + 1;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    int totalFloors = undergroundFloors + abovegroundFloors + 1;
    final double floorHeight = size.height / totalFloors;
    final double vrvDeviceHeight = floorHeight / 3;
    final double devicePositionLeftX = size.width * 0.1;
    final double devicePositionRightX = size.width * 0.9;
    final double controlBoardHeight = size.height / totalFloors / 3;
    final double boardHeight = size.height / totalFloors / 3;
    final double deviceWidth = wiringSpacing * 1.5;
    final double deviceHeight = controlBoardHeight / 2;
    double deviceXOffset;

    double rfLineY = size.height - floorHeight * (abovegroundFloors + 2);
    double vrvY = rfLineY - vrvDeviceHeight / 2;

    for (int i = abovegroundFloors + 1; i >= -undergroundFloors; i--) {
      if (i == 0) continue;
      String floorText;
      if (i == abovegroundFloors + 1) {
        floorText = 'RF';
      } else if (i > 0) {
        floorText = '${i}F';
      } else {
        floorText = 'B${-i}F';
      }
      final double yPos =
          (size.height / totalFloors) * (abovegroundFloors + 1 - i);
      canvas.drawLine(Offset(0, yPos), Offset(size.width, yPos), paint);
      textPainter.text = TextSpan(
        text: floorText,
        style: TextStyle(color: Colors.black, fontSize: 14),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, yPos - 15));
    }

    //盤の描画

// 制御盤の位置を決定
    double controlBoardX =
        calculateControlBoardX(size, controlBoardPosition); // 関数名を変更
    double controlBoardY = calculateControlBoardY(
        size, controlBoardFloor, totalFloors, rfLineY); // 関数名を変更
    double controlBoardWidth = calculateControlBoardWidth(
        wiringFloors, remoteBoardSelections, wiringSpacing, boardWidth);

// 制御盤の描画
    drawControlBoard(canvas, paint, controlBoardX, controlBoardY,
        controlBoardWidth, controlBoardHeight);

// RS盤1の位置を決定
    double RSBoard1X = calculateRSBoardX(
        size,
        RSBoardPosition1,
        controlBoardPosition,
        controlBoardX,
        controlBoardWidth,
        controlBoardFloor,
        RSBoardFloor1,
        50);
    double RSBoard1Y = calculateControlBoardY(
        size, RSBoardFloor1, totalFloors, rfLineY); // 関数名を変更
    double RS1BoardWidth = calculateRSBoardWidth(
        wiringFloors, remoteBoardSelections, "RS1", wiringSpacing, boardWidth);

// RS盤1の描画
    drawRSBoard(
        canvas, paint, RSBoard1X, RSBoard1Y, RS1BoardWidth, "RS1", boardHeight);

// RS盤2の位置を決定
    double RSBoard2X = calculateRSBoardX(
        size,
        RSBoardPosition2,
        controlBoardPosition,
        controlBoardX,
        controlBoardWidth,
        controlBoardFloor,
        RSBoardFloor2,
        50);

    if (RSBoardFloor1 == RSBoardFloor2 &&
        RSBoardPosition1 == RSBoardPosition2) {
      // RS1とRS2が同じ階に同じ位置にある場合、RS1の幅を考慮してオフセットを加える
      RSBoard2X += 50; // 50はオフセットの値
    } else {
      // それ以外の場合は通常通りに計算
    }
    double RSBoard2Y = calculateControlBoardY(
        size, RSBoardFloor2, totalFloors, rfLineY); // 関数名を変更
    double RS2BoardWidth = calculateRSBoardWidth(
        wiringFloors, remoteBoardSelections, "RS2", wiringSpacing, boardWidth);

// RS盤2の描画
    drawRSBoard(
        canvas, paint, RSBoard2X, RSBoard2Y, RS2BoardWidth, "RS2", boardHeight);

    // 縦配線のX座標を計算
    int wiringFloorsLength = wiringFloors?.length ?? 0; // 安全なlength取得
    for (int i = 0; i < wiringFloorsLength; i++) {
      // 型の不一致を解消
      if (wiringFloors?[i] != null) {
        String selectedBoard = remoteBoardSelections[i];
        double boardX, boardY;
        // 選択された盤に基づいてX座標とY座標を計算
        switch (selectedBoard) {
          case "制御盤":
            boardX = controlBoardX;
            boardY = CoordinateCalculations.calculateYPosition(
                controlBoardFloor, size, totalFloors);
            break;
          case "RS1":
            boardX = RSBoard1X;
            boardY = CoordinateCalculations.calculateYPosition(
                RSBoardFloor1, size, totalFloors);
            break;
          case "RS2":
            boardX = RSBoard2X;
            boardY = CoordinateCalculations.calculateYPosition(
                RSBoardFloor2, size, totalFloors);
            break;
          default:
            boardX = controlBoardX;
            boardY = CoordinateCalculations.calculateYPosition(
                controlBoardFloor, size, totalFloors);
        }

        // calculateControlBoardWidth 関数を呼び出す
        double activeControlBoardWiringCount = calculateControlBoardWidth(
            wiringFloors,
            remoteBoardSelections,
            wiringSpacing,
            defaultControlBoardWidth);
        // calculateRSBoardWidth 関数を呼び出して RS1 の幅を計算
        double activeRS1WiringCount = calculateRSBoardWidth(wiringFloors,
            remoteBoardSelections, "RS1", wiringSpacing, defaultRSBoardWidth);

        // calculateRSBoardWidth 関数を呼び出して RS2 の幅を計算
        double activeRS2WiringCount = calculateRSBoardWidth(wiringFloors,
            remoteBoardSelections, "RS2", wiringSpacing, defaultRSBoardWidth);

        if (remoteBoardSelections[i] == "制御盤") {
          deviceXOffset = i * wiringSpacing -
              (activeControlBoardWiringCount * wiringSpacing) / 2 +
              wiringSpacing / 2;
        } else if (remoteBoardSelections[i] == "RS1") {
          deviceXOffset = i * wiringSpacing -
              (activeRS1WiringCount * wiringSpacing) / 2 +
              wiringSpacing / 2;
        } else if (remoteBoardSelections[i] == "RS2") {
          deviceXOffset = i * wiringSpacing -
              (activeRS2WiringCount * wiringSpacing) / 2 +
              wiringSpacing / 2;
        } else {
          deviceXOffset = i * wiringSpacing; // デフォルトのオフセット
        }

        double controlBoardWidth = calculateControlBoardWidth(wiringFloors,
            remoteBoardSelections, wiringSpacing, defaultControlBoardWidth);
        double activeRS1BoardWidth = calculateRSBoardWidth(wiringFloors,
            remoteBoardSelections, "RS1", wiringSpacing, defaultRSBoardWidth);
        double activeRS2BoardWidth = calculateRSBoardWidth(wiringFloors,
            remoteBoardSelections, "RS2", wiringSpacing, defaultRSBoardWidth);

        double boardWidth;
        switch (selectedBoard) {
          case "制御盤":
            boardWidth = controlBoardWidth;
            break;
          case "RS1":
            boardWidth = activeRS1BoardWidth;
            break;
          case "RS2":
            boardWidth = activeRS2BoardWidth;
            break;
          default:
            boardWidth = controlBoardWidth;
        }

        // 盤の左端と右端の座標を計算
        double boardLeftX = boardX - (boardWidth / 2);

        // 盤の幅を超える場合、盤の右端を超えないように縦配線を配置
        double verticalLineX;

        // 選択されている系統数を計算
        int activeWiringFloorsLength =
            wiringFloors?.where((floor) => floor != null).length ?? 0;

        if (wiringFloorsLength * wiringSpacing <= boardWidth) {
          // 盤の幅内で縦配線を均等に配置
          double wiringOffset =
              (boardWidth - activeWiringFloorsLength * wiringSpacing) / 2;
          verticalLineX = boardLeftX + wiringOffset + ((i + 1) * wiringSpacing);
        } else {
          // 盤の幅を超える場合、盤の右端を超えないように縦配線を配置
          verticalLineX = boardLeftX +
              ((i + 1) * (boardWidth / (activeWiringFloorsLength + 1)));
        }

        //機器変数の定義
        double deviceWidth = deviceTypes[i] == DeviceType.VRV ? 10 : 20;
        double deviceHeight = deviceTypes[i] == DeviceType.VRV ? 25 : 10;
        double deviceY = (size.height / totalFloors) *
                (abovegroundFloors + 1 - wiringFloors![i]!) -
            (size.height / totalFloors) +
            deviceHeight / 2;

        if (deviceTypes[i] == DeviceType.VRV) {
          deviceY = rfLineY - deviceHeight / 2; // VRVの場合はRFのY座標を使用
        }

        // 盤側の縦配線を描画
        double lineY = boardY;
        if (controlBoardFloor != null) {
          // controlBoardFloor が null でないことを確認
          if (deviceTypes[i] != DeviceType.VRV) {
            if (wiringFloors![i]! >= controlBoardFloor!) {
              // 機器が盤の階より上にある場合、盤の上辺を始点とする
              lineY -= controlBoardHeight;
            }
          }
        }

        // 縦配線の描画
        if (deviceTypes[i] == DeviceType.VRV) {
          lineY -= controlBoardHeight;
          deviceY = vrvY - vrvDeviceHeight;
        }
        canvas.drawLine(Offset(verticalLineX, lineY),
            Offset(verticalLineX, deviceY), paint);

        // 横配線の描画
        double deviceXEnd = devicePositions[i] == "左"
            ? devicePositionLeftX
            : devicePositionRightX;
        if (deviceTypes[i] == DeviceType.VRV) {
          deviceY = vrvY - vrvDeviceHeight;
        } else {
          if (devicePositions[i] == "左") {
            deviceXEnd += deviceWidth / 2;
          } else {
            deviceXEnd -= deviceWidth / 2;
          }
        }

        canvas.drawLine(
            Offset(deviceXEnd, deviceY), Offset(verticalLineX, deviceY), paint);
      }
    }

// 制御盤からRS盤1への縦配線と横配線を描画
    if (controlBoardFloor != null && RSBoardFloor1 != null) {
      double RSBoard1Y = CoordinateCalculations.calculateYPosition(
          RSBoardFloor1, size, totalFloors);
      double controlBoardY = CoordinateCalculations.calculateYPosition(
          controlBoardFloor, size, totalFloors);

      // 制御盤がRS盤1より上の階にある場合の縦配線の始点を調整
      // nullチェックを追加し、変数のアンラップを行う
      double lineStartY = controlBoardFloor! > RSBoardFloor1!
          ? controlBoardY
          : controlBoardY - controlBoardHeight;

      // フロアが異なり配置が同じ場合は縦配線のみ
      if (controlBoardFloor != RSBoardFloor1 &&
          controlBoardPosition == RSBoardPosition1) {
        canvas.drawLine(Offset(controlBoardX, lineStartY),
            Offset(controlBoardX, RSBoard1Y), paint);
      }
      // フロアが異なり配置も異なる場合は縦配線と横配線
      else if (controlBoardFloor != RSBoardFloor1 &&
          controlBoardPosition != RSBoardPosition1) {
        canvas.drawLine(Offset(controlBoardX, lineStartY),
            Offset(controlBoardX, RSBoard1Y - controlBoardHeight / 2), paint);
        double lineStartX, lineEndX;
        if (RSBoardPosition1 == "左") {
          // RS1が左にある場合、始点は制御盤の左辺、終点はRS1の右辺
          lineStartX = controlBoardX;
          lineEndX = RSBoard1X + 15; // RS1の幅を考慮して右にオフセット
        } else {
          // それ以外の場合、始点は制御盤の右辺、終点はRS1の左辺
          lineStartX = controlBoardX;
          lineEndX = RSBoard1X - 15; // RS1の幅を考慮して左にオフセット
        }
        canvas.drawLine(Offset(lineStartX, RSBoard1Y - controlBoardHeight / 2),
            Offset(lineEndX, RSBoard1Y - controlBoardHeight / 2), paint);
      }
      // フロアが同一の場合は横配線のみ
      else if (controlBoardFloor == RSBoardFloor1) {
        double lineStartX, lineEndX;
        if (RSBoardPosition1 == "左" ||
            (RSBoardPosition1 == "中央" && controlBoardPosition == "右")) {
          // RS1が左にある場合、始点は制御盤の左辺、終点はRS1の右辺
          lineStartX = controlBoardX - controlBoardWidth / 2;
          lineEndX = RSBoard1X + 15; // RS1の幅を考慮して右にオフセット
        } else {
          // それ以外の場合、始点は制御盤の右辺、終点はRS1の左辺
          lineStartX = controlBoardX + controlBoardWidth / 2;
          lineEndX = RSBoard1X - 15; // RS1の幅を考慮して左にオフセット
        }
        canvas.drawLine(Offset(lineStartX, RSBoard1Y - controlBoardHeight / 2),
            Offset(lineEndX, RSBoard1Y - controlBoardHeight / 2), paint);
      }
    }

// RS盤1からRS盤2への縦配線と横配線を描画
    if (RSBoardFloor1 != null && RSBoardFloor2 != null) {
      double RSBoard1Y = CoordinateCalculations.calculateYPosition(
          RSBoardFloor1, size, totalFloors);
      double RSBoard2Y = CoordinateCalculations.calculateYPosition(
          RSBoardFloor2, size, totalFloors);

      // RS盤1がRS盤2より上の階にある場合の縦配線の始点を調整
      double lineStartY =
          RSBoardFloor1! > RSBoardFloor2! ? RSBoard1Y : RSBoard1Y - boardHeight;

      // フロアが異なり配置が同じ場合は縦配線のみ
      if (RSBoardFloor1 != RSBoardFloor2 &&
          RSBoardPosition1 == RSBoardPosition2) {
        double lineEndY;
        if (RSBoardFloor1 != null && RSBoardFloor2 != null) {
          if (RSBoardFloor1! > RSBoardFloor2!) {
            // RS2がRS1より下の階にある場合、縦配線はRS2の上辺まで
            lineEndY = RSBoard2Y - boardHeight;
          } else {
            // それ以外の場合、縦配線はRS2の下辺まで
            lineEndY = RSBoard2Y;
          }
          canvas.drawLine(Offset(RSBoard1X, lineStartY),
              Offset(RSBoard1X, lineEndY), paint);
        }
      }
      // フロアが異なり配置も異なる場合は縦配線と横配線
      else if (RSBoardFloor1 != RSBoardFloor2 &&
          RSBoardPosition1 != RSBoardPosition2) {
        canvas.drawLine(Offset(RSBoard1X, lineStartY),
            Offset(RSBoard1X, RSBoard2Y - boardHeight / 2), paint);
        double lineStartX, lineEndX;
        if (RSBoardPosition2 == "左" ||
            (RSBoardPosition2 == "中央" && RSBoardPosition1 == "右")) {
          // RS2が左にある場合、始点はRS1の左辺、終点はRS2の右辺
          lineStartX = RSBoard1X;
          lineEndX = RSBoard2X + RS2BoardWidth / 2;
        } else {
          // それ以外の場合、始点はRS1の右辺、終点はRS2の左辺
          lineStartX = RSBoard1X;
          lineEndX = RSBoard2X - RS2BoardWidth / 2;
        }
        canvas.drawLine(Offset(lineStartX, RSBoard2Y - boardHeight / 2),
            Offset(lineEndX, RSBoard2Y - boardHeight / 2), paint);
      }
      // フロアが同一の場合は横配線のみ
      else if (RSBoardFloor1 == RSBoardFloor2) {
        double lineStartX, lineEndX;
        if (RSBoardPosition2 == "左") {
          // RS2が左にある場合、始点はRS1の左辺、終点はRS2の右辺
          lineStartX = RSBoard1X - RS1BoardWidth / 2;
          lineEndX = RSBoard2X + RS2BoardWidth / 2;
        } else {
          // それ以外の場合、始点はRS1の右辺、終点はRS2の左辺
          lineStartX = RSBoard1X + RS1BoardWidth / 2;
          lineEndX = RSBoard2X - RS2BoardWidth / 2;
        }
        canvas.drawLine(Offset(lineStartX, RSBoard2Y - boardHeight / 2),
            Offset(lineEndX, RSBoard2Y - boardHeight / 2), paint);
      }
    }

    for (int i = 0; i < wiringFloors!.length; i++) {
      if (wiringFloors![i] != null) {
        // calculateControlBoardWidth 関数を呼び出す
        double activeControlBoardWiringCount = calculateControlBoardWidth(
            wiringFloors, remoteBoardSelections, wiringSpacing, boardWidth);
        // calculateRSBoardWidth 関数を呼び出して RS1 の幅を計算
        double activeRS1WiringCount = calculateRSBoardWidth(wiringFloors,
            remoteBoardSelections, "RS1", wiringSpacing, defaultRSBoardWidth);

        // calculateRSBoardWidth 関数を呼び出して RS2 の幅を計算
        double activeRS2WiringCount = calculateRSBoardWidth(wiringFloors,
            remoteBoardSelections, "RS2", wiringSpacing, defaultRSBoardWidth);

        if (remoteBoardSelections[i] == "制御盤") {
          deviceXOffset = i * wiringSpacing -
              (activeControlBoardWiringCount * wiringSpacing) / 2 +
              wiringSpacing / 2;
        } else if (remoteBoardSelections[i] == "RS1") {
          deviceXOffset = i * wiringSpacing -
              (activeRS1WiringCount * wiringSpacing) / 2 +
              wiringSpacing / 2;
        } else if (remoteBoardSelections[i] == "RS2") {
          deviceXOffset = i * wiringSpacing -
              (activeRS2WiringCount * wiringSpacing) / 2 +
              wiringSpacing / 2;
        } else {
          deviceXOffset = i * wiringSpacing; // デフォルトのオフセット
        }

        final double deviceX = controlBoardX + deviceXOffset;
        // 1階分の高さを計算

        double deviceXEnd = devicePositions[i] == "左"
            ? devicePositionLeftX
            : devicePositionRightX;
        // 機器の中心のY座標を計算
        double deviceY = (size.height / totalFloors) *
                (abovegroundFloors + 1 - wiringFloors![i]!) -
            (size.height / totalFloors) +
            deviceHeight / 2;
        if (deviceTypes[i] == DeviceType.VRV) {
          deviceY = vrvY; // VRVの場合はRFのY座標を使用
        } else {}

        // 機器タイプに応じた描画ロジック
        switch (deviceTypes[i]) {
          case DeviceType.PAC:
          case DeviceType.HEX:
            // PACとHEXの場合は単純な四角形を描画（Y座標を調整）
            DrawingUtilities.drawDevice(
                canvas, paint, deviceXEnd, deviceY, deviceWidth, deviceHeight);

            if (deviceTypes[i] == DeviceType.HEX) {
              // HEXの場合は中に×を描画（Y座標を調整）
              drawXInsideBox(canvas, paint, deviceXEnd, deviceY, deviceWidth,
                  deviceHeight);
            }

          case DeviceType.VRV:
            // VRVの場合は縦横比2:1の四角形をRFの線上に描画
            DrawingUtilities.drawDevice(canvas, paint, deviceXEnd, vrvY,
                controlBoardHeight / 2, controlBoardHeight);
            // VRV機器の上辺からの縦配線
            String selectedBoard = remoteBoardSelections[i];
            double boardX, boardY;
            switch (selectedBoard) {
              case "制御盤":
                boardX = controlBoardX;
                boardY = CoordinateCalculations.calculateYPosition(
                    controlBoardFloor, size, totalFloors);
                break;
              case "RS1":
                boardX = RSBoard1X;
                boardY = CoordinateCalculations.calculateYPosition(
                    RSBoardFloor1, size, totalFloors);
                break;
              case "RS2":
                boardX = RSBoard2X;
                boardY = CoordinateCalculations.calculateYPosition(
                    RSBoardFloor2, size, totalFloors);
                break;
              default:
                boardX = controlBoardX;
                boardY = CoordinateCalculations.calculateYPosition(
                    controlBoardFloor, size, totalFloors);
            }

            canvas.drawLine(Offset(deviceXEnd, vrvY - vrvDeviceHeight),
                Offset(deviceXEnd, vrvY - vrvDeviceHeight / 2), paint);

            break;
        }

        if (deviceCounts[i] != null) {
          // 機器の数を描画
          TextSpan span = new TextSpan(
              style: new TextStyle(color: Colors.black),
              text: 'x${deviceCounts[i]}台');
          TextPainter tp = new TextPainter(
              text: span,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr);
          tp.layout();
          tp.paint(canvas,
              new Offset(deviceXEnd - 10, deviceY + deviceHeight / 2 + 5));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
