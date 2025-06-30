import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class CommonHelper {
  ConstantColors cc = ConstantColors();
  //common appbar
  appbarCommon(String title, BuildContext context, VoidCallback pressed,
      {Color bgColor = Colors.transparent, bool hasBackBtn = true}) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: true,
      iconTheme: IconThemeData(color: cc.greyPrimary),
      title: Consumer<AppStringService>(
        builder: (context, ln, child) => Text(
          ln.getString(title),
          style: TextStyle(
              color: cc.greyPrimary, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: bgColor,
      elevation: 0,
      leading: hasBackBtn
          ? InkWell(
              onTap: pressed,
              child: const Icon(
                Icons.arrow_back_ios,
                size: 18,
              ),
            )
          : Container(),
    );
  }

  //common orange button =======>
  buttonPrimary(String title, VoidCallback pressed,
      {isloading = false,
      bgColor,
      double paddingVertical = 18,
      double borderRadius = 8,
      double fontsize = 14,
      Color fontColor = Colors.white,
      IconData? icon}) {
    return InkWell(
      onTap: pressed,
      child: Consumer<AppStringService>(
        builder: (context, ln, child) => Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: paddingVertical),
            decoration: BoxDecoration(
                color: bgColor ?? cc.primaryColor,
                borderRadius: BorderRadius.circular(borderRadius)),
            child: isloading == false
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          child: Icon(
                            icon,
                            color: Colors.white,
                          ),
                        ),
                      Text(
                        ln.getString(title),
                        style: TextStyle(
                          color: fontColor,
                          fontSize: fontsize,
                        ),
                      ),
                    ],
                  )
                : OthersHelper().showLoading(Colors.white)),
      ),
    );
  }

  borderButtonPrimary(String title, VoidCallback pressed,
      {double paddingVertical = 17, color}) {
    return InkWell(
      onTap: pressed,
      child: Consumer<AppStringService>(
        builder: (context, ln, child) => Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: paddingVertical),
            decoration: BoxDecoration(
                border: Border.all(color: color ?? cc.primaryColor),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              ln.getString(title),
              style: TextStyle(
                color: color ?? cc.primaryColor,
                fontSize: 14,
              ),
            )),
      ),
    );
  }

  labelCommon(String title, {double marginBottom = 15}) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Container(
        margin: EdgeInsets.only(bottom: marginBottom),
        child: Text(
          ln.getString(title),
          style: TextStyle(
            color: cc.greyThree,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  paragraphCommon(String title,
      {double fontsize = 14, TextAlign textAlign = TextAlign.left}) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Text(
        ln.getString(title),
        textAlign: textAlign,
        style: TextStyle(
          color: cc.greyParagraph,
          height: 1.4,
          fontSize: fontsize,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  titleCommon(String title, {double fontsize = 18, TextAlign? textAlign}) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Text(
        ln.getString(title),
        textAlign: textAlign,
        style: TextStyle(
            color: cc.greyFour,
            fontSize: fontsize,
            fontWeight: FontWeight.w600,
            height: 1.4),
      ),
    );
  }

  dividerCommon() {
    return Divider(
      thickness: 1,
      height: 2,
      color: cc.borderColor,
    );
  }

  checkCircle() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(shape: BoxShape.circle, color: cc.primaryColor),
      child: const Icon(
        Icons.check,
        size: 13,
        color: Colors.white,
      ),
    );
  }

  profileImage(String imageLink, double height, double width,
      {double radius = 6}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: imageLink,
        placeholder: (context, url) {
          return Image.asset('assets/images/placeholder.png');
        },
        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
    );
  }

  //no order found
  nothingfound(BuildContext context, String title) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Container(
          height: MediaQuery.of(context).size.height - 120,
          alignment: Alignment.center,
          child: Consumer<AppStringService>(
            builder: (context, ln, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  size: 26,
                  color: cc.greyFour,
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  ln.getString(title),
                  style: TextStyle(color: cc.greyFour),
                ),
              ],
            ),
          )),
    );
  }
}
