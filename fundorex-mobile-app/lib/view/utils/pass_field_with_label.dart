import 'package:flutter/material.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import '/helper/extension/string_extension.dart';

import 'field_label.dart';

class PassFieldWithLabel extends StatelessWidget {
  final String label;
  final String hintText;
  final initialValue;
  final onChanged;
  final onFieldSubmitted;
  final validator;
  final keyboardType;
  final textInputAction;
  final String? svgPrefix;
  final controller;
  final valueListenable;
  const PassFieldWithLabel({
    super.key,
    required this.label,
    required this.hintText,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.svgPrefix,
    this.controller,
    this.valueListenable,
  });

  @override
  Widget build(BuildContext context) {
    // controller?.text = initialValue ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label: label),
        ValueListenableBuilder(
          valueListenable: valueListenable,
          builder: (context, value, child) => TextFormField(
            keyboardType: keyboardType,
            textInputAction: textInputAction ?? TextInputAction.next,
            controller: controller,
            obscureText: value == true,
            decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: svgPrefix != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: svgPrefix!.toSVG,
                      )
                    : null,
                suffixIcon: GestureDetector(
                  onTap: () => valueListenable.value = !(value == true),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      (value == true)
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: cc.black5,
                    ),
                  ),
                )),
            onChanged: onChanged,
            validator: validator ??
                (value) {
                  return value!.length < 6
                      ? "Password must be at least 6 character"
                      : null;
                },
            onFieldSubmitted: onFieldSubmitted,
          ),
        )
      ],
    );
  }
}
