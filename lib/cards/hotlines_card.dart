import 'package:citizen/constants/constancts.dart';
import 'package:flutter/material.dart';

import '../themes.dart';

class HotlinesCard extends StatelessWidget {
  final VoidCallback callback;
  const HotlinesCard({Key? key,required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 6),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardYellowLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: AppColors.cardYellowLight,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          splashColor: AppColors.cardLight,
          onTap: callback,
          child: Stack(
            children: const [
              Positioned(
                top: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(22),
                  child: Image(image: AssetImage('assets/icons/call.png'),height: 30,),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.all(22),
                  child: Text(
                    'Emergency \nHotlines',
                    style: cardHeadingStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
