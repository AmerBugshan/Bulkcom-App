import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/profile_edit_service.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/custom_input.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../auth/signup/components/country_states_dropdowns.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController zipController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  TextEditingController cityController = TextEditingController();
  // String? countryCode;
  // TextEditingController aboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // countryCode = Provider.of<ProfileService>(context, listen: false)
    //     .profileDetails
    //     .countryCode;
    // //set country code
    // Future.delayed(const Duration(milliseconds: 600), () {
    //   Provider.of<ProfileEditService>(context, listen: false)
    //       .setCountryCode(countryCode);
    // });

    fullNameController.text =
        Provider.of<ProfileService>(context, listen: false)
                .profileDetails
                .name ??
            '';
    emailController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .email ??
        '';

    cityController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .city ??
        '';
    stateController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .state ??
        '';

    phoneController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .phone ??
        '';
    zipController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .zipcode ??
        '';
    addressController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .address ??
        '';
  }

  late AnimationController localAnimationController;
  XFile? pickedImage;
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('Edit profile', context, () {
        if (Provider.of<ProfileEditService>(context, listen: false).isloading ==
            false) {
          Navigator.pop(context);
        } else {
          var txt = 'Please wait while the profile is updating';
          txt = Provider.of<AppStringService>(context, listen: false)
              .getString(txt);
          OthersHelper().showToast(txt, Colors.black);
        }
      }),
      body: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: Consumer<AppStringService>(
          builder: (context, ln, child) => Consumer<ProfileEditService>(
            builder: (context, provider, child) => WillPopScope(
              onWillPop: () {
                if (provider.isloading == false) {
                  return Future.value(true);
                } else {
                  OthersHelper().showToast(
                      ln.getString('Please wait while the profile is updating'),
                      Colors.black);
                  return Future.value(false);
                }
              },
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //pick profile image
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          pickedImage = await provider.pickImage();
                          setState(() {});
                        },
                        child: SizedBox(
                          width: 105,
                          height: 105,
                          child: Stack(
                            children: [
                              Consumer<ProfileService>(
                                builder: (context, profileProvider, child) =>
                                    Container(
                                  width: 100,
                                  height: 100,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(5),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: pickedImage == null
                                          ? profileProvider
                                                      .profileDetails?.image !=
                                                  null
                                              ? CommonHelper().profileImage(
                                                  profileProvider
                                                      .profileDetails.image,
                                                  85,
                                                  85)
                                              : Image.asset(
                                                  'assets/images/avatar.png',
                                                  height: 85,
                                                  width: 85,
                                                  fit: BoxFit.cover,
                                                )
                                          : Image.file(
                                              File(pickedImage!.path),
                                              height: 85,
                                              width: 85,
                                              fit: BoxFit.cover,
                                            )),
                                ),
                              ),
                              Positioned(
                                bottom: 9,
                                right: 12,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: ClipRRect(
                                      child: Icon(
                                    Icons.camera,
                                    color: cc.greyPrimary,
                                  )),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 25,
                      ),

                      //Email, name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Name ============>
                          CommonHelper().labelCommon("Full name"),

                          CustomInput(
                            controller: fullNameController,
                            paddingHorizontal: 18,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln
                                    .getString('Please enter your full name');
                              }
                              return null;
                            },
                            hintText: ln.getString("Enter your full name"),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 8,
                          ),

                          //Email ============>
                          CommonHelper().labelCommon("Email"),

                          CustomInput(
                            controller: emailController,
                            paddingHorizontal: 18,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln.getString('Please enter your email');
                              }
                              return null;
                            },
                            hintText: ln.getString("Enter your email"),
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          //Phone ============>
                          CommonHelper().labelCommon("Phone"),

                          CustomInput(
                            controller: phoneController,
                            paddingHorizontal: 18,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln.getString('Please enter your phone');
                              }
                              return null;
                            },
                            hintText: ln.getString("Enter your phone"),
                            textInputAction: TextInputAction.next,
                            isNumberField: true,
                          ),

                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),

                      //phone
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     CommonHelper().labelCommon("Phone"),
                      //     Consumer<RtlService>(
                      //       builder: (context, rtlP, child) => IntlPhoneField(
                      //         controller: phoneController,
                      //         decoration: SignupHelper().phoneFieldDecoration(),
                      //         initialCountryCode: countryCode,
                      //         textAlign: rtlP.direction == 'ltr'
                      //             ? TextAlign.left
                      //             : TextAlign.right,
                      //         onCountryChanged: (country) {
                      //           provider.setCountryCode(country.code);
                      //         },
                      //         onChanged: (phone) {
                      //           provider.setCountryCode(phone.countryISOCode);
                      //         },
                      //       ),
                      //     ),
                      //     CommonHelper().labelCommon("Post code"),
                      //     CustomInput(
                      //       controller: postCodeController,
                      //       validation: (value) {
                      //         if (value == null || value.isEmpty) {
                      //           return 'Please enter post code';
                      //         }
                      //         return null;
                      //       },
                      //       isNumberField: true,
                      //       hintText: "Enter your post code",
                      //       icon: 'assets/icons/user.png',
                      //       textInputAction: TextInputAction.next,
                      //     ),
                      //   ],
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 3,
                          ),

                          //dropdowns
                          CountryStatesDropdowns(
                            cityController: cityController,
                          ),

                          //state ============>
                          CommonHelper().labelCommon("State"),

                          CustomInput(
                            controller: stateController,
                            paddingHorizontal: 18,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln.getString('Please enter your state');
                              }
                              return null;
                            },
                            hintText: ln.getString("Enter your state"),
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          //zip ============>
                          CommonHelper().labelCommon("Zip"),

                          CustomInput(
                            controller: zipController,
                            paddingHorizontal: 18,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln.getString('Please enter your zip');
                              }
                              return null;
                            },
                            hintText: ln.getString("Enter your zip"),
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          //address ============>
                          CommonHelper().labelCommon("Address"),

                          CustomInput(
                            controller: addressController,
                            paddingHorizontal: 18,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln
                                    .getString('Please enter your address');
                              }
                              return null;
                            },
                            hintText: ln.getString("Enter your address"),
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 15,
                      ),
                      CommonHelper().buttonPrimary('Save', () async {
                        if (provider.isloading == false) {
                          if (addressController.text.isEmpty) {
                            OthersHelper().showToast(
                                ln.getString('Address field is required'),
                                Colors.black);
                            return;
                          } else if (phoneController.text.isEmpty) {
                            OthersHelper().showToast(
                                ln.getString('Phone field is required'),
                                Colors.black);
                            return;
                          }
                          showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.success(
                                message: ln.getString(
                                    "Updating profile...It may take few seconds"),
                              ),
                              persistent: true,
                              onAnimationControllerInit: (controller) =>
                                  localAnimationController = controller,
                              onTap: () {
                                // localAnimationController.reverse();
                              });

                          //update profile
                          var result = await provider.updateProfile(
                              name: fullNameController.text.trim(),
                              email: emailController.text.trim(),
                              phone: phoneController.text.trim(),
                              state: stateController.text.trim(),
                              city: cityController.text.trim(),
                              zipcode: zipController.text.trim(),
                              address: addressController.text.trim(),
                              imagePath: pickedImage?.path,
                              context: context);
                          if (result == true) {
                            Navigator.pop(context);
                            localAnimationController.reverse();
                          }
                          localAnimationController.reverse();
                        }
                      }, isloading: provider.isloading == false ? false : true),

                      const SizedBox(
                        height: 38,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
