import 'package:citizen/api/api.dart';
import 'package:citizen/cards/hotlines_card.dart';
import 'package:citizen/cards/payments_card.dart';
import 'package:citizen/cards/profile_offices_card.dart';
import 'package:citizen/cards/report_card.dart';
import 'package:citizen/constants/constancts.dart';
import 'package:citizen/helpers/session_helper.dart';
import 'package:citizen/models/service_model.dart';
import 'package:citizen/providers/auth_provider.dart';
import 'package:citizen/providers/location_provider.dart';
import 'package:citizen/screens/LGU_offices_screen.dart';
import 'package:citizen/screens/about_screen.dart';
import 'package:citizen/screens/emergency_hotlines_screen.dart';
import 'package:citizen/screens/login_screen.dart';
import 'package:citizen/screens/my_reports_screen.dart';
import 'package:citizen/screens/news_and_announcements_widget.dart';
import 'package:citizen/screens/report_emergency_screen.dart';
import 'package:citizen/screens/search_service_screen.dart';
import 'package:citizen/screens/service_screen.dart';
import 'package:citizen/screens/settings_screen.dart';
import 'package:citizen/screens/signup_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../config/config.dart';
import '../providers/news_provider.dart';
import '../providers/services_provider.dart';
import '../themes.dart';
import 'news_announcements_screen.dart';

