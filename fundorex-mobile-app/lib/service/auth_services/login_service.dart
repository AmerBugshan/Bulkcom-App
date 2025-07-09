// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/string_extension.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common_service.dart';

class LoginService with ChangeNotifier {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Future<bool> sendOtp(String phone, BuildContext context) async {
    setLoadingTrue();
    try {
      final response = await http.post(
        Uri.parse('$baseApi/send-login-otp'),
        headers: {
          'Accept': 'application/json', // مهم جدا
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'phone': phone},
      );

      setLoadingFalse();

      if (response.statusCode == 200) {
        return true;
      } else {
        try {
          final js = jsonDecode(response.body);
          (js["message"] ?? "حدث خطأ أثناء إرسال الرمز").toString().showToast();
        } catch (e) {
          // فشل قراءة الرسالة من الرد
          print('رد غير متوقع: ${response.body}');
          "حدث خطأ غير متوقع من الخادم".showToast();
        }
        return false;
      }
    } catch (e) {
      setLoadingFalse();
      print("Exception during sendOtp: $e");
      "فشل الاتصال بالخادم".showToast();
      return false;
    }
  }


  Future<bool> verifyOtp(String phone, String otp, BuildContext context) async {
    setLoadingTrue();
    try {
      final response = await http.post(
        Uri.parse('$baseApi/verify-login-otp'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'phone': phone,
          'otp_code': otp,
        },
      );

      setLoadingFalse();

      if (response.statusCode == 200 || response.statusCode == 302) {
        final prefs = await SharedPreferences.getInstance();
        final js = jsonDecode(response.body);

        // حفظ التوكن إن وُجد
        if (js.containsKey("token")) {
          prefs.setString("token", js["token"]);
          prefs.setBool('keepLoggedIn', true);
        }

        // تحميل البيانات الشخصية
        await Provider.of<ProfileService>(context, listen: false).fetchData();

        return true;
      } else {
        final js = jsonDecode(response.body);
        (js["message"] ?? "رمز التحقق غير صحيح").toString().showToast();
        return false;
      }
    } catch (e) {
      setLoadingFalse();
      "حدث خطأ أثناء التحقق".showToast();
      return false;
    }

  }
  Future<void> saveDetails(
      String phone, password, String token, int userId, String countryId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("phone", phone);
    prefs.setBool('keepLoggedIn', true);
    prefs.setString("token", token);
    prefs.setInt('userId', userId);
    prefs.setString("countryId", countryId.toString());
    print('token is $token');
    print('user id is $userId');
  }

}
