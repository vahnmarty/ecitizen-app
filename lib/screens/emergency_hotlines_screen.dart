import 'package:citizen/models/hotlines_model.dart';
import 'package:citizen/providers/hotlines_provider.dart';
import 'package:citizen/screens/LGU_offices_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constancts.dart';
import '../themes.dart';
import '../widgets/bottom_navigation.dart';

class EmergencyHotlinesScreen extends StatefulWidget {
  const EmergencyHotlinesScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyHotlinesScreen> createState() =>
      _EmergencyHotlinesScreenState();
}

class _EmergencyHotlinesScreenState extends State<EmergencyHotlinesScreen> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<HotlinesProvider>().getHotlines();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBg,
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
      body: Consumer<HotlinesProvider>(
        builder: (context, provider, child) {
          return provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mainColor,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200, mainAxisExtent: 140),
                    children: [
                      ...List.generate(
                          provider.myHotlines.length,
                          (index) => _HotlinesListItem(
                              hotline: provider.myHotlines[index])),
                    ],
                  ),
                );
        },
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}

class _HotlinesListItem extends StatelessWidget {
  final HotlinesModel hotline;

  const _HotlinesListItem({Key? key, required this.hotline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(2, 4), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              hotline.name!,
              style:
                  cardHeadingStyle.copyWith(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
              child: ListView.builder(itemCount: hotline.numbers!.length,itemBuilder: (context,index){
                return  IconsAndText(
                    text: hotline.numbers![index].number!,
                    icon: Icons.phone,
                    iconColor: Colors.grey,
                    textColor: Colors.black);
              }),
            ),

          ],
        ),
      ),
    );
  }
}
