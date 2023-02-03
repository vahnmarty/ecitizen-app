import 'package:citizen/widgets/title_card_with_shadow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../constants/constancts.dart';
import '../providers/news_provider.dart';
import '../themes.dart';
import '../widgets/news_item_list.dart';
import 'news_and_announcements_widget.dart';

class NewsAnnouncementsScreen extends StatefulWidget {
  const NewsAnnouncementsScreen({Key? key}) : super(key: key);

  @override
  State<NewsAnnouncementsScreen> createState() =>
      _NewsAnnouncementsScreenState();
}

class _NewsAnnouncementsScreenState extends State<NewsAnnouncementsScreen> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<NewsProvider>().gettingNews('${Apis.news}/?max=20');
        });
    }
  }

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
      body: Column(
        children: [
          const TitleCardWithShadow(title: 'News And Announcement'),
          Consumer<NewsProvider>(
            builder: (context, newsProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    newsProvider.isGettingNews
                        ? const NewsShimmerEffect()
                        : Column(
                            children: [
                              ...List.generate(
                                  newsProvider.newsList.length,
                                  (index) => NewListItem(
                                      news: newsProvider.newsList[index])),
                              /*Container(
                        height: newsProvider.newsList.length * 117,
                        child: ListView.builder(
                            itemCount: newsProvider.newsList.length,
                            itemBuilder: (context, index) {
                              return _NewListItem(
                                news: newsProvider.newsList[index],
                              );
                            }),
                      ),*/
                            ],
                          )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
