import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';
import '../api/api.dart';
import '../themes.dart';
import '../widgets/bottom_navigation.dart';
class WebViewScreen extends StatelessWidget {
  final String pageName;
  const WebViewScreen({Key? key,required this.pageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var url = '${Apis.APP_BASE_URL}$pageName?view=mobile';
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
      body: WebView(initialUrl: url,),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
