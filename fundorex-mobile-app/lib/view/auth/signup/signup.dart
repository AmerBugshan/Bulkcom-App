import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/string_extension.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/auth_services/signup_service.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/view/auth/signup/components/country_states_dropdowns.dart';
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
  TextEditingController cityController = TextEditingController();

  // Helper method to format phone number
  String formatPhoneNumber(String phone) {
    // Remove all non-digit characters
    String cleaned = phone.replaceAll(RegExp(r'\D'), '');

    // If it starts with 0, remove it
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }

    // If it doesn't start with 5, it's invalid
    if (!cleaned.startsWith('5')) {
      return '';
    }

    return cleaned;
  }

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

                          // Full Name Field
                          CommonHelper().labelCommon("الاسم الكامل"),
                          TextFormField(
                            controller: fullNameController,
                            decoration: InputDecoration(
                              hintText: ln.getString('أدخل اسمك الكامل'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return ln.getString('الاسم الكامل مطلوب');
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 8),

                          // Phone Number Field (This will be the username)
                          CommonHelper().labelCommon("رقم الجوال"),
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: ln.getString('5XXXXXXXX'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.phone),
                              prefixText: '+966 ',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return ln.getString('رقم الجوال مطلوب');
                              }

                              String formatted = formatPhoneNumber(value);
                              if (formatted.isEmpty || formatted.length != 9) {
                                return ln.getString('رقم الجوال يجب أن يكون رقمًا سعوديًا صالحًا (مثال: 5XXXXXXXX)');
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 8),

                          // Email Field
                          CommonHelper().labelCommon("البريد الإلكتروني"),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: ln.getString('أدخل بريدك الإلكتروني'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return ln.getString('البريد الإلكتروني مطلوب');
                              }
                              if (!value.validateEmail) {
                                return ln.getString('البريد الإلكتروني غير صالح');
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
                          CommonHelper().buttonPrimary(
                            provider.isOtpSending ? "جاري الإرسال..." : "تسجيل حساب جديد",
                                () {
                              if (_formKey.currentState!.validate()) {
                                if (termsAgree.value == false) {
                                  OthersHelper().showToast(
                                    ln.getString('يجب الموافقة على الشروط والأحكام للتسجيل'),
                                    Colors.black,
                                  );
                                } else {
                                  if (!provider.isOtpSending && !provider.isloading) {
                                    // Format phone number for backend
                                    String formattedPhone = formatPhoneNumber(phoneController.text);

                                    provider.sendRegisterOtp(
                                      fullNameController.text.trim(),
                                      formattedPhone, // This becomes the username
                                      emailController.text.trim(),
                                      cityController.text.trim(),
                                      context,
                                    );
                                  }
                                }
                              }
                            },
                            isloading: provider.isOtpSending || provider.isloading,
                          ),

                          const SizedBox(height: 25),

                          // Already have account link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: ln.getString('لديك حساب بالفعل؟') + '  ',
                                  style: const TextStyle(
                                    color: Color(0xff646464),
                                    fontSize: 14,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const LoginPage(),
                                            ),
                                          );
                                        },
                                      text: ln.getString('سجل دخولك الأن'),
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