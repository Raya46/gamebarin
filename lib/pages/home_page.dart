import 'package:flutter/material.dart';
import 'package:gamebarin/pages/create_room_page.dart';
import 'package:gamebarin/pages/join_room_page.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gambar latar belakang
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
          // Konten Anda di atas latar belakang
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.draw,
                      size: 46.0,
                    ),
                    Text(
                      "Gamebarin",
                      style: GoogleFonts.blackOpsOne(fontSize: 40),
                    ),
                  ],
                ),

                // Image.asset('assets/logogamebarin.png', fit: BoxFit.cover),
                Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  elevation: 5,
                  child: Column(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(width: 2),
                        ),
                        color: Colors.blue[100],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Draw, Guess, Win",
                            style: GoogleFonts.blackOpsOne(fontSize: 20),
                          ),
                        ),
                      ),
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
                            style: GoogleFonts.blackOpsOne(
                                fontSize: 30, color: Colors.black),
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
                          label: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Text(
                              "Join",
                              style: GoogleFonts.blackOpsOne(
                                  fontSize: 30, color: Colors.black),
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
