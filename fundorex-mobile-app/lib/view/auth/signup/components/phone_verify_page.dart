import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/auth_services/signup_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class PhoneVerifyPage extends StatefulWidget {
  const PhoneVerifyPage({
    super.key,
    required this.phone,
    required this.fullName,
    required this.email,
    required this.city,
    required this.countryId,
    this.registerToken,
  });

  final String phone;
  final String fullName;
  final String email;
  final String city;
  final int countryId;
  final String? registerToken;

  @override
  _PhoneVerifyPageState createState() => _PhoneVerifyPageState();
}

class _PhoneVerifyPageState extends State<PhoneVerifyPage> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  int resendTime = 60;
  bool canResend = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    startResendTimer();
  }

  void startResendTimer() {
    setState(() {
      canResend = false;
      resendTime = 60;
    });

    timer?.cancel(); // Cancel any existing timer
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (resendTime > 0) {
            resendTime--;
          } else {
            canResend = true;
            timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    errorController?.close();
    textEditingController.dispose();
    super.dispose();
  }

  String formatPhoneDisplay(String phone) {
    // Format phone for display: +966 5XXXXXXXX
    if (phone.length == 9) {
      return '+966 $phone';
    }
    return phone;
  }

  // Handle OTP verification
  // Handle OTP verification
  Future<void> _verifyOtp(String otp, SignupService provider) async {
    if (otp.length != 4) {
      OthersHelper().showToast('يرجى إدخال رمز مكون من 4 أرقام', Colors.black);
      return;
    }

    try {
      bool success = await provider.verifyRegisterOtp(otp, context);
      if (success) {
        // Clear any error state on success
        if (mounted && errorController != null) {
          errorController!.add(ErrorAnimationType.clear);
        }
        // Don't clear the text field or trigger error animation on success
      } else {
        // Only clear and show error if verification actually failed
        if (mounted) {
          textEditingController.clear();
          errorController?.add(ErrorAnimationType.shake);
        }
      }
    } catch (e) {
      if (mounted) {
        OthersHelper().showToast('حدث خطأ أثناء التحقق', Colors.black);
        textEditingController.clear();
        errorController?.add(ErrorAnimationType.shake);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        appBar: CommonHelper().appbarCommon('تحقق من رقم الجوال', context, () {
          Navigator.pop(context);
        }),
        body: Consumer<SignupService>(
          builder: (context, provider, child) => Consumer<AppStringService>(
            builder: (context, ln, child) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80.0,
                    width: 80.0,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/phone-circle.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  CommonHelper().titleCommon("أدخل رمز التحقق"),

                  const SizedBox(height: 13),

                  CommonHelper().paragraphCommon(
                    'أدخل رمز التحقق المكون من 4 أرقام المرسل إلى رقم الجوال ${formatPhoneDisplay(widget.phone)}',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 33),

                  Form(
                    child: PinCodeTextField(
                      appContext: context,
                      length: 4, // 4 digits for SMS OTP
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      showCursor: true,
                      cursorColor: cc.greyFive,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 45,
                        activeFillColor: Colors.white,
                        borderWidth: 1.5,
                        selectedColor: cc.primaryColor,
                        activeColor: cc.primaryColor,
                        inactiveColor: cc.greyFive,
                        errorBorderColor: Colors.red,
                      ),
                      animationDuration: const Duration(milliseconds: 200),
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      onCompleted: (otp) async {
                        // Auto-verify when OTP is complete
                        if (!provider.isloading) {
                          await _verifyOtp(otp, provider);
                        }
                      },
                      onChanged: (value) {
                        // Clear any previous errors
                        if (errorController != null) {
                          errorController!.add(ErrorAnimationType.clear);
                        }
                      },
                      beforeTextPaste: (text) {
                        // Allow pasting of numeric text
                        return RegExp(r'^\d{4}$').hasMatch(text ?? '');
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Manual verify button (in case auto-verification fails)
                  if (textEditingController.text.length == 4 && !provider.isloading)
                    CommonHelper().buttonPrimary(
                      "تحقق من الرمز",
                          () async {
                        await _verifyOtp(textEditingController.text, provider);
                      },
                      isloading: false,
                    ),

                  // Loading indicator
                  if (provider.isloading)
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 5),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          OthersHelper().showLoading(cc.primaryColor),
                          const SizedBox(height: 10),
                          const Text(
                            'جاري التحقق...',
                            style: TextStyle(
                              color: Color(0xff646464),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 13),

                  // Resend OTP section
                  if (!provider.isloading) // Only show when not loading
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!canResend)
                          Text(
                            'يمكنك إعادة الإرسال خلال ${resendTime}s',
                            style: const TextStyle(
                              color: Color(0xff646464),
                              fontSize: 14,
                            ),
                          )
                        else
                          provider.isOtpSending
                              ? OthersHelper().showLoading(cc.primaryColor)
                              : RichText(
                            text: TextSpan(
                              text: 'لم تستلم الرمز؟ ',
                              style: const TextStyle(
                                color: Color(0xff646464),
                                fontSize: 14,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      if (!provider.isOtpSending) {
                                        // Resend OTP
                                        bool success = await provider.sendRegisterOtp(
                                          widget.fullName,
                                          widget.phone,
                                          widget.email,
                                          widget.city,
                                          context,
                                        );
                                        if (success) {
                                          startResendTimer();
                                          textEditingController.clear();
                                        }
                                      }
                                    },
                                  text: 'إعادة إرسال',
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

                  const SizedBox(height: 20),

                  // Help text
                  Text(
                    'تأكد من أن رقم الجوال ${formatPhoneDisplay(widget.phone)} صحيح',
                    style: const TextStyle(
                      color: Color(0xff646464),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
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