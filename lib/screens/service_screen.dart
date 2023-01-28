import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../themes.dart';
class ServiceScreen extends StatelessWidget {
  final String id;
  const ServiceScreen({Key? key,required this.id}) : super(key: key);

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
      body:Html(data: "<h1>Hello Flutter</h1>") ,
    );
  }
}
