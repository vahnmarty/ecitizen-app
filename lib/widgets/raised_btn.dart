import 'package:flutter/material.dart';

import '../themes.dart';

class RaisedBtn extends StatelessWidget {
  final String title;
  final VoidCallback callback;

  const RaisedBtn({Key? key, required this.title, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: AppColors.btnBlue, primary: Colors.white),
          onPressed: callback,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(title),
          )),
    );
  }
}
