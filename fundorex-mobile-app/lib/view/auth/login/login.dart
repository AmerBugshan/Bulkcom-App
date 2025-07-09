import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/context_extension.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/auth_services/facebook_login_service.dart';
import 'package:fundorex/service/auth_services/google_sign_service.dart';
import 'package:fundorex/service/auth_services/login_service.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/view/auth/login/login_helper.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/custom_input.dart';
import 'package:provider/provider.dart';

import '../../../service/auth_services/apple_sign_in_sevice.dart';
import '../signup/signup.dart';

class LoginPage extends StatefulWidget {
  final bool shouldPop;
  const LoginPage({super.key, this.shouldPop = false});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool otpSent = false;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    final loginService = Provider.of<LoginService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon("", context, () {
        Navigator.pop(context);
      }),
      body: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: SingleChildScrollView(
          physics: physicsCommon,
          child: Consumer<AppStringService>(
            builder: (context, ln, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  alignment: Alignment.center,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        CommonHelper().titleCommon(ln.getString("مرحبًا بعودتك! الرجاء تسجيل الدخول")),
                        const SizedBox(height: 33),
                        CommonHelper().labelCommon(ln.getString("رقم الجوال (5xxxxxxxx)")),
                        CustomInput(
                          controller: phoneController,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return ln.getString('ادخل رقم الجوال');
                            }
                            return null;
                          },
                          hintText: ln.getString("5xxxxxxxx"),
                          icon: 'assets/icons/phone.png',
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                        ),
                        if (otpSent) ...[
                          const SizedBox(height: 20),
                          CommonHelper().labelCommon(ln.getString("رمز التحقق")),
                          CustomInput(
                            controller: otpController,
                            hintText: ln.getString("ادخل رمز التحقق"),
                            icon: 'assets/icons/lock.png',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                        const SizedBox(height: 20),
                        Consumer<LoginService>(
                          builder: (context, provider, child) => CommonHelper().buttonPrimary(
                            ln.getString(otpSent ? "تحقق من الرمز" : "إرسال رمز التحقق"),
                                () async {
                              if (_formKey.currentState!.validate()) {
                                final fullPhone = "+966${phoneController.text}";
                                if (!otpSent) {
                                  final sent = await provider.sendOtp(phoneController.text, context);
                                  if (sent) setState(() => otpSent = true);
                                } else {
                                  final success = await provider.verifyOtp(fullPhone, otpController.text, context);
                                  if (success) {
                                    context.popTrue;
                                  }
                                }
                              }
                            },
                            isloading: provider.isloading,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: ln.getString("ليس لديك حساب؟") + ' ',
                                style: const TextStyle(color: Color(0xff646464), fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const SignupPage()),
                                        );
                                      },
                                    text: ln.getString('سجل الان!'),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: cc.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: Container(height: 1, color: cc.greyFive)),
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(bottom: 25),
                              child: Text(
                                ln.getString("أو"),
                                style: TextStyle(color: cc.greyPrimary, fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Expanded(child: Container(height: 1, color: cc.greyFive)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Consumer<GoogleSignInService>(
                          builder: (context, gProvider, child) => InkWell(
                            onTap: () {
                              if (!gProvider.isloading) {
                                gProvider.googleLogin(context);
                              }
                            },
                            child: LoginHelper().commonButton(
                              'assets/icons/google.png',
                              ln.getString("Sign in with Google"),
                              isloading: gProvider.isloading,
                            ),
                          ),
                        ),
                        if (Platform.isIOS) ...[
                          const SizedBox(height: 20),
                          Consumer<AppleSignInService>(
                            builder: (context, gProvider, child) => InkWell(
                              onTap: () async {
                                if (!gProvider.isloading) {
                                  gProvider.setLoadingTrue();
                                  await gProvider.appleLogin(context, autoLogin: true).then((value) async {
                                    if (value == true) {
                                      await Provider.of<ProfileService>(context, listen: false).fetchData();
                                      context.popTrue;
                                    }
                                  }).onError((error, stackTrace) => gProvider.setLoadingFalse());
                                  gProvider.setLoadingFalse();
                                }
                              },
                              child: LoginHelper().commonButton(
                                'assets/icons/apple.png',
                                ln.getString("Sign in with Apple"),
                                isloading: gProvider.isloading,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Consumer<FacebookLoginService>(
                          builder: (context, fProvider, child) => InkWell(
                            onTap: () {
                              if (!fProvider.isloading) {
                                fProvider.checkIfLoggedIn(context);
                              }
                            },
                            child: LoginHelper().commonButton(
                              'assets/icons/facebook.png',
                              ln.getString("Sign in with Facebook"),
                              isloading: fProvider.isloading,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
