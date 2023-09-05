// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:gamebarin/games/game_playing_page.dart';
import 'package:google_fonts/google_fonts.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({Key? key}) : super(key: key);

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();

  void joinRoom() {
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
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Join Room",
              style: GoogleFonts.blackOpsOne(fontSize: 20),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Player Name",
                hintText: "Username",
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
              decoration: const InputDecoration(
                labelText: "Room Name",
                hintText: "Room",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    child: Text(
                      "Join",
                      style: GoogleFonts.blackOpsOne(fontSize: 30),
                    ),
                    onPressed: joinRoom),
                ElevatedButton(
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.blackOpsOne(fontSize: 30),
                    ),
                    onPressed: Navigator.of(context).pop),
              ],
            )
          ],
        ),
      ),
    );
  }
}
