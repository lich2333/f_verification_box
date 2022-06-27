import 'package:f_verification_box_example/default_page.dart';
import 'package:flutter/material.dart';

import 'common_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        DefaultPage.routeName: (_) => DefaultPage(),
      },
      home: Scaffold(
        appBar: AppBar(title: const Text('验证码')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: const [
            CommonButton(
              title: '默认格式',
              routeName: DefaultPage.routeName,
            ),
          ]),
        ),
      ),
    );
  }
}
