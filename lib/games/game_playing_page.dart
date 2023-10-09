// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gamebarin/games/game_waiting_page.dart';
import 'package:gamebarin/models/my_custom_painter.dart';
import 'package:gamebarin/models/touch_points.dart';
import 'package:gamebarin/pages/home_page.dart';
import 'package:gamebarin/widgets/final_leaderboard.dart';
import 'package:gamebarin/widgets/player_leaderboard_drawer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GamePlayingPage extends StatefulWidget {
  final Map<String, String> data;
  final String screenFrom;
  late IO.Socket socket;
  GamePlayingPage(
      {Key? key,
      required this.data,
      required this.screenFrom,
      required this.socket})
      : super(key: key);

  @override
  State<GamePlayingPage> createState() => _GamePlayingPageState();
}

class _GamePlayingPageState extends State<GamePlayingPage> {
  List<TouchPoints> points = [];
  Map dataOfRoom = {};
  StrokeCap strokeType = StrokeCap.round;
  double strokeWidth = 2.0;
  double opacity = 1;
  Color selectedColor = Colors.black;
  List<Widget> blankText = [];
  final ScrollController _chatScrollController = ScrollController();
  List<Map> messages = [];
  final TextEditingController _messageTextController = TextEditingController();
  int guessedTurn = 0;
  int _start = 60;
  late Timer _timer;
  List<Map> scoreboard = [];
  bool isTextReadonly = false;
  int maxPoints = 0;
  String winner = '';
  bool isShowFinalLeaderboard = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    try {
      connect();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {});
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  void startTimer() {
    const second = const Duration(seconds: 1);
    _timer = Timer.periodic(second, (Timer timer) {
      if (_start == 0) {
        widget.socket.emit('change-turn', dataOfRoom['name']);
        setState(() {
          _timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void renderBlankText(String text) {
    blankText.clear();
    for (int i = 0; i < text.length; i++) {
      blankText.add(const Text(
        '_',
        style: TextStyle(
            fontSize: 30,
            fontFamily: "Super Boys",
            color: Colors.black,
            fontWeight: FontWeight.bold),
      ));
    }
  }

  void connect() {
    widget.socket = IO.io('http://10.10.18.152:3000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    widget.socket.connect();

    if (widget.screenFrom == "createRoom") {
      widget.socket.emit("create-game", widget.data);
    } else {
      widget.socket.emit("join-game", widget.data);
    }

    widget.socket.onConnect((data) {
      print("connected");
      widget.socket.on('updateRoom', (roomData) {
        print(roomData['word']);
        setState(() {
          renderBlankText(roomData['word']);
          dataOfRoom = roomData;
        });
        if (roomData['isJoin'] != true) {
          startTimer();
        }
        scoreboard.clear();
        for (int i = 0; i < roomData['players'].length; i++) {
          setState(() {
            scoreboard.add({
              'username': roomData['players'][i]['nickname'],
              'points': roomData['players'][i]['points'].toString(),
            });
          });
        }
      });

      widget.socket.on('msg', (msgData) {
        setState(() {
          messages.add(msgData);
          guessedTurn = msgData['guessedTurn'];
        });
        if (guessedTurn == dataOfRoom['players'].length - 1) {
          widget.socket.emit('change-turn', dataOfRoom['name']);
        }
        _chatScrollController.animateTo(
            _chatScrollController.position.maxScrollExtent + 40,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut);
      });

      widget.socket.on('change-turn', (data) {
        String oldWord = dataOfRoom['word'];
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 3), () {
                setState(() {
                  dataOfRoom = data;
                  renderBlankText(data['word']);
                  isTextReadonly = false;
                  guessedTurn = 0;
                  _start = 60;
                  points.clear();
                });
                Navigator.pop(context);
                _timer.cancel();
                startTimer();
              });
              return AlertDialog(
                title: Center(child: Text("word was $oldWord")),
              );
            });
      });

      widget.socket.on(
          'notCorrectGame',
          (data) => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (route) => false));

      widget.socket.on('points', (point) {
        if (point['details'] != null) {
          setState(() {
            points.add(TouchPoints(
                points: Offset((point['details']['dx']).toDouble(),
                    (point['details']['dy']).toDouble()),
                paint: Paint()
                  ..strokeCap = strokeType
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        }
      });

      widget.socket.on('update-score', (roomData) {
        scoreboard.clear();
        for (int i = 0; i < roomData['players'].length; i++) {
          setState(() {
            scoreboard.add({
              'username': roomData['players'][i]['nickname'],
              'points': roomData['players'][i]['points'].toString(),
            });
          });
        }
      });

      widget.socket.on(
        "show-leaderboard",
        (roomPlayers) {
          scoreboard.clear();
          for (int i = 0; i < roomPlayers.length; i++) {
            setState(() {
              scoreboard.add({
                'username': roomPlayers[i]['nickname'],
                'points': roomPlayers[i]['points'].toString(),
                'level': roomPlayers[i]['level'].toString(),
                'tier': roomPlayers[i]['tier'],
              });
            });
            if (maxPoints < int.parse(scoreboard[i]['points'])) {
              winner = scoreboard[i]['username'];
              maxPoints = int.parse(scoreboard[i]['points']);
            }
          }
          print(roomPlayers);
          setState(() {
            _timer.cancel();
            isShowFinalLeaderboard = true;
          });
        },
      );

      widget.socket.on('color-change', (colorString) {
        int value = int.parse(colorString, radix: 16);
        Color otherColor = new Color(value);
        setState(() {
          selectedColor = otherColor;
        });
      });

      widget.socket.on('stroke-width', (value) {
        setState(() {
          strokeWidth = value.toDouble();
        });
      });

      widget.socket.on('clean-screen', (value) {
        setState(() {
          points.clear();
        });
      });

      widget.socket.on('close-input', (_) {
        widget.socket.emit('update-score', widget.data['name']);
        setState(() {
          isTextReadonly = true;
        });
      });

      widget.socket.on('user-disconnected', (data) {
        scoreboard.clear();
        for (int i = 0; i < data['players'].length; i++) {
          setState(() {
            scoreboard.add({
              'username': data['players'][i]['nickname'],
              'points': data['players'][i]['points'].toString(),
            });
          });
        }
      });
    });
  }

  @override
  void dispose() {
    widget.socket.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void selectColor() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Choose Color'),
                content: SingleChildScrollView(
                  child: BlockPicker(
                    pickerColor: selectedColor,
                    onColorChanged: (color) {
                      String colorString = color.toString();
                      String valueString =
                          colorString.split('(0x')[1].split(')')[0];
                      print(colorString);
                      print(valueString);
                      Map map = {
                        'color': valueString,
                        'roomName': dataOfRoom['name']
                      };
                      widget.socket.emit('color-change', map);
                    },
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        // print("tes");
                        Navigator.pop(context);
                      },
                      child: const Text("close"))
                ],
              ));
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: PlayerDrawer(
          scoreboard, dataOfRoom, widget.socket, _timer, widget.data, points),
      body: dataOfRoom != null
          ? dataOfRoom['isJoin'] != true
              ? !isShowFinalLeaderboard
                  ? Stack(
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.55,
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  widget.socket.emit('paint', {
                                    'details': {
                                      'dx': details.localPosition.dx,
                                      'dy': details.localPosition.dy
                                    },
                                    'roomName': widget.data['name']
                                  });
                                },
                                onPanStart: (details) {
                                  widget.socket.emit('paint', {
                                    'details': {
                                      'dx': details.localPosition.dx,
                                      'dy': details.localPosition.dy
                                    },
                                    'roomName': widget.data['name']
                                  });
                                },
                                onPanEnd: (details) {
                                  widget.socket.emit('paint', {
                                    'details': null,
                                    'roomName': widget.data['name'],
                                  });
                                },
                                child: SizedBox.expand(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: Colors.black, // Warna border
                                        width: 2.0, // Lebar border dalam pixel
                                      ),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        child: RepaintBoundary(
                                          child: CustomPaint(
                                            size: Size.infinite,
                                            painter: MyCustomPainter(
                                                pointsList: points),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            dataOfRoom['turn']['nickname'] !=
                                    widget.data['nickname']
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: blankText,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              Text(
                                                '${dataOfRoom['turn']['nickname']} ',
                                                style: TextStyle(
                                                  fontFamily: 'Super Boys',
                                                  fontSize: 30.0,
                                                  fontWeight: FontWeight.bold,
                                                  foreground: Paint()
                                                    ..style =
                                                        PaintingStyle.stroke
                                                    ..strokeWidth = 6
                                                    ..color = Colors.black,
                                                ),
                                              ),
                                              Text(
                                                '${dataOfRoom['turn']['nickname']} ',
                                                style: TextStyle(
                                                  fontFamily: 'Super Boys',
                                                  fontSize: 30.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF75CFFF),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Stack(
                                            children: [
                                              Text(
                                                'is drawing',
                                                style: TextStyle(
                                                  fontFamily: 'Super Boys',
                                                  fontSize: 30.0,
                                                  fontWeight: FontWeight.bold,
                                                  foreground: Paint()
                                                    ..style =
                                                        PaintingStyle.stroke
                                                    ..strokeWidth = 6
                                                    ..color = Colors.black,
                                                ),
                                              ),
                                              Text(
                                                'is drawing',
                                                style: TextStyle(
                                                  fontFamily: 'Super Boys',
                                                  fontSize: 30.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFFFBF00),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Stack(
                                      children: [
                                        Text(
                                          '${dataOfRoom['word']}',
                                          style: TextStyle(
                                            fontFamily: 'Super Boys',
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 6
                                              ..color = Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '${dataOfRoom['word']}',
                                          style: TextStyle(
                                            fontFamily: 'Super Boys',
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFFBF00),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: selectColor,
                                  icon: Icon(
                                    Icons.color_lens,
                                    size: 24.0,
                                    color: selectedColor,
                                  ),
                                ),
                                Expanded(
                                  child: Slider(
                                    min: 1.0,
                                    max: 10,
                                    label: "Strokewidth $strokeWidth",
                                    activeColor: selectedColor,
                                    onChanged: (double value) {
                                      Map map = {
                                        "value": value,
                                        "roomName": dataOfRoom['name']
                                      };
                                      print(strokeWidth);
                                      widget.socket.emit('stroke-width', map);
                                    },
                                    value: strokeWidth,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    widget.socket.emit(
                                        'clean-screen', dataOfRoom['name']);
                                  },
                                  icon: Icon(
                                    Icons.layers_clear,
                                    size: 24.0,
                                    color: selectedColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: ListView.builder(
                                    controller: _chatScrollController,
                                    shrinkWrap: true,
                                    itemCount: messages.length,
                                    itemBuilder: (context, index) {
                                      var msg = messages[index].values;
                                      print(msg);
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                        ),
                                        child: Card(
                                          shape: const RoundedRectangleBorder(
                                            side: BorderSide(width: 2),
                                          ),
                                          child: ListTile(
                                              title: Text(
                                                msg.elementAt(0),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: msg
                                                      .elementAt(1)
                                                      .contains('Guessed it!')
                                                  ? Text(
                                                      msg.elementAt(1),
                                                      style: const TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 16),
                                                    )
                                                  : Text(
                                                      '${msg.elementAt(1)} ❌',
                                                      style: const TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 16),
                                                    )),
                                        ),
                                      );
                                    })),
                          ],
                        ),
                        dataOfRoom['turn']['nickname'] !=
                                widget.data?['nickname']
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: TextField(
                                    readOnly: points.isEmpty,
                                    onSubmitted: (value) {
                                      print(value.trim());
                                      if (value.trim().isNotEmpty) {
                                        Map map = {
                                          'username': widget.data['nickname'] ??
                                              'Guest',
                                          'msg': value.trim(),
                                          'word': dataOfRoom['word'],
                                          'roomName': widget.data['name'],
                                          'guessedTurn': guessedTurn,
                                          'totalTime': 60,
                                          'timeTaken': 60 - _start
                                        };
                                        widget.socket.emit('msg', map);
                                        _messageTextController.clear();
                                      }
                                    },
                                    autocorrect: false,
                                    controller: _messageTextController,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xffF5F5FA),
                                      hintText: "Your Answer",
                                      border: OutlineInputBorder(),
                                      suffixIcon: Icon(
                                        Icons.person,
                                        size: 24.0,
                                      ),
                                    ),
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                              )
                            : Container(),
                        SafeArea(
                            child: IconButton(
                                onPressed: () =>
                                    scaffoldKey.currentState!.openDrawer(),
                                icon: const Icon(Icons.menu)))
                      ],
                    )
                  : FinalLeaderboard(scoreboard, winner, dataOfRoom,
                      widget.data, isShowFinalLeaderboard, widget.screenFrom)
              : GameWaitingScreen(
                  occupancy: dataOfRoom['occupancy'],
                  numberOfPlayers: dataOfRoom['players'].length,
                  lobbyName: dataOfRoom['name'],
                  players: dataOfRoom['players'],
                )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(
          bottom: 30.0,
        ),
        child: isShowFinalLeaderboard
            ? FloatingActionButton(
                onPressed: () {
                  scoreboard.clear();
                  widget.socket.emit("delete-document", {
                    'collectionName': 'rooms',
                    'documentName': dataOfRoom['name']
                  });
                  print(dataOfRoom['name']);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
                elevation: 7,
                backgroundColor: Colors.white,
                child: Icon(Icons.close))
            : FloatingActionButton(
                onPressed: () {},
                elevation: 7,
                backgroundColor: Colors.white,
                child: Text(
                  "$_start",
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
      ),
    );
  }
}
