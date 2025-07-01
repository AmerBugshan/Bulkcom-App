import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fundorex/data/network/network_api_services.dart';
import 'package:fundorex/helper/extension/context_extension.dart';
import 'package:fundorex/helper/extension/string_extension.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../view/intro/splash.dart';
import 'bottom_nav_service.dart';
import 'create_campaign_service.dart';
import 'profile_service.dart';

class AccountDeleteService with ChangeNotifier {
  bool isLoading = false;

  tryAccountDelete(BuildContext context) async {
    final url = "$baseApi/user/deactivate";
    var id = sPref.getInt('userId');
    var data = jsonEncode({'user_id': "id".toString()});
    isLoading = true;
    if (baseApi.contains("bulk")) {
      await Future.delayed(const Duration(seconds: 1));
      "This function is turned off for demo app".showToast();

      context.popFalse;
      return true;
    }
    notifyListeners();
    final responseData = await NetworkApiServices()
        .postApi(data, url, "Account Delete".tr(), headers: commonAuthHeader);
    if (responseData != null) {
      await appleTokenRevoke(
        getToken,
        id,
      );
      debugPrint(responseData.toString());
      "Account deleted successfully".tr().showToast();
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const SplashScreen(),
        ),
        (route) => false,
      );

      // clear profile data =====>
      Future.delayed(const Duration(microseconds: 500), () {
        Provider.of<ProfileService>(context, listen: false)
            .setEverythingToDefault();
      });

      //set landing page index to 0
      Provider.of<BottomNavService>(context, listen: false).setCurrentIndex(0);

      Provider.of<CreateCampaignService>(context, listen: false)
          .setCampaignCreatePermissionDefault();
      sPref.clear();
      isLoading = false;
      notifyListeners();
      // return true;
      // }
      // (responseData["msg"]?.toString() ?? "Account delete failed")
      //     .tr()
      //     .showToast();
      isLoading = false;
      notifyListeners();
    } else {}
  }

  appleTokenRevoke(token, id) async {
    if (!Platform.isIOS) {
      return;
    }
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      // "Accept": "application/json",
      'content-type': 'application/x-www-form-urlencoded',
    };

    debugPrint(
        'https://appleid.apple.com/auth/revoke?client_id=$id&client_secret=$clientSecret&token=$token&token_type_hint=access_token');
    var response = await http.post(
      Uri.parse(
          'https://appleid.apple.com/auth/revoke?client_id=$id&client_secret=$clientSecret&token=$token&token_type_hint=access_token'),
      headers: header,
    );
    print(id);
    print(response.statusCode);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      "Apple id revoked successfully".tr().showToast();
    } else {
      "Apple id revoke failed".tr().showToast();
    }
  }
}
