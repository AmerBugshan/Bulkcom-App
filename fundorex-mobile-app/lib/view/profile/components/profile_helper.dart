import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/auth_services/logout_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProfileHelper {
  ConstantColors cc = ConstantColors();

  logoutPopup(BuildContext context) {
    return Alert(
        context: context,
        style: AlertStyle(
            alertElevation: 0,
            overlayColor: Colors.black.withOpacity(.6),
            alertPadding: const EdgeInsets.all(25),
            isButtonVisible: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            titleStyle: const TextStyle(),
            animationType: AnimationType.grow,
            animationDuration: const Duration(milliseconds: 500)),
        content: Consumer<AppStringService>(
          builder: (context, ln, child) => Container(
            margin: const EdgeInsets.only(top: 22),
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.01),
                    spreadRadius: -2,
                    blurRadius: 13,
                    offset: const Offset(0, 13)),
              ],
            ),
            child: Column(
              children: [
                Text(
                  ln.getString('هل انت متأكد ؟'),
                  style: TextStyle(color: cc.greyPrimary, fontSize: 17),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                        child: CommonHelper().borderButtonPrimary('الغاء', () {
                      Navigator.pop(context);
                    })),
                    const SizedBox(
                      width: 16,
                    ),
                    Consumer<LogoutService>(
                      builder: (context, provider, child) => Expanded(
                          child: CommonHelper().buttonPrimary('Logout', () {
                        if (provider.isloading == false) {
                          provider.logout(context);
                          //if logged in by google then logout from it
                          // GoogleSignInService().logOutFromGoogleLogin();

                          //if logged in by facebook then logout from it
                          // FacebookLoginService().logoutFromFacebook();
                        }
                      },
                              isloading:
                                  provider.isloading == false ? false : true)),
                    ),
                  ],
                )
              ],
            ),
          ),
        )).show();
  }
}
