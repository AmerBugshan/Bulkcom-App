import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/string_extension.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../view/auth/signup/components/email_verify_page.dart';
import '../common_service.dart';
import '../country_states_service.dart';
import 'email_verify_service.dart';

class SignupService with ChangeNotifier {
  bool isloading = false;

  String phoneNumber = '0';
  String countryCode = 'IN';

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

  Future signup(
    String fullName,
    String userName,
    String email,
    String password,
    String city,
    BuildContext context,
  ) async {
    var connection = await checkConnection();

    var selectedCountryId =
        Provider.of<CountryStatesService>(context, listen: false)
            .selectedCountryId;
    // var selectedStateId =
    //     Provider.of<CountryStatesService>(context, listen: false)
    //         .selectedStateId;
    // var selectedAreaId =
    //     Provider.of<CountryStatesService>(context, listen: false)
    //         .selectedAreaId;
    if (connection) {
      setLoadingTrue();
      var data = jsonEncode({
        'full_name': fullName,
        'username': userName,
        'email': email,
        'city': city,
        'password': password,
        'country_id': selectedCountryId,
      });
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json"
      };

      var response = await http.post(Uri.parse('$baseApi/register'),
          body: data, headers: header);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        OthersHelper().showToast(
            "Registration successful", ConstantColors().successColor);

        print('token is ${jsonDecode(response.body)['token']}');
        String token = jsonDecode(response.body)['token'];

        int userId = jsonDecode(response.body)['users']['id'];

        //Send otp
        var isOtepSent =
            await Provider.of<EmailVerifyService>(context, listen: false)
                .sendOtpForEmailValidation(email, context, token);
        setLoadingFalse();
        if (isOtepSent) {
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => EmailVerifyPage(
                email: email,
                pass: password,
                token: token,
                userId: userId,
                countryId: selectedCountryId,
              ),
            ),
          );
        } else {
          OthersHelper().showToast('Otp send failed', Colors.black);
        }

        return true;
      } else {
        //Sign up unsuccessful ==========>
        print(response.body);

        try {
          if (jsonDecode(response.body).containsKey('validation_errors')) {
            showError(jsonDecode(response.body)['validation_errors']);
          } else {
            OthersHelper()
                .showToast(jsonDecode(response.body)['message'], Colors.black);
          }
        } catch (e) {
          response.body.showToast();
        }

        setLoadingFalse();
        return false;
      }
    } else {
      //internet connection off
      return false;
    }
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
  } else if (error.containsKey('message')) {
    OthersHelper().showToast(error['password'][0], Colors.black);
  } else {
    OthersHelper().showToast('Something went wrong', Colors.black);
  }
}
