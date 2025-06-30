import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/string_extension.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/auth_services/change_pass_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late bool _newpasswordVisible;
  late bool _repeatnewpasswordVisible;
  late bool _oldpasswordVisible;

  @override
  void initState() {
    super.initState();
    _newpasswordVisible = false;
    _repeatnewpasswordVisible = false;
    _oldpasswordVisible = false;
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController repeatNewPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();

  bool keepLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    ConstantColors cc = ConstantColors();
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Change Password', context, () {
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
          physics: physicsCommon,
          child: Consumer<AppStringService>(
            builder: (context, ln, child) => Container(
              padding:
                  EdgeInsets.symmetric(horizontal: screenPadding, vertical: 10),
              height: screenHeight - 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //New password =========================>
                        CommonHelper().labelCommon("Enter current password"),

                        Container(
                            margin: const EdgeInsets.only(bottom: 19),
                            decoration: BoxDecoration(
                                // color: const Color(0xfff2f2f2),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                              controller: currentPasswordController,
                              textInputAction: TextInputAction.next,
                              obscureText: !_oldpasswordVisible,
                              style: const TextStyle(fontSize: 14),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 6) {
                                  return ln
                                      .getString('Enter your current password');
                                }
                                return null;
                              },
                              decoration: InputDecoration(
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
                                      _oldpasswordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _oldpasswordVisible =
                                            !_oldpasswordVisible;
                                      });
                                    },
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ConstantColors().greyFive),
                                      borderRadius: BorderRadius.circular(9)),
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
                                  hintText:
                                      ln.getString('Enter current password'),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 18)),
                            )),

                        //New password =========================>
                        CommonHelper().labelCommon("Enter new password"),

                        Container(
                            margin: const EdgeInsets.only(bottom: 19),
                            decoration: BoxDecoration(
                                // color: const Color(0xfff2f2f2),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                              controller: newPasswordController,
                              textInputAction: TextInputAction.next,
                              obscureText: !_newpasswordVisible,
                              style: const TextStyle(fontSize: 14),
                              validator: (value) {
                                return value.toString().validPass;
                              },
                              decoration: InputDecoration(
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
                                      _newpasswordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _newpasswordVisible =
                                            !_newpasswordVisible;
                                      });
                                    },
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ConstantColors().greyFive),
                                      borderRadius: BorderRadius.circular(9)),
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
                                  hintText: ln.getString('New password'),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 18)),
                            )),

                        //Repeat New password =========================>
                        CommonHelper().labelCommon("Repeat new password"),

                        Container(
                            margin: const EdgeInsets.only(bottom: 19),
                            decoration: BoxDecoration(
                                // color: const Color(0xfff2f2f2),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                              controller: repeatNewPasswordController,
                              textInputAction: TextInputAction.next,
                              obscureText: !_repeatnewpasswordVisible,
                              style: const TextStyle(fontSize: 14),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ln
                                      .getString('Please retype your password');
                                }
                                return null;
                              },
                              decoration: InputDecoration(
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
                                      _repeatnewpasswordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _repeatnewpasswordVisible =
                                            !_repeatnewpasswordVisible;
                                      });
                                    },
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ConstantColors().greyFive),
                                      borderRadius: BorderRadius.circular(9)),
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
                                  hintText: ln.getString('Retype new password'),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 18)),
                            )),

                        //Login button ==================>
                        const SizedBox(
                          height: 13,
                        ),
                        Consumer<ChangePassService>(
                          builder: (context, provider, child) => CommonHelper()
                              .buttonPrimary("Change password", () {
                            if (provider.isloading == false) {
                              if (_formKey.currentState!.validate()) {
                                provider.changePassword(
                                    currentPasswordController.text,
                                    newPasswordController.text,
                                    repeatNewPasswordController.text,
                                    context);
                              }
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
