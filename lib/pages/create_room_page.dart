// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:gamebarin/games/game_playing_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  late IO.Socket _socket;

  connect() {
    _socket = IO.io('http://10.10.18.177:3000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    _socket.connect();
  }

  void createRoom() async {
    try {
      await connect();
      if (_nameController.text.isNotEmpty &&
          _roomNameController.text.isNotEmpty &&
          _maxRoundsValue != null &&
          _roomSizeValue != null) {
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
              builder: (context) => GamePlayingPage(
                    data: data,
                    screenFrom: "createRoom",
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
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            'assets/bg.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: Colors.blue.withOpacity(0.5),
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Text(
                        'Create ',
                        style: TextStyle(
                          fontFamily: 'Super Boys',
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = Colors.black,
                        ),
                      ),
                      Text(
                        'Create ',
                        style: TextStyle(
                          fontFamily: 'Super Boys',
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF75CFFF),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Text(
                        'Room',
                        style: TextStyle(
                          fontFamily: 'Super Boys',
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = Colors.black,
                        ),
                      ),
                      Text(
                        'Room',
                        style: TextStyle(
                          fontFamily: 'Super Boys',
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFBF00),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black, // Warna border
                    width: 2.0, // Ketebalan border
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Your Name",
                          labelStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black,
                                width: 5.0,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: const Icon(
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
                          labelStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black,
                                width: 5.0,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: const Icon(
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
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              hint: Text(
                                'Max Rounds',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800]),
                              ), // Placeholder
                              onChanged: (String? newValue) {
                                setState(() {
                                  _roomSizeValue = newValue;
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
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              hint: Text(
                                'Max Player',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800]),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _maxRoundsValue = newValue;
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
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              ElevatedButton.icon(
                  icon: const Icon(Icons.create_sharp, color: Colors.black),
                  label: Text("Create",
                      style: TextStyle(
                        fontFamily: "Super Boys",
                        color: Colors.black,
                        fontSize: 30,
                      )),
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
                label: Text("Cancel",
                    style: TextStyle(
                      fontFamily: "Super Boys",
                      color: Colors.black,
                      fontSize: 30,
                    )),
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
