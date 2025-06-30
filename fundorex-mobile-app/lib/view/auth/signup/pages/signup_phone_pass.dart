// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/int_extension.dart';
import 'package:fundorex/helper/extension/string_extension.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/auth_services/signup_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class SignupPhonePass extends StatefulWidget {
  const SignupPhonePass(
      {super.key,
      required this.passController,
      required this.phoneController,
      required this.confirmPassController});

  final passController;
  final confirmPassController;
  final phoneController;

  @override
  _SignupPhonePassState createState() => _SignupPhonePassState();
}

class _SignupPhonePassState extends State<SignupPhonePass> {
  late bool _newpasswordVisible;
  late bool _confirmNewPassswordVisible;

  @override
  void initState() {
    super.initState();
    _newpasswordVisible = false;
    _confirmNewPassswordVisible = false;
  }

  final _formKey = GlobalKey<FormState>();

  bool keepLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupService>(
      builder: (context, provider, child) => Consumer<AppStringService>(
        builder: (context, ln, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phone number field
            // CommonHelper().labelCommon("Phone"),
            // Consumer<RtlService>(
            //   builder: (context, rtlP, child) => IntlPhoneField(
            //     controller: widget.phoneController,
            //     decoration: SignupHelper().phoneFieldDecoration(),
            //     initialCountryCode: provider.countryCode,
            //     textAlign:
            //         rtlP.direction == 'ltr' ? TextAlign.left : TextAlign.right,
            //     onChanged: (phone) {
            //       provider.setCountryCode(phone.countryISOCode);

            //       provider.setPhone(phone.number);
            //     },
            //   ),
            // ),

            // const SizedBox(
            //   height: 8,
            // ),

            //New password =========================>
            CommonHelper().labelCommon("Password"),

            TextFormField(
              controller: widget.passController,
              textInputAction: TextInputAction.next,
              obscureText: !_newpasswordVisible,
              style: const TextStyle(fontSize: 14),
              validator: (value) {
                debugPrint(" valid ".toString());
                debugPrint(value.toString());
                return value.toString().validPass;
              },
              decoration: InputDecoration(
                  fillColor: ConstantColors().greySecondary,
                  filled: true,
                  prefixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 22.0,
                        width: 40.0,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/icons/lock.png'),
                              fit: BoxFit.fitHeight),
                        ),
                      ),
                    ],
                  ),
                  suffixIcon: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _newpasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 22,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _newpasswordVisible = !_newpasswordVisible;
                      });
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(9)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ConstantColors().primaryColor)),
                  errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ConstantColors().warningColor)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ConstantColors().primaryColor)),
                  hintText: ln.getString('Enter password'),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 18)),
            ),
            19.toHeight,
            const SizedBox(
              height: 10,
            ),
            //Confirm New password =========================>
            CommonHelper().labelCommon("Confirm Password"),

            Container(
                margin: const EdgeInsets.only(bottom: 19),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                  controller: widget.confirmPassController,
                  textInputAction: TextInputAction.next,
                  obscureText: !_confirmNewPassswordVisible,
                  style: const TextStyle(fontSize: 14),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ln.getString('Please retype your password');
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: ConstantColors().greySecondary,
                      filled: true,
                      prefixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 22.0,
                            width: 40.0,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/icons/lock.png'),
                                  fit: BoxFit.fitHeight),
                            ),
                          ),
                        ],
                      ),
                      suffixIcon: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _confirmNewPassswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                          size: 22,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _confirmNewPassswordVisible =
                                !_confirmNewPassswordVisible;
                          });
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(9)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ConstantColors().primaryColor)),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ConstantColors().warningColor)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ConstantColors().primaryColor)),
                      hintText: ln.getString('Retype password'),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 18)),
                )),
          ],
        ),
      ),
    );
  }
}
