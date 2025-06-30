import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class SingleMenuItem extends StatelessWidget {
  const SingleMenuItem({
    super.key,
    required this.cc,
    required this.iconSvg,
    required this.title,
  });

  final ConstantColors cc;
  final iconSvg;
  final title;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Consumer<AppStringService>(
          builder: (context, ln, child) => Row(
            children: [
              SvgPicture.asset(iconSvg),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  ln.getString(title),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: cc.greyFour),
                ),
              ),
              const SizedBox(
                width: 9,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: cc.greyFour,
                size: 14,
              )
            ],
          ),
        ));
  }
}
