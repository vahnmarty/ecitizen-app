import 'package:citizen/api/api.dart';
import 'package:citizen/providers/news_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constancts.dart';
import '../constants/custom_route_transition.dart';
import '../screens/home_screen.dart';
import '../themes.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              color: Colors.black.withOpacity(0.03),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _BottomNavigationBarItem(
                    title: 'CALL 911',
                  ),
                  _BottomNavigationBarItem(
                    title: 'COVID',
                    covid: true,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 60,
              child: RawMaterialButton(
                onPressed: () {
                  context.read<NewsProvider>().gettingNews(Apis.news);
                  Navigator.pushReplacement(
                      context, CustomRoute(builder: (context) => HomeScreen()));
                },
                shape: const CircleBorder(),
                elevation: 8,
                fillColor: Colors.white,
                child: const Icon(
                  CupertinoIcons.home,
                  color: Colors.blue,
                ),
                /*child: const Icon(
                  Icons.home_outlined,
                  size: 32,
                  color: Colors.blue,
                ),*/
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavigationBarItem extends StatelessWidget {
  final String title;
  final bool covid;

  const _BottomNavigationBarItem(
      {Key? key, required this.title, this.covid = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: 90,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          makePhoneCall(covid ? '8888' : '911');
        },
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                Icons.call,
                color: AppColors.iconDarkRed,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
