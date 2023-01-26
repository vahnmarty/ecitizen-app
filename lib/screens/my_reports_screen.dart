import 'dart:developer';

import 'package:citizen/models/report_model.dart';
import 'package:citizen/providers/services_provider.dart';
import 'package:citizen/widgets/title_card_with_shadow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constancts.dart';
import '../themes.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({Key? key}) : super(key: key);

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ServicesProvider>().getMyReports();
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
      ),
      body: Consumer<ServicesProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              const TitleCardWithShadow(title: 'My Reports'),
              provider.isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: provider.myReports.length,
                          itemBuilder: (context, index) {
                            return _MyReportCard(
                                report: provider.myReports[index]);
                          })),
            ],
          );
        },
      ),
    );
  }
}

class _MyReportCard extends StatelessWidget {
  final ReportModel report;

  const _MyReportCard({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Image(
                  image: AssetImage('assets/icons/${getImage(report.type!)}'),
                  height: 20,
                  color: AppColors.cardRedLight,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                    child: Text(
                  '${report.description}',
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Icon(
                  Icons.watch_later_outlined,
                  color: Colors.blue,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                    child: Text(
                  '${getFormattedDateTime(report.createdAt!)}',
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                    child: Text(
                  '${report.address}',
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            ),
            const SizedBox(height: 6,),
            report.status=='PENDING'? Container(
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                color: AppColors.reportLightRed,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.reportDarkRed,width: 0.5)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(width: 12,height: 12,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: AppColors.reportDarkRed,
                      borderRadius: BorderRadius.circular(16)
                    ),),
                    const Text('Pending Verification'),
                  ],
                ),
              ),
            ):
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green,width: 0.8)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(width: 12,height: 12,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(16)
                      ),),
                    const Text('Verified'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6,)
          ],
        ),
      ),
    );
  }
}

getImage(String type) {
  switch (type) {
    case '1':
      return 'fire.png';
    case '2':
      return 'accident.png';
    case '3':
      return 'medical.png';
    case '4':
      return 'crime.png';
    case '5':
      return 'disaster.png';
    case '6':
      return 'other.png';
  }
}
