import 'package:f_verification_box/f_verification_box.dart';
import 'package:flutter/material.dart';

///
/// Author       : zhongaidong
/// Date         : 2022-01-06 08:39:13
/// Description  :
///

class DefaultPage extends StatelessWidget {
  static const String routeName = '/default_page';
  DefaultPage({Key? key}) : super(key: key);
  final TextEditingController _codeEdit = TextEditingController(text: '8888');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('默认格式')),
      body: SizedBox(
        height: 65,
        child: VerificationBox(_codeEdit),
      ),
    );
  }
}
