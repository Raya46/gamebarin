import 'package:flutter/material.dart';
import 'package:gamebarin/widgets/text_outlined.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.blue.withOpacity(0.5),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextOutlined(
                  primary: 'Please ',
                  secondary: 'Please ',
                  sizeFont: 40,
                  textColor: Color(0xFF75CFFF),
                ),
                TextOutlined(
                    primary: 'Wait...',
                    secondary: 'Wait...',
                    sizeFont: 40.0,
                    textColor: Color(0xFFFFBF00)),
                CircularProgressIndicator()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
