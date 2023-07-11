import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? fontSize;
  final String label;
  final Alignment? alignment;
  final Function()? onClick;

  const CustomButton({
    Key? key,
    required this.label,
    this.height,
    this.width,
    this.fontSize,
    this.alignment,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onClick,
        child: Container(
          alignment: alignment,
          width: MediaQuery.of(context).size.width * .6,
          child: Text(
            label,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}
