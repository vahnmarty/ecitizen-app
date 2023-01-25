import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/constancts.dart';
import '../themes.dart';



class RoundedTextField extends StatelessWidget {
  RoundedTextField(
      {Key? key,
      required this.label,
      required this.icon,
      this.controller,
      this.obscureText = false,
      this.errorText = '',
      this.prefixText = '',
      this.hintText = '',
      this.inputType = TextInputType.text,
      this.showNonNumericDigits = true})
      : super(key: key);
  final String label;
  final IconData icon;
  TextEditingController? controller;
  bool obscureText = false;
  String errorText;
  String prefixText;
  String hintText;
  TextInputType inputType;
  bool showNonNumericDigits;

  ValueNotifier<bool> _toggle = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    _toggle.value=obscureText;
    return SizedBox(
      width: getWidth(context) - 66,
      child: ValueListenableBuilder(
        valueListenable: _toggle,
        builder: (BuildContext context, bool notifier, Widget? child) {
          return TextField(
            keyboardType: inputType,
            controller: controller,
            obscureText: _toggle.value,
            inputFormatters: showNonNumericDigits
                ? null
                : <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: InputDecoration(
              prefixText:
              (prefixText != null || prefixText != '') ? prefixText : null,
              hintText: hintText,
              labelText: label,
              labelStyle: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
              floatingLabelStyle: TextStyle(
                fontSize: 13,
                color: Theme.of(context).accentColor,
              ),
              errorText: (errorText != null || errorText != '') ? errorText : null,
              errorMaxLines: 5,
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              errorStyle: TextStyle(
                fontSize: 11,
                color: Theme.of(context).errorColor,
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mainColor),
                  borderRadius: BorderRadius.circular(10)),
              prefixIcon: Icon(
                icon,
                color: AppColors.iconLightGrey,
              ),
              suffixIcon:obscureText? InkWell(
                  onTap: () {
                    _toggle.value = !_toggle.value;
                  },
                  child: Icon(
                    notifier? Icons.visibility_off:Icons.visibility,
                    color: AppColors.iconLightGrey,
                  )):null,

              // borderRadius: BorderRadius.circular(10)
              // borderRadius: BorderRadius.circular(10)
              contentPadding: EdgeInsets.zero,
            ),
          );
        },
      ),
    );
  }
}
