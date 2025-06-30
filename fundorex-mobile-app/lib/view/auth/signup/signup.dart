import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/string_extension.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/auth_services/signup_service.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/view/auth/signup/components/country_states_dropdowns.dart';
import 'package:fundorex/view/auth/signup/pages/signup_phone_pass.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:fundorex/view/utils/tac_pp.dart';
import 'package:provider/provider.dart';

import '../login/login.dart';
import 'components/email_name_fields.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, this.hasBackButton = true});

  final hasBackButton;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  ValueNotifier<bool> termsAgree = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  bool keepLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    // Provider.of<SignupService>(context, listen: false).setLoadingFalse();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('Register to join us', context, () {
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
          child: Listener(
            onPointerDown: (_) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.focusedChild?.unfocus();
              }
            },
            child: Consumer<SignupService>(
              builder: (context, provider, child) => Consumer<AppStringService>(
                builder: (context, ln, child) => Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(
                            //   height: 33,
                            // ),
                            // CommonHelper().titleCommon("Register to join us"),
                            const SizedBox(
                              height: 19,
                            ),
                            EmailNameFields(
                              fullNameController: fullNameController,
                              userNameController: userNameController,
                              emailController: emailController,
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            //Country dropdown =====>
                            CountryStatesDropdowns(
                              cityController: cityController,
                            ),

                            SignupPhonePass(
                              passController: passwordController,
                              confirmPassController: confirmPasswordController,
                              phoneController: phoneController,
                            ),

                            //Agreement checkbox ===========>

                            // CheckboxListTile(
                            //   checkColor: Colors.white,
                            //   activeColor: ConstantColors().primaryColor,
                            //   contentPadding: const EdgeInsets.all(0),
                            //   title: Container(
                            //     padding:
                            //         const EdgeInsets.symmetric(vertical: 5),
                            //     child: Text(
                            //       ln.getString(
                            //           "I agree with the terms and conditons"),
                            //       style: TextStyle(
                            //           color: ConstantColors().greyFour,
                            //           fontWeight: FontWeight.w400,
                            //           fontSize: 14),
                            //     ),
                            //   ),
                            //   value: termsAgree,
                            //   onChanged: (newValue) {
                            //     setState(() {
                            //       termsAgree = !termsAgree;
                            //     });
                            //   },
                            //   controlAffinity: ListTileControlAffinity.leading,
                            // ),
                            Consumer<DonateService>(
                                builder: (context, ds, child) {
                              return TacPp(
                                valueListenable: termsAgree,
                                tTitle: "Terms & Condition".tr(),
                                tData: ds.sTC,
                                pTitle: "Privacy policy",
                                pData: ds.sPP,
                              );
                            }),
                            // sign up button
                            const SizedBox(
                              height: 10,
                            ),
                            CommonHelper().buttonPrimary("Sign Up", () {
                              debugPrint(passwordController.text.toString());
                              if (_formKey.currentState!.validate()) {
                                if (termsAgree.value == false) {
                                  OthersHelper().showToast(
                                      ln.getString(
                                          'You must agree with the terms and conditions to register'),
                                      Colors.black);
                                } else if (passwordController.text.validPass !=
                                    null) {
                                  passwordController.text.validPass
                                      ?.showToast();
                                  return;
                                } else if (passwordController.text !=
                                    confirmPasswordController.text) {
                                  OthersHelper().showToast(
                                      ln.getString('Password did not match'),
                                      Colors.black);
                                } else if (passwordController.text.length < 6) {
                                  OthersHelper().showToast(
                                      ln.getString(
                                          'Password must be at least 6 characters'),
                                      Colors.black);
                                } else {
                                  if (provider.isloading == false) {
                                    provider.signup(
                                        fullNameController.text.trim(),
                                        userNameController.text.trim(),
                                        emailController.text.trim(),
                                        passwordController.text,
                                        cityController.text.trim(),
                                        context);
                                  }
                                }
                              }
                            },
                                isloading:
                                    provider.isloading == false ? false : true),

                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: ln.getString(
                                            'Already have an account?') +
                                        '  ',
                                    style: const TextStyle(
                                        color: Color(0xff646464), fontSize: 14),
                                    children: <TextSpan>[
                                      TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginPage()));
                                            },
                                          text: ln.getString('Sign In'),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: cc.primaryColor,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    )
                    // }
                    // }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
