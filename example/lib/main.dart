import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hc_icrf/hc_icrf.dart';
import 'package:hc_icrf/hc_icrf_method_channel.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
        (options) {
      options.dsn = 'https://044ddff78dadd04245bfb28e7bdb7875@o1373303.ingest.us.sentry.io/4507174877855744';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );
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
    MethodChannelHcIcrf.onDartMessageListener.listen((event) {
      debugPrint('event: $event');
      insertMessage(event.toString());
    });
  }

  Future<void> connectReader() async {
    await _hcIcrfPlugin.connectReader();
  }

  ///请求卡
  Future<void> requestCard() async {
    try {
      //0或者1
      await _hcIcrfPlugin.requestCard(0);
    } catch (e, s) {
      debugPrint('error: $e, stack: $s');
    }
  }

  ///防冲突
  Future<void> anticollCard() async {
    try {
      ///返回卡片序列号
      String result = await _hcIcrfPlugin.anticollCard();
    } catch (e, s) {
      debugPrint('error: $e, stack: $s');
    }
  }

  ///选卡
  Future<void> selectCard() async {
    try {
      ///选卡成功, 返回卡片容量
      int result = await _hcIcrfPlugin.selectCard();
    } catch (e, s) {
      debugPrint('error: $e, stack: $s');
    }
  }

  ///校验密码
  Future<void> verifyPwd() async {
    try {
      ///选卡成功, 返回secNo
      int result =
          await _hcIcrfPlugin.verifyPwd(pwd: 'pwd', sector: 1, keyMode: 0);
    } catch (e, s) {
      debugPrint('error: $e, stack: $s');
    }
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
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  connectReader();
                },
                child: Text('连接设备')),
            ElevatedButton(
                onPressed: () {
                  requestCard();
                },
                child: Text('请求')),
            ElevatedButton(
                onPressed: () {
                  anticollCard();
                },
                child: Text('防冲突')),
            ElevatedButton(
                onPressed: () {
                  selectCard();
                },
                child: Text('选择卡片')),
            ElevatedButton(
                onPressed: () {
                  verifyPwd();
                },
                child: Text('校验密码')),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [...message.map((e) => Text(e))],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
