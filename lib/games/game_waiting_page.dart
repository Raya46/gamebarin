// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              "waiting ${widget.occupancy - widget.numberOfPlayers} players to join"),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            readOnly: true,
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget.lobbyName));
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("copied!")));
            },
            autocorrect: false,
            decoration: const InputDecoration(
              filled: true,
              fillColor: const Color(0xffF5F5FA),
              hintText: "Tap to copy room name",
              border: OutlineInputBorder(),
              suffixIcon: Icon(
                Icons.person,
                size: 24.0,
              ),
            ),
            textInputAction: TextInputAction.done,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        Text("players: "),
        ListView.builder(
          primary: true,
          shrinkWrap: true,
          itemCount: widget.numberOfPlayers,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text("${index + 1}"),
              title: Text(widget.players[index]['nickname']),
            );
          },
        )
      ],
    ));
  }
}
