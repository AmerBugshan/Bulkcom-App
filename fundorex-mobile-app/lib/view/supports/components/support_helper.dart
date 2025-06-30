import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class SupportHelper {
  ConstantColors cc = ConstantColors();
  statusCapsule(String capsuleText, Color color) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 11),
        decoration: BoxDecoration(
            color: color.withOpacity(.1),
            borderRadius: BorderRadius.circular(4)),
        child: Text(
          ln.getString(capsuleText),
          style: TextStyle(
              color: color, fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ),
    );
  }

  statusCapsuleBordered(String capsuleText, Color color) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(color: cc.borderColor),
            color: Colors.white,
            borderRadius: BorderRadius.circular(4)),
        child: Text(
          ln.getString(capsuleText),
          style: TextStyle(
              color: color, fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ),
    );
  }

  ///
  orderRow(String icon, String title, String text) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //icon
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: Row(children: [
              SvgPicture.asset(
                icon,
                height: 19,
              ),
              const SizedBox(
                width: 7,
              ),
              Text(
                ln.getString(title),
                style: TextStyle(
                  color: cc.greyFour,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              )
            ]),
          ),

          Flexible(
            child: Text(
              ln.getString(text),
              style: TextStyle(
                color: cc.greyFour,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }

  ticketChatAppbar(BuildContext context, {required title, required ticketId}) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16, left: 8),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: cc.greyParagraph,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "#$ticketId",
                      style: TextStyle(color: cc.primaryColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
