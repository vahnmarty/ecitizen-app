import 'package:citizen/constants/constancts.dart';
import 'package:flutter/material.dart';

import '../themes.dart';

class ProfileOfficesCard extends StatelessWidget {
  final VoidCallback callback;
  final bool isProfile;

  const ProfileOfficesCard({Key? key,required this.callback, required this.isProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isProfile ? AppColors.cardPurpleLight : AppColors.cardBlueDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: isProfile ? AppColors.cardPurpleLight : AppColors.cardBlueDark,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          splashColor: AppColors.cardLight,
          onTap: callback,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Image(
                    image: AssetImage(isProfile
                        ? 'assets/icons/user.png'
                        : 'assets/icons/home.png'),
                    height: 35,
                  ),
                ),
                Text(
                  isProfile ? 'LGU Profile' : 'LGU Offices',
                  style: cardHeadingStyle,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
