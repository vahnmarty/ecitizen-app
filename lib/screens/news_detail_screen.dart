import 'package:citizen/models/news_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../api/api.dart';
import '../constants/constancts.dart';
import '../themes.dart';
import '../widgets/cache_image.dart';

class NewsDetailScreen extends StatelessWidget {
  final News news;

  const NewsDetailScreen({Key? key, required this.news}) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${news.title}',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: cardHeadingStyle.copyWith(color: AppColors.textDark),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '${getFormattedDate(news.createdAt!)}',
                      style: TextStyle(
                          fontSize: 12, color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () {
                        shareToFacebook('http://ecitizenph.com/announcements/5-emergency-water-interruption');
                      },
                      child: Row(children: const [
                        Image(
                          image: AssetImage('assets/icons/facebook.png'),
                          height: 16,
                          color: Colors.white,
                        ),
                        Text('Share',style: TextStyle(color: Colors.white),),
                      ],)),
                  const SizedBox(width: 8,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () {
                        shareToTwitter('http://ecitizenph.com/announcements/5-emergency-water-interruption');
                      },
                      child: const Image(
                        image: AssetImage('assets/icons/twitter.png'),
                        height: 16,
                        color: Colors.white,
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CacheImage(
                width: double.infinity,
                fit: BoxFit.fill,
                url: '${Apis.APP_BASE_URL}/storage/${news.thumbnail}' ?? '',
              ),
              const SizedBox(
                height: 10,
              ),
              Html(
                data: '${news.contents}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
