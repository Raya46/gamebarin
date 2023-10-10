import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamebarin/models/touch_points.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PlayerDrawer extends StatefulWidget {
  final List<Map> userData;
  final Map dataOfRoom;
  final Map<String, String> data;
  late IO.Socket socket;
  List<TouchPoints> points = [];
  Timer _timer;

  PlayerDrawer(this.userData, this.dataOfRoom, this.socket, this._timer,
      this.data, this.points);

  @override
  State<PlayerDrawer> createState() => _PlayerDrawerState();
}

class _PlayerDrawerState extends State<PlayerDrawer> {
  bool isButtonClicked = false;
  void _showModal(BuildContext context, String player, int playerIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report'),
          content: Text('Report player $player?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Report'),
              onPressed: () {
                widget.socket.emit('change-turn', widget.dataOfRoom['name']);
              },
            ),
          ],
        );
      },
    );
  }

  bool isDrawingPlayer(int index) {
    return widget.dataOfRoom['turn']['nickname'] ==
        widget.userData[index]['username'];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: Container(
          height: double.maxFinite,
          child: ListView.builder(
            itemCount: widget.userData.length,
            itemBuilder: (context, index) {
              var data = widget.userData[index].values;
              return Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data.elementAt(0)),
                    Row(
                      children: [
                        if (isDrawingPlayer(index))
                          const Icon(
                            Icons.create,
                            size: 24.0,
                            color:
                                Colors.blue, // Ubah warna sesuai keinginan Anda
                          ),
                        Text(isDrawingPlayer(index) ? '' : data.elementAt(1)),
                        if (isDrawingPlayer(index) && widget.points.isNotEmpty)
                          IconButton(
                            onPressed: () {
                              // print(index);
                              _showModal(context, data.elementAt(0), index);
                            },
                            icon: const Icon(
                              Icons.report,
                              size: 24.0,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
