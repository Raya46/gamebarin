// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamebarin/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GameWaitingScreen extends StatefulWidget {
  final int occupancy;
  final int numberOfPlayers;
  final String lobbyName;
  final players;
  const GameWaitingScreen(
      {super.key,
      required this.occupancy,
      required this.numberOfPlayers,
      required this.lobbyName,
      this.players});

  @override
  State<GameWaitingScreen> createState() => _GameWaitingScreenState();
}

class _GameWaitingScreenState extends State<GameWaitingScreen> {
  late IO.Socket _socket;

  @override
  void initState() {
    connect();
    super.initState();
  }

  connect() {
    _socket = IO.io('http://10.10.18.100:3000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    _socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/bg-pattern.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: Colors.blue.withOpacity(0.5),
        ),
        SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      await connect();
                      _socket.emit("delete-document", {
                        'collectionName': 'rooms',
                        'documentName': widget.lobbyName
                      });
                      print(widget.lobbyName);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
                    child: Card(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(width: 2),
                        ),
                        color: Colors.blue[100],
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 40,
                          ),
                        )),
                  ),
                  Card(
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(width: 2),
                    ),
                    color: Colors.blue[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Players",
                        style: GoogleFonts.blackOpsOne(
                            fontSize: 20, letterSpacing: 24),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Room Name: ${widget.lobbyName}',
                  style: GoogleFonts.blackOpsOne(fontSize: 20),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: widget.lobbyName));
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("copied!")));
                  },
                  child: CircleAvatar(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.copy)),
                  ),
                ),
              ]),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    primary: true,
                    shrinkWrap: true,
                    itemCount: widget.numberOfPlayers,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(width: 2),
                        ),
                        color: Colors.yellow[300],
                        child: ListTile(
                          leading: Text(
                            "${index + 1}",
                            style: GoogleFonts.blackOpsOne(fontSize: 20),
                          ),
                          title: Text(
                            widget.players[index]['nickname'],
                            style: GoogleFonts.blackOpsOne(fontSize: 20),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "waiting ${widget.occupancy - widget.numberOfPlayers} players to join",
                    style: GoogleFonts.blackOpsOne(fontSize: 15),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
