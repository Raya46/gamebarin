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
      body: Stack(children: [
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
        Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create Room",
                style: GoogleFonts.blackOpsOne(fontSize: 40),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Your Name",
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
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Room Name",
                  labelStyle: GoogleFonts.blackOpsOne(),
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled:
                            true, // Untuk mengisi latar belakang dengan warna
                        fillColor: Colors
                            .white, // Warna latar belakang yang Anda inginkan
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
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
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled:
                            true, // Untuk mengisi latar belakang dengan warna
                        fillColor: Colors
                            .white, // Warna latar belakang yang Anda inginkan
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
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
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              ElevatedButton.icon(
                  icon: const Icon(Icons.create_sharp, color: Colors.black),
                  label: Text(
                    "Create",
                    style: GoogleFonts.blackOpsOne(
                        fontSize: 30, color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(64.0),
                        side: const BorderSide(width: 2)),
                  ),
                  onPressed: createRoom),
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
      ]),
    );
  }
}
