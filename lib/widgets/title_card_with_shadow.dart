import 'package:flutter/material.dart';

import '../constants/constancts.dart';
class TitleCardWithShadow extends StatelessWidget {
  final String title;
  const TitleCardWithShadow({Key? key,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset:
              const Offset(0, 2), // changes position of shadow
            ),
          ],
          border: Border(
              top: BorderSide(
                width: 1,
                color: Colors.grey.withOpacity(0.2),
              ))),
      child: Text(
        title,
        style: cardHeadingStyle.copyWith(color: Colors.black),
      ),
    );
  }
}
