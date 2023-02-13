import 'package:citizen/constants/constancts.dart';
import 'package:citizen/providers/services_provider.dart';

import 'package:citizen/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api.dart';

class ApplicationFormTabBar extends StatelessWidget {
  const ApplicationFormTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
      child: Consumer<ServicesProvider>(
        builder: (context, provider, child) {
          return provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mainColor,
                  ),
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Application Form',
                          style: cardHeadingStyle.copyWith(color: Colors.black),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.mainColor),
                            onPressed: () async {

                              final Uri _url = Uri.parse(provider.businessServiceModel.applicationFormUrl!);

                              await launchUrl(_url,
                                  mode: LaunchMode.externalApplication);
                            },
                            child: Text(
                              'Download',
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                    Expanded(
                        child: Stack(
                      children: [
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.mainColor,
                          ),
                        ),
                        Image.network(
                            '${provider.businessServiceModel.filePreviewUrl}')
                      ],
                    ))
                  ],
                );
        },
      ),
    );
  }
}
