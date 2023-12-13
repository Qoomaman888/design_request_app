import 'package:flutter/material.dart';
import 'package:design_request_app/screens/drawing_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('初期画面'),
        backgroundColor: Color(0xFF008080), // Teal color for the AppBar
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DrawingPage(), // RequestPageからDrawingPageに変更
              ),
            );
          },
          child: Text('依頼する'),
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF32CD32), // Lime Green color for the button
          ),
        ),
      ),
    );
  }
}
