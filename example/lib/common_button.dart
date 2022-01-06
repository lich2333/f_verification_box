import 'package:f_verification_box_example/default_page.dart';
import 'package:flutter/material.dart';

///
/// Author       : zhongaidong
/// Date         : 2022-01-06 14:14:26
/// Description  :
///

class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    this.title = '',
    this.routeName = DefaultPage.routeName,
  }) : super(key: key);

  final String title;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, routeName),
            child: Text(title),
          );
        }),
      ),
    );
  }
}
