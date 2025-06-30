import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:provider/provider.dart';
import '../utils/common_helper.dart';

class ConstStyles {
  ConstantColors cc = ConstantColors();

  bottomSheetDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 8,
          blurRadius: 17,
          offset: const Offset(0, 0), // changes position of shadow
        ),
      ],
    );
  }

  rowLeftRight(String iconLink, String title, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //icon
        Row(children: [
          SvgPicture.asset(
            iconLink,
            height: 19,
          ),
          const SizedBox(
            width: 7,
          ),
          Text(
            title,
            style: TextStyle(
              color: cc.greyFour,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          )
        ]),

        Text(
          text,
          style: TextStyle(
            color: cc.greyFour,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }

  bdetailsContainer(String iconLink, String title, String text) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ConstStyles().rowLeftRight(iconLink, title, ''),
      const SizedBox(
        height: 10,
      ),
      Text(
        text,
        style: TextStyle(
          color: cc.greyFour,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      )
    ]);
  }

  commonRow(String title, String text, {bool lastBorder = false, icon}) {
    return Column(
      children: [
        Consumer<AppStringService>(
          builder: (context, ln, child) => Row(
            children: [
              //icon
              SizedBox(
                width: 125,
                child: Row(children: [
                  icon != null
                      ? Row(
                          children: [
                            SvgPicture.asset(
                              icon,
                              height: 19,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                          ],
                        )
                      : Container(),
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
        ),
        lastBorder == false
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 14),
                child: CommonHelper().dividerCommon(),
              )
            : Container()
      ],
    );
  }

  detailsPanelRowWithDollar(String title, int quantity, String price,
      {double priceFontSize = 16,
      FontWeight priceFontweight = FontWeight.w600}) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              ln.getString(title),
              style: TextStyle(
                color: cc.greyFour,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          quantity != 0
              ? Expanded(
                  flex: 1,
                  child: Text(
                    'x$quantity',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: cc.greyFour,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ))
              : Container(),
          Consumer<RtlService>(
            builder: (context, rtlP, child) => Expanded(
              flex: 1,
              child: Text(
                rtlP.currencyDirection == 'left'
                    ? "${rtlP.currency}$price"
                    : "$price${rtlP.currency}",
                textAlign:
                    rtlP.direction == 'ltr' ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  color: cc.greyFour,
                  fontSize: priceFontSize,
                  fontWeight: priceFontweight,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  capsule(String capsuleText) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 11),
      decoration: BoxDecoration(
          color: getCapsuleColor(capsuleText).withOpacity(.1),
          borderRadius: BorderRadius.circular(4)),
      child: Text(
        lnProvider.getString(capsuleText),
        style: TextStyle(
            color: getCapsuleColor(capsuleText),
            fontWeight: FontWeight.w600,
            fontSize: 12),
      ),
    );
  }

  getCapsuleColor(String status) {
    ConstantColors cc = ConstantColors();

    if (status.toLowerCase() == 'pending') {
      return Colors.yellow[800];
    } else if (status.toLowerCase() == 'cancel') {
      return Colors.red;
    } else {
      return cc.primaryColor;
    }
  }
}
