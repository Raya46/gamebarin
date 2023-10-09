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
                const Icon(
                  Icons.draw,
                  size: 46.0,
                ),
                Text(
                  "Gamebarin",
                  style: GoogleFonts.blackOpsOne(fontSize: 40),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
