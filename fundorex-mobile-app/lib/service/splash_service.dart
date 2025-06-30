import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashService {
  loginOrGoHome(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //that means user is opening the app for the first time.. so , show the intro
    Future.delayed(const Duration(seconds: 2), () {});
  }
}
