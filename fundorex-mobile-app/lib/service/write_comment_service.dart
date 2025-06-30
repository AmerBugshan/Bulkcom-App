import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common_service.dart';

class WriteCommentService with ChangeNotifier {
  bool isloading = false;
  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Future<bool> writeComment(message, campaignId, BuildContext context) async {
    var connection = await checkConnection();
    if (connection) {
      setLoadingTrue();

      SharedPreferences prefs = await SharedPreferences.getInstance();

      var token = prefs.getString('token');
      var userId = prefs.getInt('userId');
      var userName = Provider.of<ProfileService>(context, listen: false)
              .profileDetails
              .name ??
          '';

      var data = jsonEncode({
        'cause_id': campaignId,
        'user_id': userId,
        'commented_by': userName,
        'comment_content': message
      });

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      var response = await http.post(
          Uri.parse('$baseApi/user/donation/comment-store'),
          body: data,
          headers: header);

      setLoadingFalse();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var res =
            await Provider.of<CampaignDetailsService>(context, listen: false)
                .fetchCampaignDetails(context: context, campaignId: campaignId);

        Navigator.pop(context);

        return true;
      } else {
        //Sign up unsuccessful ==========>
        OthersHelper()
            .showToast(jsonDecode(response.body)['message'], Colors.black);

        return false;
      }
    } else {
      //internet connection off
      return false;
    }
  }
}
