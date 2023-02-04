import 'package:citizen/api/api.dart';
import 'package:citizen/models/news_model.dart';
import 'package:citizen/providers/news_provider.dart';
import 'package:citizen/screens/news_announcements_screen.dart';
import 'package:citizen/themes.dart';
import 'package:citizen/widgets/cache_image.dart';
import 'package:citizen/widgets/shimmer_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constancts.dart';
import '../widgets/news_item_list.dart';

class NewsAndAnnouncementsWidget extends StatelessWidget {
  const NewsAndAnnouncementsWidget({Key? key}) : super(key: key);

  _handleCachedData(provider) async {
    bool connection = await internetConnectivity();
    if (!connection) {
      final news = await getNewsFromJson();
      if (news != null) {
        provider.newsList = news;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        _handleCachedData(newsProvider);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'News and Announcements',
                    style: cardHeadingStyle.copyWith(
                        color: Colors.black, fontSize: 18),
                  ),
                  TextButton(
                      onPressed: () {
                        nextScreen(context, const NewsAnnouncementsScreen());
                      },
                      child: const Text(
                        'View more',
                        style: TextStyle(color: Colors.blue),
                      )),
                ],
              ),
            ),
            newsProvider.isGettingNews
                ? const NewsShimmerEffect()
                : Column(
                    children: [
                      ...List.generate(
                          newsProvider.newsList.length < 3
                              ? newsProvider.newsList.length
                              : 3,
                          (index) =>
                              NewListItem(news: newsProvider.newsList[index])),
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
        );
      },
    );
  }
}

class NewsShimmerEffect extends StatelessWidget {
  const NewsShimmerEffect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(itemBuilder: (context, index) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child:
                  ShimmerSkeleton(height: 100, width: getWidth(context) * 0.4),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerSkeleton(height: 70, width: double.infinity),
                  const SizedBox(
                    height: 6,
                  ),
                  ShimmerSkeleton(height: 16, width: getWidth(context) * 0.4),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
