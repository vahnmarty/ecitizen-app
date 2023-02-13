import 'package:flutter/material.dart';

import '../themes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _smsAnnouncement = false;
  bool _smsUpdate = true;
  bool _pushAnnouncement = true;
  bool _pushUpdate = true;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "SMS Notifications",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
                    value: _smsAnnouncement,
                    onChanged: (val) {
                      _smsAnnouncement = val;
                      setState(() {});
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
                    value: _smsUpdate,
                    onChanged: (val) {
                      _smsUpdate = val;
                      setState(() {});
                    }),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Push Notifications",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
                    value: _pushUpdate,
                    onChanged: (val) {
                      _pushUpdate = val;
                      setState(() {});
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
                    value: _pushAnnouncement,
                    onChanged: (val) {
                      _pushAnnouncement = val;
                      setState(() {});
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
