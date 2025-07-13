import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/context_extension.dart';
import 'package:fundorex/view/auth/login/login.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../view/home/homepage.dart';

class PhoneVerifyService with ChangeNotifier {
  bool isloading = false;
  bool verifyOtpLoading = false;
  String? storedOtp;
  String? registerToken;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  setVerifyOtpLoadingTrue() {
    verifyOtpLoading = true;
    notifyListeners();
  }

  setVerifyOtpLoadingFalse() {
    verifyOtpLoading = false;
    notifyListeners();
  }

  setRegisterToken(String? token) {
    registerToken = token;
    notifyListeners();
  }

  // Send OTP for phone verification during registration
  Future<bool> sendRegisterOtp(
      String fullName,
      String phone,
      String email,
      String city,
      int countryId,
      BuildContext context,
      ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      OthersHelper().showToast(
        "Please turn on your internet connection",
        Colors.black,
      );
      return false;
    }

    setLoadingTrue();

    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    var data = jsonEncode({
      'name': fullName,
      'username': phone, // Phone number as username
      'email': email,
      'city': city,
      'country_id': countryId,
      'agree_terms': 1,
    });

    try {
      var response = await http.post(
        Uri.parse('$baseApi/send-register-otp'),
        headers: header,
        body: data,
      );

      setLoadingFalse();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var responseData = jsonDecode(response.body);

        // Store the registration token if provided
        if (responseData.containsKey('token')) {
          setRegisterToken(responseData['token']);
        }

        OthersHelper().showToast(
          responseData['message'] ?? 'OTP sent successfully',
          ConstantColors().successColor,
        );

        debugPrint('OTP sent successfully');
        notifyListeners();
        return true;
      } else {
        print('Error sending OTP: ${response.body}');
        var errorData = jsonDecode(response.body);

        // Handle validation errors
        if (errorData.containsKey('errors')) {
          _showError(errorData['errors']);
        } else {
          OthersHelper().showToast(
            errorData['message'] ?? 'Failed to send OTP',
            Colors.black,
          );
        }
        return false;
      }
    } catch (e) {
      setLoadingFalse();
      debugPrint('Network error: ${e.toString()}');
      OthersHelper().showToast(
        'Network error: ${e.toString()}',
        Colors.black,
      );
      return false;
    }
  }

  // Verify OTP and complete registration
  Future<bool> verifyRegisterOtp(
      String otpCode,
      BuildContext context,
      ) async {
    if (otpCode.length != 4 || !RegExp(r'^\d{4}$').hasMatch(otpCode)) {
      OthersHelper().showToast(
        'Please enter a valid 4-digit OTP code',
        Colors.black,
      );
      return false;
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      OthersHelper().showToast(
        "Please turn on your internet connection",
        Colors.black,
      );
      return false;
    }

    setVerifyOtpLoadingTrue();

    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    if (registerToken != null) {
      header['X-Register-Token'] = registerToken!;
    }

    var data = jsonEncode({'otp_code': otpCode});

    try {
      var response = await http.post(
        Uri.parse('$baseApi/verify-register-otp'),
        headers: header,
        body: data,
      );

      setVerifyOtpLoadingFalse();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var responseData = jsonDecode(response.body);

        OthersHelper().showToast(
          responseData['message'] ?? 'Registration successful',
          ConstantColors().successColor,
        );

        // ✅ تخزين المستخدم والتوكن إن وجدت
        if (responseData.containsKey('user') && responseData.containsKey('token')) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_token', responseData['token']);
          await prefs.setString('user_data', jsonEncode(responseData['user']));
        }

        clearData();

        // ✅ توجيه المستخدم للواجهة الرئيسية
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your home page
              (route) => false,
        );

        return true;
      } else {
        var errorData = jsonDecode(response.body);
        OthersHelper().showToast(
          errorData['message'] ?? 'OTP verification failed',
          Colors.black,
        );
        return false;
      }
    } catch (e) {
      setVerifyOtpLoadingFalse();
      debugPrint('Network error during OTP verification: ${e.toString()}');
      OthersHelper().showToast(
        'Network error: ${e.toString()}',
        Colors.black,
      );
      return false;
    }
  }


  // Resend OTP (can be used for both registration and login)
  Future<bool> resendOtp(
      String phone,
      BuildContext context,
      ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      OthersHelper().showToast(
        "Please turn on your internet connection",
        Colors.black,
      );
      return false;
    }

    setLoadingTrue();

    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    var data = jsonEncode({
      'phone': phone,
    });

    try {
      var response = await http.post(
        Uri.parse('$baseApi/resend-otp'),
        headers: header,
        body: data,
      );

      setLoadingFalse();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var responseData = jsonDecode(response.body);

        OthersHelper().showToast(
          responseData['message'] ?? 'OTP resent successfully',
          ConstantColors().successColor,
        );

        debugPrint('OTP resent successfully');
        return true;
      } else {
        var errorData = jsonDecode(response.body);

        OthersHelper().showToast(
          errorData['message'] ?? 'Failed to resend OTP',
          Colors.black,
        );

        debugPrint('Failed to resend OTP: ${response.body}');
        return false;
      }
    } catch (e) {
      setLoadingFalse();
      debugPrint('Network error during OTP resend: ${e.toString()}');
      OthersHelper().showToast(
        'Network error: ${e.toString()}',
        Colors.black,
      );
      return false;
    }
  }

  // Send OTP for login
  Future<bool> sendLoginOtp(
      String phone,
      BuildContext context,
      ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      OthersHelper().showToast(
        "Please turn on your internet connection",
        Colors.black,
      );
      return false;
    }

    setLoadingTrue();

    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    var data = jsonEncode({
      'phone': phone,
    });

    try {
      var response = await http.post(
        Uri.parse('$baseApi/send-login-otp'),
        headers: header,
        body: data,
      );

      setLoadingFalse();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var responseData = jsonDecode(response.body);

        OthersHelper().showToast(
          responseData['message'] ?? 'OTP sent successfully',
          ConstantColors().successColor,
        );

        debugPrint('Login OTP sent successfully');
        return true;
      } else {
        var errorData = jsonDecode(response.body);

        OthersHelper().showToast(
          errorData['message'] ?? 'Failed to send OTP',
          Colors.black,
        );

        debugPrint('Failed to send login OTP: ${response.body}');
        return false;
      }
    } catch (e) {
      setLoadingFalse();
      debugPrint('Network error during login OTP send: ${e.toString()}');
      OthersHelper().showToast(
        'Network error: ${e.toString()}',
        Colors.black,
      );
      return false;
    }
  }

  // Verify phone number for login
  Future<bool> verifyLoginOtp(
      String phone,
      String otpCode,
      BuildContext context,
      ) async {
    // Validate OTP code format (4 digits)
    if (otpCode.length != 4 || !RegExp(r'^\d{4}$').hasMatch(otpCode)) {
      OthersHelper().showToast(
        'Please enter a valid 4-digit OTP code',
        Colors.black,
      );
      return false;
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      OthersHelper().showToast(
        "Please turn on your internet connection",
        Colors.black,
      );
      return false;
    }

    setVerifyOtpLoadingTrue();

    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    var data = jsonEncode({
      'phone': phone,
      'otp_code': otpCode,
    });

    try {
      var response = await http.post(
        Uri.parse('$baseApi/verify-login-otp'),
        headers: header,
        body: data,
      );

      setVerifyOtpLoadingFalse();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var responseData = jsonDecode(response.body);

        // Store user data and token if provided
        if (responseData.containsKey('user') && responseData.containsKey('token')) {
          // Handle successful login - save user data and token
          // You might want to save these to shared preferences or secure storage
          debugPrint('Login successful: ${responseData['user']}');
          debugPrint('Token: ${responseData['token']}');

          // TODO: Save user data and token to secure storage
          // Example:
          // await SharedPreferences.getInstance().then((prefs) {
          //   prefs.setString('user_token', responseData['token']);
          //   prefs.setString('user_data', jsonEncode(responseData['user']));
          // });
        }

        OthersHelper().showToast(
          responseData['message'] ?? 'Login successful',
          ConstantColors().successColor,
        );

        // Navigate to home or dashboard
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your home page
              (route) => false,
        );

        return true;
      } else {
        var errorData = jsonDecode(response.body);

        OthersHelper().showToast(
          errorData['message'] ?? 'Login verification failed',
          Colors.black,
        );

        debugPrint('Login verification failed: ${response.body}');
        return false;
      }
    } catch (e) {
      setVerifyOtpLoadingFalse();
      debugPrint('Network error during login verification: ${e.toString()}');
      OthersHelper().showToast(
        'Network error: ${e.toString()}',
        Colors.black,
      );
      return false;
    }
  }

  // Helper method to show validation errors
  void _showError(Map<String, dynamic> errors) {
    if (errors.containsKey('email')) {
      OthersHelper().showToast(errors['email'][0], Colors.black);
    } else if (errors.containsKey('username')) {
      OthersHelper().showToast(errors['username'][0], Colors.black);
    } else if (errors.containsKey('phone')) {
      OthersHelper().showToast(errors['phone'][0], Colors.black);
    } else if (errors.containsKey('name')) {
      OthersHelper().showToast(errors['name'][0], Colors.black);
    } else if (errors.containsKey('otp_code')) {
      OthersHelper().showToast(errors['otp_code'][0], Colors.black);
    } else {
      OthersHelper().showToast('Validation error occurred', Colors.black);
    }
  }

  // Clear all stored data
  void clearData() {
    storedOtp = null;
    registerToken = null;
    isloading = false;
    verifyOtpLoading = false;
    notifyListeners();
  }
}