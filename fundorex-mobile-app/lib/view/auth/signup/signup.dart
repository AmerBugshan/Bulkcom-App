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

  final _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('سجل حسابك الأن', context, () {
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
                          const SizedBox(height: 19),

                          // Full Name (Keep it first)
                          EmailNameFields(
                            fullNameController: fullNameController,
                            userNameController: userNameController,
                            emailController: emailController,
                            showEmailField: false,  // We'll handle email below
                          ),

                          const SizedBox(height: 8),

                          // Phone Field (Now shown BEFORE Email)
                          SignupPhonePass(
                            passController: passwordController,
                            confirmPassController: confirmPasswordController,
                            phoneController: phoneController,
                          ),

                          const SizedBox(height: 8),

                          // Email Field (Now shown AFTER Phone)
                          CommonHelper().labelCommon("Email"),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: ln.getString('Enter your email'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (!value!.validateEmail) {
                                return ln.getString('Please enter your email');
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 8),

                          // Country & City Dropdown
                          CountryStatesDropdowns(
                            cityController: cityController,
                          ),

                          const SizedBox(height: 8),

                          // Password Fields Hidden via if(false)
                          if (false) ...[
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                              ),
                            ),
                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                              ),
                            ),
                          ],

                          // Terms & Conditions
                          Consumer<DonateService>(
                            builder: (context, ds, child) {
                              return TacPp(
                                valueListenable: termsAgree,
                                tTitle: "الشروط و الأحكام".tr(),
                                tData: ds.sTC,
                                pTitle: "سياسة الخصوصية",
                                pData: ds.sPP,
                              );
                            },
                          ),

                          const SizedBox(height: 10),

                          // Sign Up Button
                          CommonHelper().buttonPrimary("Sign Up", () {
                            if (_formKey.currentState!.validate()) {
                              if (termsAgree.value == false) {
                                OthersHelper().showToast(
                                    ln.getString(
                                        'You must agree with the terms and conditions to register'),
                                    Colors.black);
                              } else {
                                if (provider.isloading == false) {
                                  provider.signup(
                                    fullNameController.text.trim(),
                                    '', // username skipped
                                    emailController.text.trim(),
                                    '', // password skipped
                                    cityController.text.trim(),
                                    context,
                                  );
                                }
                              }
                            }
                          }, isloading: provider.isloading == false ? false : true),

                          const SizedBox(height: 25),

                          // Already have account link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: ln.getString('لديك حساب بالفعل؟') + '  ',
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
                                        text: ln.getString('سجل دخولك الأن'),
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
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
