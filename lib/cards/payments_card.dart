import 'package:flutter/material.dart';

import '../constants/constancts.dart';
import '../themes.dart';
class PaymentsCard extends StatelessWidget {
  final VoidCallback callBack;
  const PaymentsCard({Key? key,required this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardGreenLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: AppColors.cardGreenLight,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          splashColor: AppColors.cardLight,
          onTap:callBack,
          child: Stack(
            children: const [
              Positioned(
                top: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(22),
                  child: Image(image: AssetImage('assets/icons/credit-card.png'),height: 30,),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.all(22),
                  child: Text(
                    'Online \nPayments',
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
