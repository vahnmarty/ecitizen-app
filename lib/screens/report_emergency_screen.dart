import 'dart:io';

import 'package:citizen/constants/constancts.dart';
import 'package:citizen/providers/location_provider.dart';
import 'package:citizen/providers/services_provider.dart';
import 'package:citizen/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../helpers/session_helper.dart';
import '../themes.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/raised_btn.dart';
import '../widgets/upload_image_widget.dart';

final List<String> _emergencies = [
  'Fire',
  'Accident',
  'Medical',
  'Crime',
  'Disaster',
  'Other'
];

class ReportEmergencyScreen extends StatelessWidget {
  ReportEmergencyScreen({Key? key}) : super(key: key);
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  ValueNotifier<String> _selectedValue = ValueNotifier('Fire');
  bool _checked = true;
  File? pickedImage;
  int _selectedIndex = 0;

  _handleSelectedIndex(int index) {
    _selectedIndex = index;
    _selectedValue.value = _emergencies[index];
  }

  @override
  Widget build(BuildContext context) {
    final locProvider = Provider.of<LocationProvider>(context);
    if (locProvider.address != '') {
      _locationController.text = locProvider.address;
    }
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      'You selected: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _selectedValue,
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return Text(
                          value,
                          style: _commonTextStyle,
                        );
                      },
                    )
                  ],
                ),
              ),
              _CardsGridLayout(
                callBack: _handleSelectedIndex,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0, bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Location',
                      style: _commonTextStyle,
                    ),
                    locProvider.address == ''
                        ? const Expanded(
                            child: Text(
                            '* Cannot fetch your current location because of http issue',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ))
                        : const SizedBox(),
                  ],
                ),
              ),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  prefixText: '   ',
                  hintText: 'Enter your address here',
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  'Write Description',
                  style: _commonTextStyle,
                ),
              ),
              TextField(
                maxLines: 6,
                controller: _descriptionController,
                decoration: InputDecoration(
                  prefixText: '   ',
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  'Upload Photo (Optional)',
                  style: _commonTextStyle,
                ),
              ),
              UploadImageWidget(
                callback: (File? image) {
                  pickedImage = image;
                },
              ),
              TermsCheckbox(
                callBack: (bool val) {
                  _checked = val;
                },
              ),
              Consumer<ServicesProvider>(
                builder: (context, servicesProvider, child) {
                  return servicesProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.mainColor,
                          ),
                        )
                      : RaisedBtn(
                          title: 'Submit Report',
                          callback: () async {
                            bool connected = await internetConnectivity();
                            debugPrint('connected: $connected');
                            if (!connected) {
                              final result = await sendSms(
                                  'type:${_selectedIndex + 1}, Adr: ${_locationController.text}, lat: ${locProvider.lat}, lng: ${locProvider.lng}, Des: ${_descriptionController.text}');
                              //replaceScreen(context, HomeScreen());
                              debugPrint('sms result: $result');
                              if (result == SMSSTATUS.SENT) {
                                showAlertDialog(context, 'Success',
                                    'Your report has been submitted successfully!',
                                    type: AlertType.SUCCESS,
                                    okButtonText: 'Back to Home',
                                    showCancelButton: false, onPress: () {
                                  replaceScreen(context, HomeScreen());
                                });
                              } else if (result == SMSSTATUS.NOTGRANTED) {
                                showAlertDialog(
                                    context,
                                    'Permission not Granted',
                                    'You have not granted permisson to app to send sms! Please enable sms permission for app to work properly',
                                    type: AlertType.WARNING,
                                    okButtonText: 'Grant Permission',
                                    showCancelButton: true, onPress: () async {
                                  Navigator.of(context).pop();
                                  openAppSettings();
                                  debugPrint('ook');
                                });
                              } else if (result == SMSSTATUS.NOTCAPABLE) {
                                showAlertDialog(context, 'Device Incompatible',
                                    'Your device is incompatible to send sms in background',
                                    type: AlertType.INFO,
                                    showCancelButton: false,
                                    okButtonText: 'Okay', onPress: () {
                                  Navigator.of(context).pop();
                                });
                              } else if (result == SMSSTATUS.NOTSENT) {
                                showAlertDialog(context, 'Sms Not Sent',
                                    'Unable to send sms to emergency help line!',
                                    type: AlertType.ERROR,
                                    showCancelButton: false,
                                    okButtonText: 'Okay', onPress: () {
                                  Navigator.of(context).pop();
                                });
                              } else {
                                showAlertDialog(
                                    context, 'Sent', 'Sms Sent Successfully',
                                    type: AlertType.SUCCESS,
                                    showCancelButton: false,
                                    okButtonText: 'Ok', onPress: () {
                                  Navigator.of(context).pop();
                                });
                              }
                              return;
                            }
                            final token = await getToken();
                            if (token == false ||
                                token == null ||
                                token == '') {
                              showToast('You are not login,login first!');
                              return;
                            }
                            if (_checked == false) {
                              showToast(
                                  'You have agreed to Terms and Conditions yet!');
                              return;
                            } else if (_locationController.text
                                .toString()
                                .isEmpty) {
                              showToast('Enter Your location');
                              return;
                            } else if (_descriptionController.text
                                .toString()
                                .isEmpty) {
                              showToast('Enter description first!');
                              return;
                            } else if (locProvider.lat.isEmpty ||
                                locProvider.lng.isEmpty) {
                              showToast('You have not enabled you location!');
                              return;
                            }
                            debugPrint('image path: $pickedImage');
                            bool withImage=false;
                            dynamic data = {
                              "type": "${_selectedIndex + 1}",
                              "description":
                              _descriptionController.text.toString(),
                              "latitude": locProvider.lat.toString(),
                              "longitude": locProvider.lng.toString(),
                              "address": _locationController.text.toString(),
                              "useragent": await getDeviceInfo(),
                            };
                            if (pickedImage != null) {
                              data["image"] = [pickedImage!.path];
                              withImage=true;
                            }
                            //debugPrint('data: $data');
                            final res = await servicesProvider.reportEmergency(
                                data, token, withImage);
                            debugPrint('res: $res');
                            if (res == true) {
                              showAlertDialog(context, 'Success',
                                  'Your report has been submitted successfully!',
                                  type: AlertType.SUCCESS,
                                  okButtonText: 'Back to Home',
                                  showCancelButton: false, onPress: () {
                                replaceScreen(context, HomeScreen());
                              });
                            } else {
                              showToast('Unable to Submit Report!');
                            }
                          },
                        );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}

