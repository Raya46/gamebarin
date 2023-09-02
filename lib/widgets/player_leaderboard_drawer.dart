import 'package:flutter/material.dart';

class PlayerDrawer extends StatelessWidget {
  final List<Map> userData;
  PlayerDrawer(this.userData);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
          child: Container(
        height: double.maxFinite,
        child: ListView.builder(
          itemCount: userData.length,
          itemBuilder: (context, index) {
            var data = userData[index].values;
            return ListTile(
              title: Text(data.elementAt(0)),
              trailing: Text(data.elementAt(1)),
            );
          },
        ),
      )),
    );
  }
}
