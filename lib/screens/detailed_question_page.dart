import 'package:flutter/material.dart';
import 'package:design_request_app/screens/confirmation_page.dart';
import 'package:design_request_app/utils/quantity_selector.dart';

class DetailedQuestionPage extends StatefulWidget {
  final Map<String, dynamic> answers;

  DetailedQuestionPage(this.answers);

  @override
  _DetailedQuestionPageState createState() => _DetailedQuestionPageState();
}

class _DetailedQuestionPageState extends State<DetailedQuestionPage> {
  final Map<String, String> _selectedImages = {};
  final Map<String, String> _selectedImageKeys = {}; // 新しく追加
  int _currentEquipmentIndex = 0;
  final _questionToEquipmentMapping = {
    '質問1': '空調設備',
    '質問2': '空調設備',
    '質問3': '空調設備',
    '質問4': '換気設備',
    '質問5': '換気設備',
    '質問6': '換気設備',
    '質問7': '衛生設備',
    '質問8': '衛生設備',
    '質問9': '衛生設備',
    '質問10': '電気設備',
    '質問11': '消火設備',
  };
  final Map<String, Map<String, dynamic>> _questionSettings = {
    '空調設備': {'imageCount': 2},
    '換気設備': {'imageCount': 2},
    '衛生設備': {'imageCount': 2},
    '電気設備': {'imageCount': 2},
    '消火設備': {'imageCount': 2},
  };

  void _setImageSelection(String questionKey, String imageKey) {
    final imagePath = _getImagePath(
        questionKey, int.parse(imageKey.replaceAll(RegExp(r'[^\d]'), '')));
    setState(() {
      _selectedImages[questionKey] = 'assets/$imagePath';
      _selectedImageKeys[questionKey] = imagePath.replaceFirst('.png', '');
    });
  }

  String _getImagePath(String questionKey, int index) {
    String? equipmentType = _questionToEquipmentMapping[questionKey];
    if (equipmentType == null) {
      return 'assets/no_image.png'; // 確認1: このパスが正確かどうか
    }
    String typeAbbreviation;
    switch (equipmentType) {
      case '空調設備':
        typeAbbreviation = 'AC';
        break;
      case '換気設備':
        typeAbbreviation = 'Ven';
        break;
      case '衛生設備':
        typeAbbreviation = 'San';
        break;
      case '電気設備':
        typeAbbreviation = 'Ele';
        break;
      case '消火設備':
        typeAbbreviation = 'Fire';
        break;
      default:
        return 'assets/no_image.png';
    }

    if (index == 0) {
      return 'no_image.png'; // 'assets/' を除く
    }

    // 設備機器ごとに質問番号をリセット
    final questionNumber = questionKey.replaceAll(RegExp(r'[^\d]'), '');
    final equipmentQuestions = _questionToEquipmentMapping.keys
        .where((k) => _questionToEquipmentMapping[k] == equipmentType)
        .toList();
    final resetQuestionNumber =
        (equipmentQuestions.indexOf(questionKey) + 1).toString();

    final String path =
        '${typeAbbreviation}_${resetQuestionNumber}_${index}.png';

    return path; // 'assets/' を削除
  }

  Widget buildQuestionSection(String questionKey) {
    String? equipmentType = _questionToEquipmentMapping[questionKey];
    Color categoryColor; // カテゴリーごとの色設定
    switch (equipmentType) {
      case '空調設備':
        categoryColor = Color(0xFF00A0E4); // Vivid Cerulean Blue
        break;
      case '換気設備':
        categoryColor = Color(0xFF008080); // Teal
        break;
      case '衛生設備':
        categoryColor = Color(0xFF32CD32); // Lime Green
        break;
      // 他のカテゴリーの色設定も同様に追加
      default:
        categoryColor = Colors.grey; // デフォルト色
    }

    final itemCount =
        (_questionSettings[equipmentType]?['imageCount'] ?? 0) + 1;

    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white, // 白い背景
        border: Border.all(color: categoryColor), // カテゴリーの色に合わせた枠
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            questionKey,
            style: TextStyle(color: categoryColor),
          ),
          SizedBox(height: 8.0),
          // 画像のリストビュー
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                final imageKey = index == 0 ? 'no_image.png' : 'image$index';
                final imagePath = _getImagePath(questionKey, index);

