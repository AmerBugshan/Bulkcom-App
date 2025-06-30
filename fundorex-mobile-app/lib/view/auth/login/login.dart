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
import '../reset_password/reset_pass_email_page.dart';
import '../signup/signup.dart';

class LoginPage extends StatefulWidget {
  final bool shouldPop;
  const LoginPage({super.key, this.shouldPop = false});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    // emailController.text = "ahsan@gmial.com";
    // passwordController.text = "12345678";
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool keepLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon("", context, () {
        context.popFalse;
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
                        const SizedBox(
                          height: 60,
                        ),
                        CommonHelper()
                            .titleCommon(ln.getString("Welcome back! Login")),

                        const SizedBox(
                          height: 33,
                        ),

                        //Name ============>
                        CommonHelper().labelCommon(ln.getString("Email")),

                        CustomInput(
                          controller: emailController,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return ln.getString('Please enter your email');
                            }
                            return null;
                          },
                          hintText: ln.getString("Email"),
                          icon: 'assets/icons/user.png',
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 8,
                        ),

                        //password ===========>
                        CommonHelper().labelCommon(ln.getString("Password")),

                        Container(
                            margin: const EdgeInsets.only(bottom: 19),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                              controller: passwordController,
                              textInputAction: TextInputAction.next,
                              obscureText: !_passwordVisible,
                              style: const TextStyle(fontSize: 14),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ln
                                      .getString('Please enter your password');
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  fillColor: ConstantColors().greySecondary,
                                  filled: true,
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 22.0,
                                        width: 40.0,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/icons/lock.png'),
                                              fit: BoxFit.fitHeight),
                                        ),
                                      ),
                                    ],
                                  ),
                                  suffixIcon: IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              ConstantColors().primaryColor)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              ConstantColors().warningColor)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              ConstantColors().primaryColor)),
                                  hintText: ln.getString('Enter password'),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 18)),
                            )),

                        // =================>
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //keep logged in checkbox
                            Expanded(
                              child: CheckboxListTile(
                                checkColor: Colors.white,
                                activeColor: ConstantColors().primaryColor,
                                contentPadding: const EdgeInsets.all(0),
                                title: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    ln.getString("Remember me"),
                                    style: TextStyle(
                                        color: ConstantColors().greyFour,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                ),
                                value: keepLoggedIn,
                                onChanged: (newValue) {
                                  setState(() {
                                    keepLoggedIn = !keepLoggedIn;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const ResetPassEmailPage(),
                                  ),
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 122,
                                height: 40,
                                child: Text(
                                  ln.getString("Forgot Password?"),
                                  style: TextStyle(
                                      color: cc.primaryColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),

                        //Login button ==================>
                        const SizedBox(
                          height: 13,
                        ),

                        Consumer<LoginService>(
                          builder: (context, provider, child) => CommonHelper()
                              .buttonPrimary(ln.getString("Sign In"), () {
                            if (provider.isloading == false) {
                              if (_formKey.currentState!.validate()) {
                                provider
                                    .login(
                                        emailController.text.trim(),
                                        passwordController.text,
                                        context,
                                        keepLoggedIn)
                                    .then((value) {
                                  if (value == true) {
                                    context.popTrue;
                                  }
                                });
                              }
                              // Navigator.pushReplacement<void, void>(
                              //   context,
                              //   MaterialPageRoute<void>(
                              //     builder: (BuildContext context) =>
                              //         const LandingPage(),
                              //   ),
                              // );
                            }
                          },
                                  isloading: provider.isloading == false
                                      ? false
                                      : true),
                        ),

                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                text:
                                    ln.getString("Do not have account?") + ' ',
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
                                                      const SignupPage()));
                                        },
                                      text: ln.getString('Sign Up'),
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

                        // Divider (or)
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                              height: 1,
                              color: cc.greyFive,
                            )),
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(bottom: 25),
                              child: Text(
                                ln.getString("OR"),
                                style: TextStyle(
                                    color: cc.greyPrimary,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              height: 1,
                              color: cc.greyFive,
                            )),
                          ],
                        ),

                        // login with google, facebook button ===========>
                        const SizedBox(
                          height: 20,
                        ),
                        Consumer<GoogleSignInService>(
                          builder: (context, gProvider, child) => InkWell(
                              onTap: () {
                                if (gProvider.isloading == false) {
                                  gProvider.googleLogin(context);
                                }
                              },
                              child: LoginHelper().commonButton(
                                  'assets/icons/google.png',
                                  ln.getString("Sign in with Google"),
                                  isloading: gProvider.isloading == false
                                      ? false
                                      : true)),
                        ),
                        if (Platform.isIOS) ...[
                          const SizedBox(height: 20),
                          Consumer<AppleSignInService>(
                            builder: (context, gProvider, child) => InkWell(
                                onTap: () async {
                                  if (gProvider.isloading == false) {
                                    gProvider.setLoadingTrue();
                                    await gProvider
                                        .appleLogin(context, autoLogin: true)
                                        .then((value) async {
                                      if (value == true) {
                                        // Navigator.of(context).pop();
                                        await Provider.of<ProfileService>(
                                                context,
                                                listen: false)
                                            .fetchData();
                                        context.popTrue;
                                      }
                                    }).onError((error, stackTrace) =>
                                            gProvider.setLoadingFalse());
                                    gProvider.setLoadingFalse();
                                  }
                                },
                                child: LoginHelper().commonButton(
                                    'assets/icons/apple.png',
                                    ln.getString("Sign in with Apple"),
                                    isloading: gProvider.isloading == false
                                        ? false
                                        : true)),
                          )
                        ],
                        const SizedBox(height: 20),
                        Consumer<FacebookLoginService>(
                          builder: (context, fProvider, child) => InkWell(
                            onTap: () {
                              if (fProvider.isloading == false) {
                                fProvider.checkIfLoggedIn(context);
                              }
                            },
                            child: LoginHelper().commonButton(
                                'assets/icons/facebook.png',
                                ln.getString("Sign in with Facebook"),
                                isloading: fProvider.isloading == false
                                    ? false
                                    : true),
                          ),
                        ),

                        const SizedBox(
                          height: 60,
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
    );
  }
}
