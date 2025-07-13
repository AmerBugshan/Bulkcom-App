import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/string_extension.dart';
import 'package:fundorex/view/auth/login/login.dart';
import 'package:fundorex/view/home/homepage.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view/auth/signup/components/phone_verify_page.dart';
import '../common_service.dart';
import '../country_states_service.dart';

class SignupService with ChangeNotifier {
  bool isloading = false;
  bool isOtpSending = false;

  String phoneNumber = '0';
  String countryCode = 'SA';
  String? registerToken; // Store the registration token

  setPhone(value) {
    phoneNumber = value;
    notifyListeners();
  }

  setCountryCode(code) {
    countryCode = code;
    notifyListeners();
  }

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  setOtpSendingTrue() {
    isOtpSending = true;
    notifyListeners();
  }

  setOtpSendingFalse() {
    isOtpSending = false;
    notifyListeners();
  }

  // Send OTP for registration
  Future<bool> sendRegisterOtp(
      String fullName,
      String userName,
      String email,
      String city,
      BuildContext context,
      ) async {
    var connection = await checkConnection();

    var selectedCountryId =
        Provider.of<CountryStatesService>(context, listen: false)
            .selectedCountryId;

    if (connection) {
      setOtpSendingTrue();

      var data = jsonEncode({
        'name': fullName,
        'username': userName, // This should be the phone number
        'email': email,
        'city': city,
        'country_id': selectedCountryId,
        'agree_terms': 1, // Assuming terms are agreed
      });

      var header = {
        "Accept": "application/json",
        "Content-Type": "application/json"
      };

      try {
        var response = await http.post(
          Uri.parse('$baseApi/send-register-otp'),
          body: data,
          headers: header,
        );

        setOtpSendingFalse();

        if (response.statusCode >= 200 && response.statusCode < 300) {
          var responseData = jsonDecode(response.body);

          // Store the registration token if provided
          if (responseData.containsKey('token')) {
            registerToken = responseData['token'];
          }

          OthersHelper().showToast(
            responseData['message'] ?? "OTP sent successfully",
            ConstantColors().successColor,
          );

          // Navigate to OTP verification page
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => PhoneVerifyPage(
                phone: userName,
                fullName: fullName,
                email: email,
                city: city,
                countryId: selectedCountryId,
                registerToken: registerToken,
              ),
            ),
          );

          return true;
        } else {
          // Handle errors
          var errorData = jsonDecode(response.body);

          if (errorData.containsKey('errors')) {
            showError(errorData['errors']);
          } else {
            OthersHelper().showToast(
              errorData['message'] ?? 'Failed to send OTP',
              Colors.black,
            );
          }
          return false;
        }
      } catch (e) {
        setOtpSendingFalse();
        OthersHelper().showToast(
          'Network error: ${e.toString()}',
          Colors.black,
        );
        return false;
      }
    } else {
      // No internet connection
      OthersHelper().showToast(
        "Please check your internet connection",
        Colors.black,
      );
      return false;
    }
  }

  // Verify OTP and complete registration
  // Verify OTP and complete registration
  Future<bool> verifyRegisterOtp(
      String otpCode,
      BuildContext context,
      ) async {
    var connection = await checkConnection();

    if (connection) {
      setLoadingTrue();

      var data = jsonEncode({
        'otp_code': otpCode,
      });

      var header = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      // Add registration token to header if available
      if (registerToken != null) {
        header['X-Register-Token'] = registerToken!;
      }

      try {
        var response = await http.post(
          Uri.parse('$baseApi/verify-register-otp'),
          body: data,
          headers: header,
        );

        setLoadingFalse();

        if (response.statusCode >= 200 && response.statusCode < 300) {
          var responseData = jsonDecode(response.body);

          // Save user data and token if provided
          await _saveUserData(responseData);

          OthersHelper().showToast(
            responseData['message'] ?? "Registration successful",
            ConstantColors().successColor,
          );

          // Clear the registration token
          registerToken = null;

          // Wait a moment to let the user see the success message
          await Future.delayed(Duration(milliseconds: 500));

          // Navigate to your main page - choose one of these options:

          // Option 1: Navigate to a specific page directly
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your home page
                (route) => false,
          );

          // Option 2: Use named route (make sure the route exists in your app)
          // Navigator.pushNamedAndRemoveUntil(
          //   context,
          //   '/dashboard', // Use your actual route name
          //   (route) => false,
          // );

          // Option 3: Pop back to previous screens
          // Navigator.popUntil(context, (route) => route.isFirst);

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
        setLoadingFalse();
        OthersHelper().showToast(
          'Network error: ${e.toString()}',
          Colors.black,
        );
        return false;
      }
    } else {
      OthersHelper().showToast(
        "Please check your internet connection",
        Colors.black,
      );
      return false;
    }
  }

  // Helper method to save user data and token
  Future<void> _saveUserData(Map<String, dynamic> responseData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Save auth token if available
      if (responseData.containsKey('token')) {
        await prefs.setString('auth_token', responseData['token']);
      }

      // Save user data if available
      if (responseData.containsKey('user')) {
        await prefs.setString('user_data', jsonEncode(responseData['user']));
        await prefs.setBool('is_logged_in', true);
      }

      debugPrint('User data saved successfully');
    } catch (e) {
      debugPrint('Error saving user data: $e');
    }
  }

  // Legacy signup method - keeping for backward compatibility
  Future signup(
      String fullName,
      String userName,
      String email,
      String password,
      String city,
      BuildContext context,
      ) async {
    // Redirect to OTP-based registration
    return await sendRegisterOtp(fullName, userName, email, city, context);
  }

  // Clear all stored data
  void clearData() {
    registerToken = null;
    isloading = false;
    isOtpSending = false;
    notifyListeners();
  }
}

showError(error) {
  if (error.containsKey('email')) {
    OthersHelper().showToast(error['email'][0], Colors.black);
  } else if (error.containsKey('username')) {
    OthersHelper().showToast(error['username'][0], Colors.black);
  } else if (error.containsKey('phone')) {
    OthersHelper().showToast(error['phone'][0], Colors.black);
  } else if (error.containsKey('password')) {
    OthersHelper().showToast(error['password'][0], Colors.black);
  } else if (error.containsKey('name')) {
    OthersHelper().showToast(error['name'][0], Colors.black);
  } else if (error.containsKey('message')) {
    OthersHelper().showToast(error['message'], Colors.black);
  } else {
    OthersHelper().showToast('Something went wrong', Colors.black);
  }
}