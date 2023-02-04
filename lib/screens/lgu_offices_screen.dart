import 'package:citizen/models/directory_model.dart';
import 'package:citizen/providers/directory_provider.dart';
import 'package:citizen/widgets/title_card_with_shadow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constancts.dart';
import '../themes.dart';
import '../widgets/bottom_navigation.dart';

class LGUOfficesScreen extends StatefulWidget {
  const LGUOfficesScreen({Key? key}) : super(key: key);

  @override
  State<LGUOfficesScreen> createState() => _LGUOfficesScreenState();
}
_handleCachedData(provider) async {
  bool connection = await internetConnectivity();
  if (!connection) {
    final directories = await getLguOfficesDirectories();
    if (directories != null) {
      provider.myDirectories = directories;
    }
  }
}

class _LGUOfficesScreenState extends State<LGUOfficesScreen> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<DirectoryProvider>().getDirectories();
        _handleCachedData(context.read<DirectoryProvider>());
      });
    }
  }

  int _selectedCardIndex = -1;
  TextEditingController _searchController = TextEditingController();

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
          const TitleCardWithShadow(title: 'LGU Offices Directory'),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: ' Type to search here',
                labelStyle: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
                errorText: '',
                errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8)),
                errorStyle: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).errorColor,
                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.mainColor),
                    borderRadius: BorderRadius.circular(8)),
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(child: Consumer<DirectoryProvider>(
            builder: (context, provider, child) {
              return provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.mainColor,
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: provider.myDirectories.length,
                      itemBuilder: (context, index) {
                        if (_searchController.text.toString().trim() == '') {
                          return _DirectoryListItem(
                            index: index,
                            isSelected: _selectedCardIndex == index,
                            directory: provider.myDirectories[index],
                            callback: (int selectedIndex) {
                              _selectedCardIndex = selectedIndex;

                              setState(() {});
                            },
                          );
                        }
                        if (provider.myDirectories[index].name!
                                .toLowerCase()
                                .contains(_searchController.text
                                    .toString()
                                    .toLowerCase()) ||
                            provider.myDirectories[index].address!
                                .toLowerCase()
                                .contains(_searchController.text
                                    .toString()
                                    .toLowerCase()) ||
                            provider.myDirectories[index].telephone!
                                .contains(_searchController.text)) {
                          return _DirectoryListItem(
                            index: index,
                            isSelected: _selectedCardIndex == index,
                            directory: provider.myDirectories[index],
                            callback: (int selectedIndex) {
                              _selectedCardIndex = selectedIndex;

                              setState(() {});
                            },
                          );
                        }
                        return const SizedBox() /*_DirectoryListItem(
                          index: index,
                          isSelected: _selectedCardIndex == index,
                          directory: provider.myDirectories[index],
                          callback: (int selectedIndex) {
                            _selectedCardIndex = selectedIndex;

                            setState(() {});
                          },
                        )*/
                            ;
                      });
            },
          )),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}

class _DirectoryListItem extends StatelessWidget {
  final int index;
  final bool isSelected;
  final Function callback;
  final DirectoryModel directory;

  const _DirectoryListItem(
      {Key? key,
      required this.isSelected,
      required this.callback,
      required this.directory,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey,
      onTap: () {
        callback(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                end: Alignment.topRight,
                begin: Alignment.bottomLeft,
                colors: isSelected
                    ? [AppColors.gradientBlue, AppColors.gradientPurple]
                    : [Colors.white, Colors.white]),
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  directory.name!,
                  style: cardHeadingStyle.copyWith(
                      fontSize: 18,
                      color: isSelected ? Colors.white : Colors.black),
                ),
              ),
              if (directory.address != '')
                IconsAndText(
                  text: directory.address!,
                  icon: Icons.location_on,
                  iconColor: Colors.green,
                  textColor: isSelected ? Colors.white : Colors.black,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    if (directory.cellphone != '')
                      Expanded(
                        child: IconsAndText(
                          text: directory.cellphone!,
                          icon: Icons.phone,
                          iconColor: Colors.blue,
                          textColor: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    if (directory.email != '')
                      Expanded(
                        child: IconsAndText(
                          text: directory.email!,
                          icon: Icons.mail_outline_sharp,
                          iconColor: AppColors.gradientPurple,
                          textColor: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  if (directory.cellphone != '')
                    _CardButton(
                      email: false,
                      callback: () {
                        makePhoneCall(directory.cellphone!);
                      },
                      isSelected: isSelected,
                    ),
                  const SizedBox(
                    width: 12,
                  ),
                  if (directory.email != '')
                    _CardButton(
                      email: true,
                      callback: () {
                        openMail(context, directory.email!, directory.name!);
                      },
                      isSelected: isSelected,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  final bool email;
  final VoidCallback callback;
  final bool isSelected;

  const _CardButton(
      {Key? key,
      required this.email,
      required this.callback,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      onTap: callback,
      splashColor: Colors.grey,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: isSelected
                ? null
                : Border.all(color: Colors.black, width: 0.4)),
        child: Row(
          children: [
            Icon(
              email ? Icons.mail_outline : Icons.phone,
              color: Colors.black,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              email ? 'MAIL US' : 'CALL US',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ));
  }
}

class IconsAndText extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final Color textColor;

  const IconsAndText(
      {Key? key,
      required this.text,
      required this.icon,
      required this.iconColor,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
            child: Text(
          text,
          maxLines: 1,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          overflow: TextOverflow.ellipsis,
        )),
      ],
    );
  }
}
