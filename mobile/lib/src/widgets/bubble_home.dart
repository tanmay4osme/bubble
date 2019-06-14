import 'package:flutter/material.dart';

class BubbleHome extends StatefulWidget {
  @override
  State createState() => _BubbleHomeState();
}

class _BubbleHomeState extends State<BubbleHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Image.asset('assets/logo_white.png', height: 24,),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            title: Text('Feed'),
            icon: Icon(Icons.star),
          ),
          BottomNavigationBarItem(
            title: Text('Search'),
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            title: Text('Notifications'),
            icon: Icon(Icons.alarm),
          ),
          BottomNavigationBarItem(
            title: Text('Me'),
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
