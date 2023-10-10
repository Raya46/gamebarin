import 'package:flutter/material.dart';
import 'package:gamebarin/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
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
                Stack(
                  children: [
                    Text(
                      'Game',
                      style: TextStyle(
                        fontFamily: 'Super Boys',
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = Colors.black,
                      ),
                    ),
                    Text(
                      'Game',
                      style: TextStyle(
                        fontFamily: 'Super Boys',
                        letterSpacing: 4.0,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF75CFFF),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Text(
                      'Barin',
                      style: TextStyle(
                        letterSpacing: 4.0,
                        fontFamily: 'Super Boys',
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = Colors.black,
                      ),
                    ),
                    Text(
                      'Barin',
                      style: TextStyle(
                        letterSpacing: 4.0,
                        fontFamily: 'Super Boys',
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFBF00),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
