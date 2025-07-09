import 'package:flutter/cupertino.dart';
import 'package:fundorex/helper/extension/string_extension.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/custom_input.dart';
import 'package:provider/provider.dart';

class EmailNameFields extends StatelessWidget {
  const EmailNameFields({
    super.key,
    required this.fullNameController,
    required this.userNameController,
    required this.emailController,
    this.showEmailField = true,  // New parameter with default value true
  });

  final fullNameController;
  final userNameController;
  final emailController;
  final bool showEmailField;  // Added parameter

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name
          CommonHelper().labelCommon("اللإسم الكامل"),
          CustomInput(
            controller: fullNameController,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return ln.getString('ادخل إسمك كاملا');
              }
              return null;
            },
            hintText: ln.getString("ادخل إسمك كاملا"),
            icon: 'assets/icons/user.png',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 8),

          // Username (Hidden via if(false))
          if (false) ...[
            CommonHelper().labelCommon("Username"),
            CustomInput(
              controller: userNameController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return ln.getString('Please enter your username');
                }
                return null;
              },
              hintText: ln.getString("Enter your username"),
              icon: 'assets/icons/user.png',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 8),
          ],

          // Email (Hidden or shown based on param)
          if (showEmailField) ...[
            CommonHelper().labelCommon("البريد الإلكتروني"),
            CustomInput(
              controller: emailController,
              validation: (value) {
                if (!value!.validateEmail) {
                  return ln.getString('ادخل بريدك الإلكتروني');
                }
                return null;
              },
              hintText: ln.getString("ادخل بريدك الإلكتروني"),
              icon: 'assets/icons/email-grey.png',
              textInputAction: TextInputAction.next,
            ),
          ],
        ],
      ),
    );
  }
}
