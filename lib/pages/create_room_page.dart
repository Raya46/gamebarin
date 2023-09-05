// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:gamebarin/games/game_playing_page.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({Key? key}) : super(key: key);

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  late String? _maxRoundsValue;
  late String? _roomSizeValue;

  void createRoom() {
    // if (_nameController.text.isEmpty &&
    //     _roomNameController.text.isEmpty &&
    //     _maxRoundsValue != null &&
    //     _roomSizeValue != null) {
    Map<String, String> data = {
      "nickname": _nameController.text,
      "name": _roomNameController.text,
      "occupancy": _maxRoundsValue!,
      "maxRounds": _roomSizeValue!
    };
    print(data);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              GamePlayingPage(data: data, screenFrom: "createRoom")),
    );
    // }
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
              "Create Room",
              style: GoogleFonts.blackOpsOne(fontSize: 20),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Your Name",
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
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            DropdownButton<String>(
              hint: Text(
                'Select Max Rounds',
                style: GoogleFonts.blackOpsOne(),
              ), // Placeholder
              onChanged: (String? newValue) {
                setState(() {
                  _maxRoundsValue = newValue;
                });
              },
              items: <String>['2', '5', '10', '15']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
            DropdownButton<String>(
              hint: Text(
                'Select Max Player',
                style: GoogleFonts.blackOpsOne(),
              ), // Placeholder
              onChanged: (String? newValue) {
                setState(() {
                  _roomSizeValue = newValue;
                });
              },
              items: <String>['2', '3', '4', '5', '6', '7', '8']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    child: Text(
                      "Create",
                      style: GoogleFonts.blackOpsOne(fontSize: 30),
                    ),
                    onPressed: createRoom),
                ElevatedButton(
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.blackOpsOne(fontSize: 30),
                    ),
                    onPressed: Navigator.of(context).pop),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
