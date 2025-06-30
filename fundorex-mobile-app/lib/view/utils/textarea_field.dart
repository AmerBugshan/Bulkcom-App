import 'package:flutter/material.dart';
import 'package:fundorex/view/utils/constant_colors.dart';

class TextareaField extends StatelessWidget {
  const TextareaField(
      {super.key, required this.controller, required this.hintText});
  final controller;
  final hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ConstantColors().greySecondary,
          borderRadius: BorderRadius.circular(9)),
      child: TextField(
          controller: controller,
          maxLines: 6,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(9)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ConstantColors().primaryColor)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ConstantColors().warningColor)),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ConstantColors().primaryColor)),
              hintText: hintText,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 18))),
    );
  }
}
