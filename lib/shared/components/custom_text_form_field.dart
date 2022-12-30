import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final double? heightWithLabel;
  final double? height;
  final double? width;
  final double? radiusBorder;
  final Color? hintColor;
  final Color? fillColor;
  final Color? backgroundColor;
  final TextAlign? textAlign;
  final String? initialValue;
  final TextAlignVertical? textAlignVertical;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final bool autofocus;
  final String obscuringCharacter;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final bool obscureText;
  final bool enabled;

  const CustomTextFormField({
    Key? key,
    this.label,
    this.heightWithLabel,
    this.height,
    this.hintColor,
    this.fillColor,
    this.textAlign,
    this.textAlignVertical,
    this.keyboardType,
    this.controller,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.inputFormatters,
    this.focusNode,
    this.decoration,
    this.width,
    this.radiusBorder,
    this.obscureText = false,
    this.enabled = true,
    this.onFieldSubmitted,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightWithLabel ?? 53,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    label!,
                  ),
                ),
          const SizedBox(height: 4),
          SizedBox(
            height: height ?? 30,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    textAlign: textAlign ?? TextAlign.start,
                    textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
                    obscureText: obscureText,
                    onChanged: onChanged,
                    initialValue: initialValue,
                    controller: controller,
                    obscuringCharacter: obscuringCharacter,
                    autofocus: autofocus,
                    focusNode: focusNode,
                    keyboardAppearance: Brightness.dark,
                    keyboardType: keyboardType,
                    validator: validator,
                    enabled: enabled,
                    inputFormatters: inputFormatters,
                    onFieldSubmitted: onFieldSubmitted,
                    decoration: decoration ??
                        InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(radiusBorder ?? 10.0),
                            ),
                          ),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          hintStyle: TextStyle(color: hintColor ?? Colors.grey[800]),
                          fillColor: fillColor ?? Colors.white70,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
