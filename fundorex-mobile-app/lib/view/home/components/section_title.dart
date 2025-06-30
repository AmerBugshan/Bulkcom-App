import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:provider/provider.dart';

import '../../utils/constant_colors.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.cc,
    required this.title,
    required this.pressed,
    this.hasSeeAllBtn = true,
  });

  final ConstantColors cc;
  final String title;
  final VoidCallback pressed;
  final bool hasSeeAllBtn;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Row(
        children: [
          CommonHelper().titleCommon(title, fontsize: 17),
          hasSeeAllBtn == true
              ? Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: pressed,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          ln.getString("See all"),
                          style: TextStyle(
                            color: cc.primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: cc.primaryColor,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
