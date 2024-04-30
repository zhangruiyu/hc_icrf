import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hc_icrf/hc_icrf.dart';
import 'package:hc_icrf/hc_icrf_method_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _hcIcrfPlugin = HcIcrf();
  List<String> message = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    MethodChannelHcIcrf.onDartMessageListener.listen((event) {
      debugPrint('event: $event');
      insertMessage(event.toString());
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await _hcIcrfPlugin.connectReader();
  }

  void insertMessage(String newMessage) {
    message.insert(0, newMessage);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [...message.map((e) => Text(e))],
          ),
        ),
      ),
    );
  }
}
