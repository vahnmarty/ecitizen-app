import 'package:citizen/api/api.dart';
import 'package:citizen/models/news_model.dart';
import 'package:citizen/providers/news_provider.dart';
import 'package:citizen/themes.dart';
import 'package:citizen/widgets/cache_image.dart';
import 'package:citizen/widgets/shimmer_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constancts.dart';

class NewsAndAnnouncements extends StatelessWidget {
  const NewsAndAnnouncements({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'News and Announcements',
                style: cardHeadingStyle.copyWith(
                    color: Colors.black, fontSize: 18),
              ),
            ),
            newsProvider.isGettingNews
                ? const _NewsShimmerEffect()
                : Column(
                  children: [
                    ...List.generate(newsProvider.newsList.length, (index) => _NewListItem(news: newsProvider.newsList[index])),
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

class _NewListItem extends StatelessWidget {
  final News news;

  const _NewListItem({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          CacheImage(
            width: getWidth(context) * 0.4,
            fit: BoxFit.cover,
            url: '${Apis.APP_BASE_URL}/storage/${news.thumbnail}' ?? '',
          ),
          // Image(
          //   image:
          //       NetworkImage('${Apis.APP_BASE_URL}/storage/${news.thumbnail}'),
          //   //height: 100,
          //   width: getWidth(context) * 0.4,
          // ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '${news.title}',
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: cardHeadingStyle.copyWith(color: AppColors.textDark),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '${getFormattedDate(news.createdAt!)}',
                    style: TextStyle(
                        fontSize: 12, color: Colors.black.withOpacity(0.6)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsShimmerEffect extends StatelessWidget {
  const _NewsShimmerEffect({Key? key}) : super(key: key);

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
