import 'package:flutter/material.dart';
import 'package:design_request_app/screens/detailed_question_page.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final Map<String, String> _equipmentToQuestionsMapping = {
    '空調設備': 'ビル用マルチエアコンの取り込みはありますか,店舗用エアコンの取り込みはありますか,ルームエアコンの取り込みはありますか',
    '換気設備': '全熱交換器の取り込みはありますか,給気ファンの取り込みはありますか,排気ファンの取り込みはありますか',
    '衛生設備': '受水槽の取り込みはありますか,排水槽の取り込みはありますか,その他衛生設備の取り込みはありますか',
    '電気設備': '電気設備の取り込みはありますか',
    '消火設備': '消防設備の取り込みはありますか',
  };

  final _answers = <String, dynamic>{};
  late final Map<String, String> _generatedQuestions; // 追加

  @override
  void initState() {
    super.initState();
    _generatedQuestions = _generateQuestions(); // 追加
    _generatedQuestions.keys.forEach((key) {
      // 変更
      _answers[key] = 'N';
    });
  }

  Map<String, String> _generateQuestions() {
    int questionCounter = 1;
    final Map<String, String> questions = {};

    _equipmentToQuestionsMapping.forEach((equipment, questionList) {
      for (var question in questionList.split(',')) {
        final key = '質問${questionCounter++}';
        questions[key] = question;
      }
    });

    return questions;
  }

  void _setAnswer(String key, dynamic value) {
    setState(() {
      _answers[key] = value;
    });
  }

  Widget _buildSection(String title, List<String> questions) {
    Color categoryColor; // カテゴリーごとの色設定
    switch (title) {
      case '空調設備':
        categoryColor = Color(0xFF00A0E4); // Vivid Cerulean Blue
        break;
      case '換気設備':
        categoryColor = Color(0xFF5CA4D6); // 濃いライトスカイブルー
        break;
      case '衛生設備':
        categoryColor = Color(0xFF7ECB78); // 濃いペールグリーン
        break;
      case '電気設備':
        categoryColor = Color(0xFFD4A300); // 濃いゴールド
        break;
      case '消火設備':
        categoryColor = Color(0xFFD43700); // 濃いオレンジレッド
        break;
      default:
        categoryColor = Color(0xFF2A9D2A); // 濃いライムグリーン
    }

  final questionWidgets = <Widget>[];

  // タイトルを含む全体の枠を作成
    questionWidgets.add(Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEAFAEA), // 背景色を指定された色に変更
        border: Border.all(color: categoryColor),
        borderRadius: BorderRadius.circular(10),
      ),
    child: Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: categoryColor),
        ),
        ...questions.map((questionKey) {
          final questionText = _generatedQuestions[questionKey];
          return questionText != null
              ? Row(
                  children: [
                    Expanded(
                      child: Text(questionText),
                    ),
                    VerticalDivider(color: categoryColor), // 縦のラインで区分
                    DropdownButton<String>(
                      value: _answers[questionKey],
                      items: <String>['Y', 'N']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => _setAnswer(questionKey, value),
                    ),
                  ],
                )
              : SizedBox.shrink();
        }).toList(),
      ],
    ),
  ));

  return Column(children: questionWidgets);
}
  @override
  Widget build(BuildContext context) {
    final questions = _generatedQuestions; // 変更
    final questionKeys = questions.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('依頼ページ'),
        backgroundColor: Color(0xFF008080), // Teal color for the AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          // 背景画像を設定
          image: DecorationImage(
            image: AssetImage("assets/back_image1.webp"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          // 背景画像に合わせたスクロールビューの背景色
          children: _equipmentToQuestionsMapping.keys.map((equipment) {
            final equipmentQuestions = _equipmentToQuestionsMapping[equipment]!;
            final equipmentQuestionKeys = questionKeys
                .where((key) =>
            questions[key] != null &&
                equipmentQuestions.contains(questions[key]!))
                .toList();
            return _buildSection(equipment, equipmentQuestionKeys);
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailedQuestionPage(_answers),
            ),
          );
        },
        backgroundColor: Color(0xFF32CD32), // Lime Green color for the FAB
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}