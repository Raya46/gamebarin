import 'package:flutter/material.dart';

class FinalLeaderboard extends StatelessWidget {
  final scoreboard;
  final String winner;
  FinalLeaderboard(this.scoreboard, this.winner);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8),
        height: double.maxFinite,
        child: Column(
          children: [
            ListView.builder(
              primary: true,
              shrinkWrap: true,
              itemCount: scoreboard.length,
              itemBuilder: (context, index) {
                var data = scoreboard[index].values;
                return ListTile(
                  title: Text(data.elementAt(0)),
                  trailing: Text(data.elementAt(1)),
                );
              },
            ),
            Text("$winner is the winner")
          ],
        ),
      ),
    );
  }
}
