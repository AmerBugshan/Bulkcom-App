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
  });

  final fullNameController;
  final userNameController;
  final emailController;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Name ============>
          CommonHelper().labelCommon("Full name"),

          CustomInput(
            controller: fullNameController,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return ln.getString('Please enter your full name');
              }
              return null;
            },
            hintText: ln.getString("Enter your full name"),
            icon: 'assets/icons/user.png',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 8,
          ),

          //User name ============>
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
          const SizedBox(
            height: 8,
          ),

          //Email ============>
          CommonHelper().labelCommon("Email"),

          CustomInput(
            controller: emailController,
            validation: (value) {
              if (!value!.validateEmail) {
                return ln.getString('Please enter your email');
              }
              return null;
            },
            hintText: ln.getString("Enter your email"),
            icon: 'assets/icons/email-grey.png',
            textInputAction: TextInputAction.next,
          ),
        ],
      ),
    );
  }
}
