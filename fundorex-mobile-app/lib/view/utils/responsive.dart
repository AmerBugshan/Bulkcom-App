import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late bool isIos;

late double screenWidth;
late double screenHeight;
late AppStringService lnProvider;
late RtlService rtl;

late SharedPreferences sPref;

String get getToken {
  debugPrint(sPref.getString("token").toString());
  return sPref.getString("token") ?? "";
}

setToken(token) {
  sPref.setString("token", token ?? "");
}

get commonAuthHeader => {'Authorization': 'Bearer $getToken'};

getScreenSize(BuildContext context) async {
  screenWidth = MediaQuery.of(context).size.width;
  screenHeight = MediaQuery.of(context).size.height;
  rtl = Provider.of<RtlService>(context, listen: false);
  initLang(context);
  sPref = await SharedPreferences.getInstance();
}

initLang(BuildContext context) {
  lnProvider = Provider.of<AppStringService>(context, listen: false);
}

screenSizeAndPlatform(BuildContext context) {
  getScreenSize(context);
  checkPlatform();
}
//responsive screen codes ========>

var fourinchScreenHeight = 610;
var fourinchScreenWidth = 385;

checkPlatform() {
  if (Platform.isAndroid) {
    isIos = false;
  } else if (Platform.isIOS) {
    isIos = true;
  }
}
