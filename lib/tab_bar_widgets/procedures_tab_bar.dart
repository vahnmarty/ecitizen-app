import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../constants/constancts.dart';
import '../providers/services_provider.dart';
class ProceduresTabBar extends StatelessWidget {
  const ProceduresTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesProvider>(builder: (context, provider, child) {
      return Expanded(
          child: ListView.builder(
              itemCount: provider.businessServiceModel.procedures!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        provider
                            .businessServiceModel.procedures![index].title!,
                        style: cardHeadingStyle.copyWith(color: Colors.black),
                      ),
                      Html(data: "${provider.businessServiceModel.procedures![index].content}"),
                    ],
                  ),
                );
              }));
    });
  }
}
