import 'dart:developer';

import 'package:citizen/providers/services_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../tab_bar_widgets/application_form_tab_bar.dart';
import '../tab_bar_widgets/procedures_tab_bar.dart';
import '../tab_bar_widgets/requirements_tab_bar.dart';
import '../themes.dart';

class ServiceScreen extends StatefulWidget {
  final String id;

  const ServiceScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<ServicesProvider>().gettingBusinessServiceModel(widget.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
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
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Requirements',
                ),
                Tab(
                  text: 'Procedures',
                ),
                Tab(
                  text: 'Application Form',
                ),
              ],
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
          body: const TabBarView(children: [
            RequirementsTabBar(),
            ProceduresTabBar(),
            ApplicationFormTabBar()
          ])),
    );
  }
}
