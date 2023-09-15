import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PlayerDrawer extends StatefulWidget {
  final List<Map> userData;
  final Map dataOfRoom;
  late IO.Socket socket;
  late Timer _timer;

  PlayerDrawer(this.userData, this.dataOfRoom, this.socket, this._timer);

  @override
  State<PlayerDrawer> createState() => _PlayerDrawerState();
}

class _PlayerDrawerState extends State<PlayerDrawer> {
  void _showModal(BuildContext context, String player) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report'),
          content: Text('Report player $player?'),
          actions: <Widget>[
            TextButton(
              child: Text('Report'),
              onPressed: () {
                widget.socket.emit('change-turn', widget.dataOfRoom['name']);
                setState(() {
                  widget._timer.cancel();
                  // print(widget.dataOfRoom);
                });
              },
            ),
          ],
        );
      },
    );
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
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.dataOfRoom['turnIndex'] == 0
                      ? Text(data.elementAt(0) + 'is drawing')
                      : Text(data.elementAt(0)),
                  Row(
                    children: [
                      Text(data.elementAt(1)),
                      IconButton(
                        onPressed: () {
                          _showModal(context, data.elementAt(0));
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
      )),
    );
  }
}
