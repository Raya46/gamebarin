import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:gamebarin/widgets/text_outlined.dart';
import 'package:google_fonts/google_fonts.dart';

class FinalLeaderboard extends StatefulWidget {
  final scoreboard;
  final String screenForm;
  final String winner;
  final Map dataOfRoom;
  final Map<String, String> data;
  bool isShowFinalLeaderboard;
  FinalLeaderboard(this.scoreboard, this.winner, this.dataOfRoom, this.data,
      this.isShowFinalLeaderboard, this.screenForm);

  @override
  State<FinalLeaderboard> createState() => _FinalLeaderboardState();
}

class _FinalLeaderboardState extends State<FinalLeaderboard> {
  late ConfettiController _confettiController;
  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(milliseconds: 800));
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
        child: Container(
          padding: const EdgeInsets.all(8),
          height: double.maxFinite,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 80.0,
                  right: 80.0,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: Image.asset('assets/gold-medal.png'),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextOutlined(
                                primary: widget.winner,
                                secondary: widget.winner,
                                sizeFont: 40.0,
                                textColor: Color(0xFF75CFFF)),
                            TextOutlined(
                                primary: ' is winner',
                                secondary: ' is winner',
                                sizeFont: 40.0,
                                textColor: Color(0xFFFFBF00)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: -pi / 4,
                  emissionFrequency: 0.2,
                  numberOfParticles: 10,
                  blastDirectionality: BlastDirectionality.explosive,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: -pi / 4,
                  emissionFrequency: 0.2,
                  numberOfParticles: 10,
                  blastDirectionality: BlastDirectionality.explosive,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              ListView.builder(
                primary: true,
                shrinkWrap: true,
                itemCount: widget.scoreboard.length,
                itemBuilder: (context, index) {
                  var data = widget.scoreboard[index].values;
                  return Card(
                    child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            child: Text('${data.elementAt(2)}'),
                          ),
                          Text(
                            'LEVEL',
                            style: GoogleFonts.blackOpsOne(fontSize: 8),
                          ),
                        ],
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data.elementAt(0)}',
                            style: GoogleFonts.blackOpsOne(fontSize: 20),
                          ),
                          Text(
                            '${data.elementAt(3) ?? 'afk'}',
                            style: GoogleFonts.blackOpsOne(
                                fontSize: 13,
                                color: widget.scoreboard[index]['tier'] ==
                                        'Noob'
                                    ? Colors.grey
                                    : widget.scoreboard[index]['tier'] ==
                                            'Intermediate'
                                        ? Colors.green
                                        : widget.scoreboard[index]['tier'] ==
                                                'Expert'
                                            ? Colors.deepOrangeAccent
                                            : Colors.greenAccent),
                          )
                        ],
                      ),
                      trailing: Text(
                        '${data.elementAt(1)}🌟',
                        style: GoogleFonts.blackOpsOne(fontSize: 20),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