final List<ServiceModel> _dropDownItems = [
  ServiceModel(name: "I want to apply for....")
];

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  //var _dropDownSelectedValue = _dropDownItems.first;
  _dropDownCallBack(String? id) {
    //debugPrint('selectedval:$val');
    if (id == '0') {
      return;
    }
    nextScreen(context, ServiceScreen(id: id!));
  }

  double gap = 6.0;

  void _onRefresh() async {
    await context.read<NewsProvider>().gettingNews(Apis.news);
    await context.read<ServicesProvider>().getServices();
    await context.read<AuthProvider>().checkUserSession();
    _refreshController.refreshCompleted();
  }

  void _onLoading(context) async {
    NewsProvider newsProvider = Provider.of<NewsProvider>(context);
    if (!newsProvider.isGettingNews) _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        context.read<ServicesProvider>().getServices();
        context.read<NewsProvider>().gettingNews(Apis.news);
        context.read<LocationProvider>().getCurrentLocation();
        context.read<AuthProvider>().checkUserSession();
        _firebaseMessaging.getToken().then((String? token) async {
          debugPrint('fcm token: $token');
          assert(token != null);
          _firebaseMessaging.subscribeToTopic("all");
          Function func = (tkn) async {
            var request = {
              'fcm_token': tkn,
            };
          };
          context.read<AuthProvider>().updateFcmToken(token!);
        });
      });
      ////////
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('A new onMessageOpenedApp event was =+> $message');
        nextScreen(context, const NewsAnnouncementsScreen());
      });
      ///////
    }
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    context.read<LocationProvider>().getCurrentLocation();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.mainBg,
      drawer: const _DrawerLayout(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: InkWell(
          onTap: () {
            count++;
            if (count == 3) {
              showToast('You are just two steps away from developers page!');
            }
            if (count == 5 || count > 5) {
              openWebView(context, 'developers');
            }
          },
          child: const Hero(
            tag: 'logo',
            child: Image(
              image: AssetImage('assets/logo/logo.png'),
              height: 20,
            ),
          ),
        ),
        actions: [
          /*Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(
                Icons.search,
                color: AppColors.iconLightGrey,
              ),
              onPressed: () {},
            ),
          )*/
        ],
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
              //Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: AppColors.iconLightGrey,
            )),
      ),
      bottomNavigationBar: const _BottomNavigation(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: SmartRefresher(
        onRefresh: _onRefresh,
        onLoading: () {
          _onLoading(context);
        },
        controller: _refreshController,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return authProvider.isLogin
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Hi, ${authProvider.user.name}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${getTodayDate()}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      "${getCurrentTime()}",
                                      style: const TextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Hi, ecitizen!',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        TextButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.mainColor,
                                                primary: Colors.white),
                                            onPressed: () {
                                              nextScreen(
                                                  context, const LoginScreen());
                                            },
                                            child: const Text('Login')),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        TextButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.mainColor,
                                                primary: Colors.white),
                                            onPressed: () {
                                              nextScreen(context,
                                                  const SignupScreen());
                                            },
                                            child: const Text('Signup')),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            );
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    nextScreen(context, const SearchSearchScreen());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'I want to apply for....',
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                // Consumer<ServicesProvider>(
                //   builder: (context, servicesProvider, child) {
                //     return servicesProvider.isLoading
                //         ? HomeScreenDropDown(
                //             callback: (String val) {
                //               debugPrint('selected $val');
                //             },
                //             list: _dropDownItems)
                //         : servicesProvider.services.isNotEmpty
                //             ? HomeScreenDropDown(
                //                 list: servicesProvider.services,
                //                 callback: _dropDownCallBack,
                //               )
                //             : const SizedBox();
                //   },
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: ReportCard(
                          callback: () async {
                            bool connected = await internetConnectivity();
                            debugPrint('conn: $connected');
                            if (!connected) {
                              nextScreen(context, ReportEmergencyScreen());
                              return;
                            }
                            final token = await getToken();
                            if (token == false ||
                                token == '' ||
                                token == null) {
                              showAlertDialog(context, 'Login First',
                                  'Please login to Continue',
                                  showCancelButton: true,
                                  dismissible: false,
                                  okButtonText: 'Login', onPress: () {
                                nextScreen(context, const LoginScreen());
                              });
                            } else {
                              nextScreen(context, ReportEmergencyScreen());
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: gap,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            HotlinesCard(
                              callback: () {
                                nextScreen(
                                    context, const EmergencyHotlinesScreen());
                              },
                            ),
                            PaymentsCard(
                              callBack: () {
                                showAlertDialog(context, 'Option not Available',
                                    'Sorry, this feature is not available at the moment!',type: AlertType.WARNING);

                                //nextScreen(context, const OnlinePaymentsScreen());
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ProfileOfficesCard(
                        callback: () {
                          nextScreen(context, const AboutScreen());
                          //nextScreen(context, const LGUProfileScreen());
                        },
                        isProfile: true,
                      ),
                    ),
                    SizedBox(
                      width: gap,
                    ),
                    Expanded(
                      child: ProfileOfficesCard(
                        callback: () {
                          nextScreen(context, const LGUOfficesScreen());
                        },
                        isProfile: false,
                      ),
                    ),
                  ],
                ),
                const NewsAndAnnouncementsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              color: Colors.black.withOpacity(0.03),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BottomNavigationBarItem(
                    title: 'CALL 911',
                    callback: () {
                      makePhoneCall('911');
                    },
                  ),
                  _BottomNavigationBarItem(
                    title: 'COVID',
                    callback: () {
                      makePhoneCall(Config.COVID_HOTLINE);
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 60,
              child: RawMaterialButton(
                onPressed: () {},
                shape: const CircleBorder(),
                elevation: 8,
                fillColor: Colors.white,
                child: const Icon(
                  CupertinoIcons.home,
                  color: Colors.blue,
                ),
                /*child: const Icon(
                  Icons.home_outlined,
                  size: 32,
                  color: Colors.blue,
                ),*/
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavigationBarItem extends StatelessWidget {
  final String title;
  final VoidCallback callback;

  const _BottomNavigationBarItem(
      {Key? key, required this.title, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: 90,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: callback,
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                Icons.call,
                color: AppColors.iconDarkRed,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

class _DrawerLayout extends StatelessWidget {
  const _DrawerLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: AppColors.mainBg,
                ),
                child: authProvider.isLogin
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${authProvider.user.name}",
                            style:
                                cardHeadingStyle.copyWith(color: Colors.black),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('${authProvider.user.email}'),
                          authProvider.user.phone != null ||
                                  authProvider.user.phone == ''
                              ? Text('${authProvider.user.phone}')
                              : const SizedBox(),
                        ],
                      )
                    : Text(
                        'No User!',
                        style: cardHeadingStyle.copyWith(color: Colors.black),
                      ),
              ),
              ListTile(
                title: const Text('H O M E'),
                onTap: () {
                  //replaceScreen(context, HomeScreen());
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('A B O U T'),
                onTap: () {
                  Navigator.of(context).pop();
                  //nextScreen(context, const AboutScreen());
                  openWebView(context, 'about');
                },
              ),
              ListTile(
                title: const Text('M Y  -R E P O R T S'),
                onTap: () async {
                  final token = await getToken();
                  if (token == false || token == null || token == '') {
                    Navigator.of(context).pop();
                    showAlertDialog(
                        context, 'Login First', 'Please login to Continue',
                        showCancelButton: true);
                  } else {
                    Navigator.of(context).pop();
                    nextScreen(context, const MyReportsScreen());
                  }
                },
              ),
              ListTile(
                title: const Text('C O N T A C T  -U S'),
                onTap: () async {
                  Navigator.of(context).pop();
                  openWebView(context, 'contact');
                  //nextScreen(context, const AboutScreen());
                },
              ),
              // ListTile(
              //   title: const Text('D E V E L O P E R S '),
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     openWebView(context,'developers');
              //   },
              // ),
              ListTile(
                title: const Text('F A Q '),
                onTap: () {
                  Navigator.of(context).pop();
                  openWebView(context, 'faq');
                  //nextScreen(context, const AboutScreen());
                },
              ),
              ListTile(
                title: const Text('T E R M S '),
                onTap: () {
                  Navigator.of(context).pop();
                  openWebView(context, 'terms');
                  //nextScreen(context, const AboutScreen());
                },
              ),
              ListTile(
                title: const Text('P R I V A C Y'),
                onTap: () {
                  Navigator.of(context).pop();
                  openWebView(context, 'privacy');
                  //nextScreen(context, const AboutScreen());
                },
              ),
              Container(
                color: Colors.grey,
                height: .5,
              ),
              ListTile(
                title: const Text('S E T T I N G S'),
                onTap: () {
                  Navigator.of(context).pop();
                  nextScreen(context, const SettingsScreen());
                },
              ),
              Container(
                color: Colors.grey,
                height: .5,
              ),
              Consumer<AuthProvider>(
                builder: (context, provider, child) {
                  return ListTile(
                    leading: provider.isLogin
                        ? const Icon(Icons.login)
                        : const Icon(Icons.logout),
                    title:
                        Text(provider.isLogin ? 'L O G O U T ' : 'L O G I N'),
                    onTap: () {
                      if (provider.isLogin) {
                        showAlertDialog(
                            context, 'Logout', 'Are you want to logout!',
                            showCancelButton: true,
                            okButtonText: 'Logout', onPress: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          logout();
                          provider.isLogin = false;
                        });
                      } else {
                        Navigator.of(context).pop();
                        nextScreen(context, const LoginScreen());
                      }
                    },
                  );
                },
              ),
              ListTile(
                title: const Text('C L O S E A P P'),
                leading: Icon(Icons.close_sharp),
                onTap: () {
                  Navigator.of(context).pop();
                  showAlertDialog(
                      context, 'Exit', 'Are your sure you want to exit app?',
                      type: AlertType.WARNING,
                      okButtonText: 'Close App', onPress: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  }, showCancelButton: true);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
