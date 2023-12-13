import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ConfirmationPage extends StatelessWidget {
  final Map<String, dynamic> answers;
  final Map<String, String> selectedImages;
  final TextEditingController companyController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  ConfirmationPage(this.answers, this.selectedImages);

  void _copyToClipboard(String textToCopy) {
    Clipboard.setData(ClipboardData(text: textToCopy));
  }

  // 日付選択ダイアログを表示
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // 初期値は現在の日付
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dueDateController.text =
          DateFormat('yyyy-MM-dd').format(picked); // 選択された日付をフォーマットして設定
    }
  }

  // メールを送る処理
  Future<void> launchMailto() async {
    final mail = Mailto(
      to: ['example@example.com'],
      subject: 'DK-System作図依頼',
      body: generateMailBody(),
    );
    final String mailtoUrl = mail.toString();
    if (await canLaunch(mailtoUrl)) {
      await launch(mailtoUrl);
    } else {
      throw 'Could not launch $mailtoUrl';
    }
  }

  // メール本文を生成する処理
  String generateMailBody() {
    final selectedQuestions =
    answers.keys.where((key) => answers[key] == 'Y').toList();
    final buffer = StringBuffer();

    buffer.write('作図依頼\n\n');
    buffer.write('会社名：${companyController.text}\n');
    buffer.write('担当名：${nameController.text}\n');
    buffer.write('提出希望日：${dueDateController.text}\n\n');
    buffer.write('依頼内容：\n');

    buffer.write('{\n');
    for (final key in selectedQuestions) {
      buffer.write('  "$key": "${selectedImages[key] ?? '未選択'}",\n');
    }
    buffer.write('}\n');

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final filteredKeys =
    answers.keys.where((key) => answers[key] == 'Y').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('確認ページ'),
        backgroundColor: Color(0xFF008080), // Teal color for the AppBar
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredKeys.length,
              itemBuilder: (context, index) {
                final key = filteredKeys[index];
                final value = answers[key];
                final imagePath = selectedImages[key] ?? 'assets/no_image.png';

                return ListTile(
                  title: Text('$key: $value'),
                  trailing: Image.asset(imagePath),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: companyController,
              decoration: InputDecoration(
                labelText: '会社名',
                border: OutlineInputBorder(), // 枠線を追加
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: '担当名'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dueDateController,
                    decoration: InputDecoration(labelText: '提出希望日'),
                    readOnly: true, // 読み取り専用にする
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: launchMailto,
            child: Text('メールを送る'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF32CD32), // Lime Green color for the button
            ),
          ),
        ],
      ),
    );
  }
}