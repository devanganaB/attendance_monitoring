import 'package:attendance_monitoring/screen/textonly.dart';
import 'package:attendance_monitoring/screen/textwithimage.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[100],
            title: const Text(
              'Query-o-pedia',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 25),
            ),
            centerTitle: true,
            bottom: const TabBar(
                tabs: [Tab(text: "Text Only"), Tab(text: "Text & Image")]),
          ),
          body: const TabBarView(children: [TextOnly(), TextwithImage()]),
        ));
  }
}
