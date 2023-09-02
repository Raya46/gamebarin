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
      backgroundColor: Colors.blue[500],
      body: Center(
        child: Card(
          color: Colors.blueGrey,
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
        ), // Ganti dengan path gambar Anda
      ),
    );
  }
}
