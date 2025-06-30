import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/context_extension.dart';
import 'package:fundorex/view/utils/common_helper.dart';

import '../../helper/extension/string_extension.dart';
import '../auth/login/login.dart';
import '../utils/custom_button.dart';

class LoginOrRegister extends StatelessWidget {
  const LoginOrRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/avatar.png',
              height: context.height / 6,
              // width: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CommonHelper().titleCommon(
                  "You'll have to login/register to edit or see your profile info.",
                  fontsize: 16,
                  textAlign: TextAlign.center)),
          const SizedBox(height: 20),
          CustomButton(
              btText: 'Login/Register'.tr(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const LoginPage(shouldPop: true),
                  ),
                );
              },
              isLoading: false,
              width: context.width / 2)
        ],
      ),
    );
  }
}
