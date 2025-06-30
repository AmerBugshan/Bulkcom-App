import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/app_strings.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppStringService with ChangeNotifier {
  var tStrings;

  fetchTranslatedStrings() async {
    if (tStrings != null) {
      //if already loaded. no need to load again
      return;
    }
    var connection = await checkConnection();
    if (!connection) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var data = jsonEncode({
      'strings': jsonEncode(appStrings),
    });

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var response = await http.post(Uri.parse('$baseApi/translate-string'),
        headers: header, body: data);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      tStrings = jsonDecode(response.body)['strings'];
      notifyListeners();
    } else {
      print('error fetching translations ${response.body}');
      notifyListeners();
    }
  }

  getString(String staticString) {
    if (tStrings == null) {
      return staticString;
    }
    if (tStrings.containsKey(staticString)) {
      return tStrings[staticString];
    } else {
      return staticString;
    }
  }
}
