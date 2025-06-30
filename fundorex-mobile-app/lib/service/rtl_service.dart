// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:http/http.dart' as http;

class RtlService with ChangeNotifier {
  /// RTL support
  String direction = 'ltr';

  String currency = '\$';
  String currencyDirection = 'left';

  bool alreadyCurrencyLoaded = false;
  bool alreadyRtlLoaded = false;

  fetchCurrency() async {
    if (alreadyCurrencyLoaded == false) {
      var response = await http.get(Uri.parse('$baseApi/currencies'));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        currency = jsonDecode(response.body)['currency']
            ['site_default_currency_symbol'];
        currencyDirection = jsonDecode(response.body)['currency']['position'];
        alreadyCurrencyLoaded == true;
        notifyListeners();
      } else {
        print('failed loading currency');
        print(response.body);
      }
    } else {
      //already loaded from server. no need to load again
    }
  }

  fetchDirection() async {
    if (alreadyRtlLoaded == false) {
      var response = await http.get(Uri.parse('$baseApi/language-rtl-support'));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        direction =
            jsonDecode(response.body)['language']['defualt_language_direction'];
        alreadyRtlLoaded == true;
        notifyListeners();
      } else {
        print('failed loading language direction /RTL');
        print(response.body);
      }
    } else {
      //already loaded from server. no need to load again
    }
  }
}
