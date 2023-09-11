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
              'assets/bg-pattern.jpg', // Ganti dengan path gambar latar belakang Anda
              fit: BoxFit.cover,
            ),
          ),
          // Latar belakang warna biru dengan opasitas
          Container(
            color: Colors.blue.withOpacity(
                0.5), // Ganti dengan warna dan opasitas yang diinginkan
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
            ), // Ganti dengan path gambar Anda
          ),
        ],
      ),
    );
  }
}
