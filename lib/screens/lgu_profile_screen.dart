import 'package:flutter/material.dart';

import '../constants/constancts.dart';
import '../themes.dart';
import '../widgets/bottom_navigation.dart';
class LGUProfileScreen extends StatelessWidget {
  const LGUProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Hero(
          tag: 'logo',
          child: Image(
            image: AssetImage('assets/logo/logo.png'),
            height: 20,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.iconLightGrey,
            )),
      ),
      body: Center(
        child: Text(
          'LGU \nProfiles',
          style: cardHeadingStyle.copyWith(color: Colors.black),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
