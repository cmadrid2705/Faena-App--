import 'package:faena/src/settings/UI/screens/setting-home.dart';
import 'package:flutter/material.dart';

import 'home/UI/screens/home.dart';

class Faena extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Faena();
  }
}

class _Faena extends State<Faena> with SingleTickerProviderStateMixin {
  int indexTap = 0;
  final List<Widget> widgetsChildren = [
    Home(),
    SettingHome(),
  ];

  void onTapTapped(int index) {
    setState(() {
      indexTap = index;
    });
  }

  @override
  void initState() {
    super.initState();
    indexTap = 0;
  }

  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: kBottomNavigationBarHeight,
      child: Scaffold(
        body: IndexedStack(
          index: indexTap,
          children: widgetsChildren,
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
            primaryColor: Colors.blue,
          ),
          child: BottomNavigationBar(
              onTap: onTapTapped,
              currentIndex: indexTap,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.blue,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Center(
                      child: Text("Inicio"),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    title: Center(
                      child: Text("Ajustes"),
                    )),
              ]),
        ),
      ),
    );
  }
}
