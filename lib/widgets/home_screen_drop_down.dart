import 'package:citizen/models/service_model.dart';
import 'package:citizen/providers/services_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class HomeScreenDropDown extends StatefulWidget {
  final Function callback;

  const HomeScreenDropDown({Key? key, required this.callback})
      : super(key: key);

  @override
  State<HomeScreenDropDown> createState() => _HomeScreenDropDownState();
}

class _HomeScreenDropDownState extends State<HomeScreenDropDown> {
  String _selectedValue = 'I want to apply for....';
  bool _isSelected = false;
  final List<ServiceModel> _dropDownItems = [
    ServiceModel(name: "I want to apply for....")
  ];
  @override
  Widget build(BuildContext context) {
    List<ServiceModel> list =[];
    final serviceProvider = Provider.of<ServicesProvider>(context);
    if(serviceProvider.isLoading){
      list = _dropDownItems;
    }else{
      list=  serviceProvider.services;
    }

    //debugPrint('1:${_selectedValue}');
    if (!_isSelected) {
      _selectedValue = list.first.name!;
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
          value: _selectedValue,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.iconLightGrey,
          ),
          underline: Container(
            color: Colors.transparent,
          ),
          items: list.map<DropdownMenuItem<String>>((ServiceModel val) {
            return DropdownMenuItem(
                value: val.name,
                child: Text(
                  val.name!,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ));
          }).toList(),
          onChanged: (String? val) {
            _isSelected = true;
            _selectedValue = val!;
            widget.callback(val);
            setState(() {});
          }),
    );
  }
}
