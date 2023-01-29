import 'dart:developer';

import 'package:citizen/constants/constancts.dart';
import 'package:citizen/providers/services_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class RequirementsTabBar extends StatelessWidget {
  const RequirementsTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesProvider>(builder: (context, provider, child) {
      return Expanded(
          child: ListView.builder(
              itemCount: provider.businessServiceModel.requirements!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        provider
                            .businessServiceModel.requirements![index].title!,
                        style: cardHeadingStyle.copyWith(color: Colors.black),
                      ),
                      Html(data: "${provider.businessServiceModel.requirements![index].content}"),
                    ],
                  ),
                );
              }));
    });
  }
}
