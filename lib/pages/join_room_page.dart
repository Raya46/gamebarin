// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:gamebarin/games/game_playing_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({Key? key}) : super(key: key);

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  late IO.Socket _socket;

  connect() {
    _socket = IO.io('http://10.10.18.100:3000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    _socket.connect();
  }

  void joinRoom() async {
    try {
      await connect();
      if (_nameController.text.isNotEmpty &&
          _roomNameController.text.isNotEmpty) {
        Map<String, String> data = {
          "nickname": _nameController.text,
          "name": _roomNameController.text
        };
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GamePlayingPage(
                    data: data,
                    screenFrom: "joinRoom",
                    socket: _socket,
                  )),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Join Room",
                  style: GoogleFonts.blackOpsOne(fontSize: 40),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Player Name",
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: GoogleFonts.blackOpsOne(),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(
                      Icons.person,
                      size: 24.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                TextFormField(
                  controller: _roomNameController,
                  decoration: InputDecoration(
                    labelText: "Room Name",
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: GoogleFonts.blackOpsOne(),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(
                      Icons.meeting_room,
                      size: 24.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                ElevatedButton.icon(
                    icon: const Icon(Icons.door_sliding, color: Colors.black),
                    label: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        "Join",
                        style: GoogleFonts.blackOpsOne(
                            fontSize: 30, color: Colors.black),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(64.0),
                          side: const BorderSide(width: 2)),
                    ),
                    onPressed: joinRoom),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.cancel, color: Colors.black),
                  label: Text(
                    "Cancel",
                    style: GoogleFonts.blackOpsOne(
                        fontSize: 30, color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(64.0),
                        side: const BorderSide(width: 2)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
