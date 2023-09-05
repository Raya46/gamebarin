import 'package:flutter/material.dart';
import 'package:gamebarin/pages/create_room_page.dart';
import 'package:gamebarin/pages/home_page.dart';
import 'package:gamebarin/pages/join_room_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class FinalLeaderboard extends StatefulWidget {
  final IO.Socket _socket;
  final scoreboard;
  final String screenForm;
  final String winner;
  final Map dataOfRoom;
  final Map<String, String> data;
  bool isShowFinalLeaderboard;
  FinalLeaderboard(this.scoreboard, this.winner, this._socket, this.dataOfRoom,
      this.data, this.isShowFinalLeaderboard, this.screenForm);

  @override
  State<FinalLeaderboard> createState() => _FinalLeaderboardState();
}

class _FinalLeaderboardState extends State<FinalLeaderboard> {
  int counter1 = 0;
  int counter2 = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        height: double.maxFinite,
        child: Column(
          children: [
            ListView.builder(
              primary: true,
              shrinkWrap: true,
              itemCount: widget.scoreboard.length,
              itemBuilder: (context, index) {
                var data = widget.scoreboard[index].values;
                return ListTile(
                  title: Text(data.elementAt(0)),
                  trailing: Text(data.elementAt(1)),
                );
              },
            ),
            Text("${widget.winner} is the winner"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      widget.scoreboard.clear();
                      widget._socket.emit("delete-document", {
                        'collectionName': 'rooms',
                        'documentId': widget.dataOfRoom['_id']
                      });
                      print(widget.dataOfRoom['_id']);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
                    child: const Text('back to menu')),
                ElevatedButton(
                    onPressed: () async {
                      widget.data.clear();
                      widget.scoreboard.clear();
                      widget._socket.emit("delete-document", {
                        'collectionName': 'rooms',
                        'documentId': widget.dataOfRoom['_id']
                      });
                      widget.dataOfRoom.clear();
                      print(widget.dataOfRoom['_id']);
                      if (widget.screenForm == "createRoom") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CreateRoomPage()));
                        print(widget.data);
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const JoinRoomPage()));
                      }
                    },
                    child: const Text('play again'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
