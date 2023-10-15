import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:gamebarin/widgets/text_outlined.dart';

class LoadingWinnerScreen extends StatefulWidget {
  const LoadingWinnerScreen({super.key});

  @override
  State<LoadingWinnerScreen> createState() => _LoadingWinnerScreenState();
}

class _LoadingWinnerScreenState extends State<LoadingWinnerScreen> {
  late ConfettiController _confettiController;
  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(milliseconds: 800));
    _confettiController.play();
  }

  @override
  void dispose() {
    super.dispose();
    _confettiController.dispose();
  }

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
                  primary: 'The ',
                  secondary: 'The ',
                  sizeFont: 40,
                  textColor: Color(0xFF75CFFF),
                ),
                Align(
                  alignment: Alignment.center,
                  child: ConfettiWidget(
                    shouldLoop: true,
                    confettiController: _confettiController,
                    blastDirection: -pi / 4,
                    emissionFrequency: 0.2,
                    numberOfParticles: 10,
                    blastDirectionality: BlastDirectionality.explosive,
                  ),
                ),
                TextOutlined(
                    primary: 'Winner is ...',
                    secondary: 'Winner is ...',
                    sizeFont: 40.0,
                    textColor: Color(0xFFFFBF00)),
                Align(
                  alignment: Alignment.centerRight,
                  child: ConfettiWidget(
                    shouldLoop: true,
                    confettiController: _confettiController,
                    blastDirection: -pi / 4,
                    emissionFrequency: 0.2,
                    numberOfParticles: 10,
                    blastDirectionality: BlastDirectionality.explosive,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
