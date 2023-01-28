import 'package:citizen/models/hotlines_model.dart';
import 'package:citizen/providers/hotlines_provider.dart';
import 'package:citizen/screens/LGU_offices_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/material/dropdown.dart';
import '../constants/constancts.dart';
import '../themes.dart';
import '../widgets/bottom_navigation.dart';

class EmergencyHotlinesScreen extends StatefulWidget {
  const EmergencyHotlinesScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyHotlinesScreen> createState() =>
      _EmergencyHotlinesScreenState();
}

class _EmergencyHotlinesScreenState extends State<EmergencyHotlinesScreen> {
  List<String> hotlineCategories = [
    "All",
    "Police Station",
    "Fire Station",
    "Medical Assistance",
    "Red Cross",
    "Local Government"
  ];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<HotlinesProvider>().getHotlines();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBg,
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
      body: Column(
        children: [
          DropDownWidget(
              list: hotlineCategories,
              callback: (String val) {
                debugPrint('selval: $val');
              }),
          Expanded(
            child: Consumer<HotlinesProvider>(
              builder: (context, provider, child) {
                return provider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: provider.myHotlines.length,
                            itemBuilder: (context, index) {
                              return _HotlinesListItem(
                                  hotline: provider.myHotlines[index]);
                            }),
                        /*child: GridView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200, mainAxisExtent: 240),
                          children: [
                            ...List.generate(
                                provider.myHotlines.length,
                                (index) => _HotlinesListItem(
                                    hotline: provider.myHotlines[index])),
                          ],
                        ),*/
                      );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}

class _HotlinesListItem extends StatelessWidget {
  final HotlinesModel hotline;

  const _HotlinesListItem({Key? key, required this.hotline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(2, 4), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          if (hotline.numbers![0].number!.isNotEmpty) {
            makePhoneCall(hotline.numbers![0].number!);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hotline.name!,
                style: cardHeadingStyle.copyWith(
                    fontSize: 16, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              ...List.generate(
                  hotline.numbers!.length,
                  (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: TextButton(
                          onPressed: (){makePhoneCall(hotline.numbers![index].number!);},
                          child: IconsAndText(
                              text: hotline.numbers![index].number!,
                              icon: Icons.phone,
                              iconColor: Colors.red,
                              textColor: Colors.red),
                        ),
                      )),
            ],
          ),
        ),
      ),
    );
  }
}

class DropDownWidget extends StatefulWidget {
  final List<String> list;
  final Function callback;

  DropDownWidget({Key? key, required this.list, required this.callback})
      : super(key: key);

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String selectedValue = '';

  bool init = false;

  @override
  Widget build(BuildContext context) {
    if (!init) {
      selectedValue = widget.list.first;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(2, 2),
                  blurRadius: 2,
                  spreadRadius: 2),
            ]),
        child: DropdownButton(
            value: selectedValue,
            isExpanded: true,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.iconLightGrey,
            ),
            underline: Container(
              color: Colors.transparent,
            ),
            items: widget.list.map<DropdownMenuItem<String>>((String val) {
              return DropdownMenuItem(
                  value: val,
                  child: Text(
                    val,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ));
            }).toList(),
            onChanged: (String? val) {
              init = true;
              selectedValue = val!;
              widget.callback(val);
              setState(() {});
            }),
      ),
    );
  }
}
