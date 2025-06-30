import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/context_extension.dart';
import 'package:fundorex/service/create_campaign_service.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common_service.dart';

class LogoutService with ChangeNotifier {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  logout(BuildContext context) async {
    var connection = await checkConnection();
    if (connection) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      setLoadingTrue();
      var response = await http.post(
        Uri.parse('$baseApi/user/logout'),
        headers: header,
      );
      setLoadingFalse();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        notifyListeners();

//pop sidebar
        // Navigator.pushAndRemoveUntil<dynamic>(
        //   context,
        //   MaterialPageRoute<dynamic>(
        //     builder: (BuildContext context) => const SplashScreen(),
        //   ),
        //   (route) => false,
        // );

        // clear profile data =====>
        Future.delayed(const Duration(microseconds: 500), () {
          Provider.of<ProfileService>(context, listen: false)
              .setEverythingToDefault();
        });

        //set landing page index to 0
        // Provider.of<BottomNavService>(context, listen: false)
        //     .setCurrentIndex(0);

        Provider.of<CreateCampaignService>(context, listen: false)
            .setCampaignCreatePermissionDefault();
        context.popFalse;
        clear();
      } else {
        print(response.body);
        OthersHelper().showToast('Something went wrong', Colors.black);
      }
    }
  }

  //clear saved email, pass and token
  clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
