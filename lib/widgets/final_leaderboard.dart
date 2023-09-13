import 'package:flutter/material.dart';
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
  int counter1 = 0;
  int counter2 = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
        child: Container(
          padding: const EdgeInsets.all(8),
          height: double.maxFinite,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Card(
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
                      Text(
                        "${widget.winner} is the winner",
                        style: GoogleFonts.blackOpsOne(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                primary: true,
                shrinkWrap: true,
                itemCount: widget.scoreboard.length,
                itemBuilder: (context, index) {
                  var data = widget.scoreboard[index].values;
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text(
                        data.elementAt(0),
                        style: GoogleFonts.blackOpsOne(fontSize: 20),
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
