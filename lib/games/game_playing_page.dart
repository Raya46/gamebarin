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
  const GamePlayingPage(
      {Key? key, required this.data, required this.screenFrom})
      : super(key: key);

  @override
  State<GamePlayingPage> createState() => _GamePlayingPageState();
}

class _GamePlayingPageState extends State<GamePlayingPage> {
  late IO.Socket _socket;
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
    super.initState();
    connect();
    print(widget.data['nickname']);
  }

  void startTimer() {
    const second = const Duration(seconds: 1);
    _timer = Timer.periodic(second, (Timer timer) {
      if (_start == 0) {
        _socket.emit('change-turn', dataOfRoom['name']);
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
        style: TextStyle(fontSize: 20),
      ));
    }
  }

  void connect() {
    _socket = IO.io('http://192.168.56.1:3000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    _socket.connect();

    if (widget.screenFrom == "createRoom") {
      _socket.emit("create-game", widget.data);
    } else {
      _socket.emit("join-game", widget.data);
    }

    _socket.onConnect((data) {
      print("connected");
      _socket.on('updateRoom', (roomData) {
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

      _socket.on('msg', (msgData) {
        setState(() {
          messages.add(msgData);
          guessedTurn = msgData['guessedTurn'];
        });
        if (guessedTurn == dataOfRoom['players'].length - 1) {
          _socket.emit('change-turn', dataOfRoom['name']);
        }
        _chatScrollController.animateTo(
            _chatScrollController.position.maxScrollExtent + 40,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut);
      });

      _socket.on('change-turn', (data) {
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

      _socket.on(
          'notCorrectGame',
          (data) => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (route) => false));

      _socket.on('points', (point) {
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

      _socket.on('update-score', (roomData) {
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

      _socket.on(
        "show-leaderboard",
        (roomPlayers) {
          scoreboard.clear();
          for (int i = 0; i < roomPlayers.length; i++) {
            setState(() {
              scoreboard.add({
                'username': roomPlayers[i]['nickname'],
                'points': roomPlayers[i]['points'].toString()
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

      _socket.on('color-change', (colorString) {
        int value = int.parse(colorString, radix: 16);
        Color otherColor = new Color(value);
        setState(() {
          selectedColor = otherColor;
        });
      });

      _socket.on('stroke-width', (value) {
        setState(() {
          strokeWidth = value.toDouble();
        });
      });

      _socket.on('clean-screen', (value) {
        setState(() {
          points.clear();
        });
      });

      _socket.on('close-input', (_) {
        _socket.emit('update-score', widget.data['name']);
        setState(() {
          isTextReadonly = true;
        });
      });

      _socket.on('user-disconnected', (data) {
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
    _socket.dispose();
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
                      _socket.emit('color-change', map);
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
      drawer: PlayerDrawer(scoreboard),
      body: dataOfRoom != null
          ? dataOfRoom['isJoin'] != true
              ? !isShowFinalLeaderboard
                  ? Stack(
                      children: [
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.55,
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  _socket.emit('paint', {
                                    'details': {
                                      'dx': details.localPosition.dx,
                                      'dy': details.localPosition.dy
                                    },
                                    'roomName': widget.data['name']
                                  });
                                },
                                onPanStart: (details) {
                                  _socket.emit('paint', {
                                    'details': {
                                      'dx': details.localPosition.dx,
                                      'dy': details.localPosition.dy
                                    },
                                    'roomName': widget.data['name']
                                  });
                                },
                                onPanEnd: (details) {
                                  _socket.emit('paint', {
                                    'details': null,
                                    'roomName': widget.data['name'],
                                  });
                                },
                                child: SizedBox.expand(
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
                            dataOfRoom['turn']['nickname'] !=
                                    widget.data['nickname']
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: blankText,
                                  )
                                : Center(
                                    child: Text(
                                      dataOfRoom['word'],
                                      style: const TextStyle(fontSize: 30),
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
                                      _socket.emit('stroke-width', map);
                                    },
                                    value: strokeWidth,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _socket.emit(
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
                                      return Card(
                                        shape: const RoundedRectangleBorder(
                                          side: BorderSide(width: 2),
                                        ),
                                        child: ListTile(
                                            title: Text(
                                              msg.elementAt(0),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: msg
                                                    .elementAt(1)
                                                    .contains('guessed')
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
                                      );
                                    })),
                          ],
                        ),
                        dataOfRoom['turn']['nickname'] !=
                                widget.data['nickname']
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: TextField(
                                    readOnly: isTextReadonly,
                                    onSubmitted: (value) {
                                      print(value.trim());
                                      if (value.trim().isNotEmpty) {
                                        Map map = {
                                          'username': widget.data['nickname'],
                                          'msg': value.trim(),
                                          'word': dataOfRoom['word'],
                                          'roomName': widget.data['name'],
                                          'guessedTurn': guessedTurn,
                                          'totalTime': 60,
                                          'timeTaken': 60 - _start
                                        };
                                        _socket.emit('msg', map);
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
                  _socket.emit("delete-document", {
                    'collectionName': 'rooms',
                    'documentId': dataOfRoom['_id']
                  });
                  print(dataOfRoom['_id']);
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
