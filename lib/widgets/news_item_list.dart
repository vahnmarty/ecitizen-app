import 'package:citizen/screens/news_detail_screen.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../constants/constancts.dart';
import '../models/news_model.dart';
import '../screens/news_announcements_screen.dart';
import '../themes.dart';
import 'cache_image.dart';

class NewListItem extends StatelessWidget {
  final News news;

  const NewListItem({Key? key, required this.news}) : super(key: key);

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
                    maxLines: 3,
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
                TextButton(
                    onPressed: () {
                      nextScreen(context,  NewsDetailScreen(news: news));
                    },
                    child: const Text(
                      'See more',
                      style: TextStyle(color: Colors.blue),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
