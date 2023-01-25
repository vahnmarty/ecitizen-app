import 'package:citizen/constants/constancts.dart';
import 'package:flutter/material.dart';

import '../screens/report_emergency_screen.dart';
import '../themes.dart';

class ReportCard extends StatelessWidget {
  final VoidCallback callback;
  const ReportCard({Key? key,required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 248,
      decoration: BoxDecoration(
        color: AppColors.cardRedLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: AppColors.cardRedLight,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          splashColor: AppColors.mainBg,
          onTap: callback,
          child: Padding(
            padding: const EdgeInsets.only(left: 22.0, bottom: 22),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: Image(
                          image: AssetImage('assets/icons/policeman.png'),
                          height: 100,
                        ),
                      ),
                      Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Report an',
                            style: cardHeadingStyle,
                          ),
                          Text(
                            'Emergency',
                            style: cardHeadingStyle,
                          )
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
