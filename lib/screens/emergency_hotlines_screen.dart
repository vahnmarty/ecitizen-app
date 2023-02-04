import 'package:citizen/models/hotlines_model.dart';
import 'package:citizen/providers/hotlines_provider.dart';
import 'package:citizen/screens/LGU_offices_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/material/dropdown.dart';
import '../constants/constancts.dart';
import '../models/hotline_categories_model.dart';
import '../themes.dart';
import '../widgets/bottom_navigation.dart';

class EmergencyHotlinesScreen extends StatefulWidget {
  const EmergencyHotlinesScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyHotlinesScreen> createState() =>
      _EmergencyHotlinesScreenState();
}

class _EmergencyHotlinesScreenState extends State<EmergencyHotlinesScreen> {
  List<HotlineCategoryModel> hotlineCategories = [
    HotlineCategoryModel(id: '-1', name: 'All'),
    HotlineCategoryModel(id: '1', name: 'Police Station'),
    HotlineCategoryModel(id: '2', name: 'Fire Station'),
  ];
  HotlineCategoryModel selectedHotlineCategory =
      HotlineCategoryModel(id: '-1', name: 'All');

  _handleDropDownSelectedValue(HotlineCategoryModel val) {
    setState(() {
      selectedHotlineCategory = val;
    });
  }
  _handleCachedData(provider) async {
    bool connection = await internetConnectivity();
    if (!connection) {
      final hotlines = await getEmergencyHotlines();
      if (hotlines != null) {
        provider.myHotlines = hotlines;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<HotlinesProvider>().getHotlines();
        context.read<HotlinesProvider>().getHotlineCategories();
        _handleCachedData(context.read<HotlinesProvider>());
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
      body: Consumer<HotlinesProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              provider.categoriesLoading
                  ? DropDownWidget(
                      list: hotlineCategories,
                      callback: _handleDropDownSelectedValue)
                  : DropDownWidget(
                      list: provider.hotlineCategories.isEmpty
                          ? hotlineCategories
                          : provider.hotlineCategories,
                      callback: _handleDropDownSelectedValue),
              Expanded(
                child: provider.isLoading
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
                              return selectedHotlineCategory.id=='-1'?_HotlinesListItem(
                                  hotline: provider.myHotlines[index]): provider.myHotlines[index].hotlineCategory
                                          .toString() ==
                                      selectedHotlineCategory.id
                                  ? _HotlinesListItem(
                                      hotline: provider.myHotlines[index])
                                  : const SizedBox();
                            }),
                      ),
              ),
            ],
          );
        },
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
                          onPressed: () {
                            makePhoneCall(hotline.numbers![index].number!);
                          },
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
  final List<HotlineCategoryModel> list;
  final Function callback;

  DropDownWidget({Key? key, required this.list, required this.callback})
      : super(key: key);

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
            value: widget.list[selectedIndex],
            isExpanded: true,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.iconLightGrey,
            ),
            underline: Container(
              color: Colors.transparent,
            ),
            items: widget.list.map<DropdownMenuItem<HotlineCategoryModel>>(
                (HotlineCategoryModel val) {
              return DropdownMenuItem(
                  value: val,
                  child: Text(
                    val.name!,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ));
            }).toList(),
            onChanged: (HotlineCategoryModel? val) {
              selectedIndex = getIndex(val!);
              widget.callback(val);
              setState(() {});
            }),
      ),
    );
  }

  getIndex(HotlineCategoryModel val) {
    for (var i = 0; i < widget.list.length; i++) {
      if (widget.list[i].id == val.id) {
        return i;
      }
    }
  }
}
