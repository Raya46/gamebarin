import 'package:flutter/material.dart';
import 'package:gamebarin/pages/create_room_page.dart';
import 'package:gamebarin/pages/join_room_page.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Text(
                          'Game',
                          style: TextStyle(
                            fontFamily: 'Super Boys',
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4.0,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black,
                          ),
                        ),
                        Text(
                          'Game',
                          style: TextStyle(
                            fontFamily: 'Super Boys',
                            letterSpacing: 4.0,
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
                          'Barin',
                          style: TextStyle(
                            letterSpacing: 4.0,
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
                          'Barin',
                          style: TextStyle(
                            letterSpacing: 4.0,
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
                Text(
                  'Draw, Guess, Win',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  elevation: 5,
                  child: Column(children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Image.asset(
                      'assets/txtdraw.png',
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.create_sharp,
                              color: Colors.black),
                          label: Text(
                            "Create",
                            style: TextStyle(
                              fontFamily: 'Super Boys',
                              fontSize: 30.0,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[300],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(64.0),
                                side: const BorderSide(width: 2)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreateRoomPage()),
                            );
                          },
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.door_sliding,
                            color: Colors.black,
                          ),
                          label: Text(
                            "Join",
                            style: TextStyle(
                              fontFamily: 'Super Boys',
                              fontSize: 30.0,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow[300],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(64.0),
                                side: const BorderSide(width: 2)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const JoinRoomPage()),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
