import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final Icon prefixIcon;
  final Widget suffixIcon;
  final Key key;
  final String errorText;

  final FocusNode focusNode;
  final String initialValue;
  final String hintText;
  final int maxLine;
  final bool isEnabled;
  final TextEditingController textEditingController;
  final double textFieldHeight;

  FormInput({
    @required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.isEnabled = true,
    this.suffixIcon,
    this.key,
    this.maxLine = 1,
    this.errorText,
    @required this.textEditingController,
    @required this.focusNode,
    this.initialValue,
    this.hintText,
    this.textFieldHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          focusNode: focusNode,
          controller: textEditingController,
          decoration: InputDecoration(
            filled: true,
            enabled: isEnabled,
            fillColor: Colors.redAccent.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,

            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorText: errorText,
            errorMaxLines: 3,
            hintText: hintText,
          ),
          style: TextStyle(fontSize: 18, letterSpacing: 0.7),
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLine,
          key: key,
          //onChanged: onChanged,
          initialValue: initialValue,
        ),
      ],
    );
  }
}
