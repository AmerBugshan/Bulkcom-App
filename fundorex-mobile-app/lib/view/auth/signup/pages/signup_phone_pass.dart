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
            // Phone Number Field
            CommonHelper().labelCommon("رقم الجوال"),
            TextFormField(
              controller: widget.phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: ln.getString('ادخل رقم الجوال'),
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(color: ConstantColors().primaryColor)),
                filled: true,
                fillColor: ConstantColors().greySecondary,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
              ),
              validator: (value) =>
              value == null || value.isEmpty ? 'ادخل رقم الجوال' : null,
            ),

            const SizedBox(height: 10),

            // Password & Confirm Password (Hidden via if false)
            if (false) ...[
              CommonHelper().labelCommon("Password"),
              TextFormField(
                controller: widget.passController,
                obscureText: !_newpasswordVisible,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              19.toHeight,
              const SizedBox(height: 10),
              CommonHelper().labelCommon("Confirm Password"),
              TextFormField(
                controller: widget.confirmPassController,
                obscureText: !_confirmNewPassswordVisible,
                decoration: const InputDecoration(
                  hintText: 'Confirm Password',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
