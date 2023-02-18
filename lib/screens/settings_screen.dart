import 'package:citizen/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<AuthProvider>().getNotificationSettings();
      });
    }
  }

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
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 12),
          //   child: IconButton(
          //     icon: const Icon(
          //       Icons.save,
          //       color: AppColors.iconLightGrey,
          //     ),
          //     onPressed: () async{
          //
          //       //showToast('Notification Settings Saved.');
          //     },
          //   ),
          // )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Consumer<AuthProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.mainColor,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "SMS Notifications",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            'Receive text alerts of new announcements.',
                            style: TextStyle(fontSize: 16),
                          )),
                          Switch.adaptive(
                              activeColor: AppColors.cardGreenLight,
                              value: provider.smsAnnouncement,
                              onChanged: (val) async {
                                provider.smsAnnouncement = val;
                                dynamic data = {
                                  "key": "sms_notification_announcement",
                                  "value": val?'1':'0'
                                };
                                setState(() {});
                                await context
                                    .read<AuthProvider>()
                                    .saveNotificationSettings(data);

                              }),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            "Receive text alert of report's status update.",
                            style: TextStyle(fontSize: 16),
                          )),
                          Switch.adaptive(
                              activeColor: AppColors.cardGreenLight,
                              value: provider.smsReport,
                              onChanged: (val) async{
                                provider.smsReport = val;
                                dynamic data = {
                                  "key": "sms_notification_report",
                                  "value": val?'1':'0'
                                };
                                setState(() {});
                                await context
                                    .read<AuthProvider>()
                                    .saveNotificationSettings(data);

                              }),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Push Notifications",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            "Receive Notification for Report's Status Update",
                            style: TextStyle(fontSize: 16),
                          )),
                          Switch.adaptive(
                              activeColor: AppColors.cardGreenLight,
                              value: provider.notificationReport,
                              onChanged: (val) async{
                                provider.notificationReport = val;
                                dynamic data = {
                                  "key": "notification_report",
                                  "value": val?'1':'0'
                                };
                                setState(() {});
                                await context
                                    .read<AuthProvider>()
                                    .saveNotificationSettings(data);

                              }),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            "Receive Notification for new announcement.",
                            style: TextStyle(fontSize: 16),
                          )),
                          Switch.adaptive(
                              activeColor: AppColors.cardGreenLight,
                              value: provider.notificationAnnouncement,
                              onChanged: (val) async{
                                provider.notificationAnnouncement = val;
                                dynamic data = {
                                  "key": "notification_announcement",
                                  "value": val?'1':'0'
                                };
                                setState(() {});
                                await context
                                    .read<AuthProvider>()
                                    .saveNotificationSettings(data);

                              }),
                        ],
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