class _CardsGridLayout extends StatefulWidget {
  final Function callBack;

  const _CardsGridLayout({Key? key, required this.callBack}) : super(key: key);

  @override
  State<_CardsGridLayout> createState() => _CardsGridLayoutState();
}

class _CardsGridLayoutState extends State<_CardsGridLayout> {
  int _selectedCard = 0;

  _handleOnTap(int index) {
    _selectedCard = index;
    widget.callBack(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                  onTap: () {
                    _handleOnTap(0);
                  },
                  child: _AnimatedCardContainer(
                      index: 0, selectedCard: _selectedCard)),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: InkWell(
                  onTap: () {
                    _handleOnTap(1);
                  },
                  child: _AnimatedCardContainer(
                      index: 1, selectedCard: _selectedCard)),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                  onTap: () {
                    _handleOnTap(2);
                  },
                  child: _AnimatedCardContainer(
                      index: 2, selectedCard: _selectedCard)),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: InkWell(
                  onTap: () {
                    _handleOnTap(3);
                  },
                  child: _AnimatedCardContainer(
                      index: 3, selectedCard: _selectedCard)),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                  onTap: () {
                    _handleOnTap(4);
                  },
                  child: _AnimatedCardContainer(
                      index: 4, selectedCard: _selectedCard)),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: InkWell(
                  onTap: () {
                    _handleOnTap(5);
                  },
                  child: _AnimatedCardContainer(
                      index: 5, selectedCard: _selectedCard)),
            ),
          ],
        ),
      ],
    );
  }
}

class _AnimatedCardContainer extends StatelessWidget {
  final int index;

  final int selectedCard;

  const _AnimatedCardContainer(
      {Key? key, required this.index, required this.selectedCard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: selectedCard == index ? 130 : 120,
      decoration: BoxDecoration(
          color: selectedCard == index ? AppColors.cardRedLight : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 1, color: AppColors.iconLight)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(
                'assets/icons/${_emergencies[index].toLowerCase()}.png'),
            height: 40,
            color: selectedCard == index ? Colors.white : Colors.black,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            _emergencies[index],
            style: selectedCard == index ? cardHeadingStyle : _commonTextStyle,
          )
        ],
      ),
    );
  }
}

class TermsCheckbox extends StatefulWidget {
  final Function callBack;

  const TermsCheckbox({Key? key, required this.callBack}) : super(key: key);

  @override
  _TermsCheckboxState createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox> {
  bool _checked = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: AppColors.btnBlue,
          value: _checked,
          onChanged: (bool? value) {
            setState(() {
              _checked = value!;
              widget.callBack(_checked);
            });
          },
        ),
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context)
                .style
                .copyWith(fontWeight: FontWeight.bold),
            children: const <TextSpan>[
              TextSpan(text: 'I have agreed to '),
              TextSpan(
                text: 'Terms and Conditions',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

TextStyle _commonTextStyle = cardHeadingStyle.copyWith(color: Colors.black);
