import 'package:flutter/material.dart';
import 'package:fundorex/view/utils/constant_colors.dart';

import '/helper/extension/context_extension.dart';

class FieldLabel extends StatelessWidget {
  final String label;
  const FieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: context.titleMedium!
            .copyWith(color: cc.black5, fontWeight: FontWeight.w600),
      ),
    );
  }
}
