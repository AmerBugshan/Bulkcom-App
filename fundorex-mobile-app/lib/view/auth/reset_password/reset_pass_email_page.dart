import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/auth_services/reset_password_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/custom_input.dart';
import 'package:provider/provider.dart';

class ResetPassEmailPage extends StatefulWidget {
  const ResetPassEmailPage({super.key});

  @override
  _ResetPassEmailPageState createState() => _ResetPassEmailPageState();
}

class _ResetPassEmailPageState extends State<ResetPassEmailPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  bool keepLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Reset password', context, () {
        Navigator.pop(context);
      }),
      backgroundColor: Colors.white,
      body: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Consumer<AppStringService>(
            builder: (context, ln, child) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              height: MediaQuery.of(context).size.height - 120,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 33,
                        ),
                        Text(
                          ln.getString("Reset password"),
                          style: TextStyle(
                              color: cc.greyPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        CommonHelper().paragraphCommon(
                            ln.getString(
                                "Enter the email you used to creat account and we will send instruction for reseting password"),
                            textAlign: TextAlign.start),

                        const SizedBox(
                          height: 33,
                        ),

                        //Name ============>
                        CommonHelper().labelCommon(ln.getString("Enter Email")),

                        CustomInput(
                          controller: emailController,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return ln.getString('Please enter your email');
                            }
                            return null;
                          },
                          hintText: ln.getString("Email"),
                          icon: 'assets/icons/email.png',
                          textInputAction: TextInputAction.next,
                        ),

                        //Login button ==================>
                        const SizedBox(
                          height: 13,
                        ),
                        Consumer<ResetPasswordService>(
                          builder: (context, provider, child) => CommonHelper()
                              .buttonPrimary(ln.getString("Send Instructions"),
                                  () {
                            if (provider.isloading == false) {
                              if (_formKey.currentState!.validate()) {
                                provider.sendOtp(
                                    emailController.text.trim(), context);
                              }
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute<void>(
                              //     builder: (BuildContext context) =>
                              //         ResetPassOtpPage(
                              //       email: emailController.text,
                              //     ),
                              //   ),
                              // );
                            }
                          },
                                  isloading: provider.isloading == false
                                      ? false
                                      : true),
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