                return GestureDetector(
                  onTap: () {
                    print(
                        'selectedImageKeys[questionKey]: ${_selectedImageKeys[questionKey]}');
                    print('imageKey: $imageKey');
                    print("Image tapped: $questionKey, $imageKey"); // デバッグプリント
                    _setImageSelection(questionKey, imageKey);
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedImageKeys[questionKey] == imageKey
                            ? Colors.blue // 選択された画像のボーダーカラー
                            : Colors.grey, // 選択されていない画像のボーダーカラー
                        width: 2,
                      ),
                    ),
                    child: Image.asset(imagePath),
                  ),
                );
              },
            ),
          ),
          // ここに追加質問や入力フォームを追加
          _buildQuantitySelector(questionKey), // 例: 数量セレクター
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(String questionKey) {
    String? selectedImageKey = _selectedImageKeys[questionKey];
    print(
        'Building QuantitySelector for $questionKey with key $selectedImageKey'); // デバッグ出力
    if (selectedImageKey == null) {
      return SizedBox.shrink();
    }

    String title;
    switch (selectedImageKey) {
      case 'AC_1_1':
        title = '空調設備の台数';
        break;
      case 'Ven_1_1':
        title = '換気設備の台数';
        break;
      // 他の画像キーに対するタイトルをここに追加
      default:
        return SizedBox.shrink();
    }

    return Column(
      children: [
        QuantitySelector(
          title: title,
          onQuantityChanged: (quantity) {
            // 台数変更時の処理
          },
        ),
        // ここに他の質問入力フォームを追加
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final keysList =
        widget.answers.keys.where((key) => widget.answers[key] == 'Y').toList();
    final Map<String, List<String>> groupedQuestions = {
      '空調設備': [],
      '換気設備': [],
      '衛生設備': [],
      '電気設備': [],
      '消火設備': [],
    };

    // グループ化された質問を作成
    for (final key in keysList) {
      final equipmentType = _questionToEquipmentMapping[key];
      if (equipmentType != null) {
        groupedQuestions[equipmentType]?.add(key);
      }
    }

    final equipmentTypes = groupedQuestions.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('詳細質問ページ - ${equipmentTypes[_currentEquipmentIndex]}'),
        backgroundColor: Color(0xFF008080), // Teal color for the AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back_image1.webp"),
            fit: BoxFit.cover, // 画像が全体にフィットするように調整
          ),
        ),
        child: _currentEquipmentIndex < equipmentTypes.length
            ? ListView(
                children: (groupedQuestions[
                                equipmentTypes[_currentEquipmentIndex]] ??
                            [])
                        .isEmpty
                    ? [Center(child: Text('選択なし'))]
                    : (groupedQuestions[
                                equipmentTypes[_currentEquipmentIndex]] ??
                            [])
                        .map((questionKey) => Column(
                              children: [
                                buildQuestionSection(questionKey), // 既存の質問セクション
                                _buildQuantitySelector(
                                    questionKey), // QuantitySelectorを追加
                                // 他の入力フォームやUI要素をここに追加
                              ],
                            ))
                        .toList(),
              )
            : Center(child: Text('質問は以上です。')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentEquipmentIndex < equipmentTypes.length - 1) {
            setState(() {
              _currentEquipmentIndex++;
            });
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ConfirmationPage(widget.answers, _selectedImages),
              ),
            );
          }
        },
        backgroundColor: Color(0xFF32CD32), // Lime Green color for the FAB
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}
