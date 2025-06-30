import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:fundorex/helper/extension/context_extension.dart';
import 'package:fundorex/helper/extension/int_extension.dart';
import 'package:fundorex/helper/extension/string_extension.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/pay_services/bank_transfer_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/view/payment/components/donation_details.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/custom_input.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

import '../../service/pay_services/payment_constants.dart';
import '../utils/tac_pp.dart';

class DonationPaymentChoosePage extends StatefulWidget {
  const DonationPaymentChoosePage({super.key, required this.campaignId});

  final campaignId;

  @override
  _DonationPaymentChoosePageState createState() =>
      _DonationPaymentChoosePageState();
}

class _DonationPaymentChoosePageState extends State<DonationPaymentChoosePage> {
  @override
  void initState() {
    super.initState();

    nameController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.name ??
        '';
    emailController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.email ??
        '';
    phoneController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.phone ??
        '';
    customAmountController.text =
        Provider.of<DonateService>(context, listen: false)
                .defaultDonateAmount ??
            '0';

    amountIndex = Provider.of<DonateService>(context, listen: false)
                .defaultDonateAmount !=
            null
        ? -1
        : 0;

    Provider.of<DonateService>(context, listen: false)
        .calculateInitialDonationAmount();
    Provider.of<DonateService>(context, listen: false).calculateTips();
  }

  int selectedMethod = -1;
  ValueNotifier<bool> termsAgree = ValueNotifier(false);
  bool annonymusDonate = false;
  late int amountIndex;
  int amountToDonate = 0;

  TextEditingController customAmountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon('Payment', context, () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
          physics: physicsCommon,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenPadding),
            child: Consumer<RtlService>(
              builder: (context, rtlP, child) => Consumer<AppStringService>(
                builder: (context, ln, child) => Consumer<PaymentChooseService>(
                  builder: (context, pgProvider, child) => pgProvider
                          .paymentList.isNotEmpty
                      ? Consumer<DonateService>(
                          builder: (context, dProvider, child) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Consumer<CampaignDetailsService>(
                                      builder: (context, cd, child) {
                                    return cd.campaignDetails?.rewardInfo ==
                                            null
                                        ? const SizedBox()
                                        : ListTile(
                                            tileColor: cc.orangeColor
                                                .withOpacity(0.10),
                                            leading: Image.network(
                                              cd.campaignDetails.rewardInfo
                                                  .image
                                                  .toString(),
                                              errorBuilder: (c, _, s) => Icon(
                                                Icons.celebration_outlined,
                                                color: cc.orangeColor,
                                              ),
                                            ),
                                            title: Text(
                                              cd.campaignDetails.rewardInfo
                                                  .heading
                                                  .toString()
                                                  .tr(),
                                              style: context.titleMedium?.bold6
                                                  .copyWith(
                                                color: cc.orangeColor,
                                              ),
                                            ),
                                            subtitle: cd.campaignDetails
                                                        .rewardInfo.amount ==
                                                    null
                                                ? null
                                                : Text(
                                                    "${cd.campaignDetails.rewardInfo.title.toString().tr()}: ${(cd.campaignDetails.rewardInfo.amount as num?)?.cur} ${cd.campaignDetails.rewardInfo.maxAmount == null ? "" : "${"below".tr()}: ${(cd.campaignDetails.rewardInfo.maxAmount as num?)?.cur}"}"),
                                          );
                                  }),
                                  12.toHeight,
                                  dProvider.amounts.isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (dProvider.minimumDonateAmount !=
                                                0)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 8),
                                                child: Text(
                                                  ln.getString(
                                                          "Minimum donation amount") +
                                                      ': ${dProvider.minimumDonateAmount}',
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: cc.secondaryColor,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            CommonHelper()
                                                .labelCommon("Pick an amount"),
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(top: 5),
                                              height: 55,
                                              child: ListView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                clipBehavior: Clip.none,
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          dProvider
                                                              .amounts.length;
                                                      i++)
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () {
                                                        if (amountIndex == i) {
                                                          return;
                                                        }

                                                        customAmountController
                                                                .text =
                                                            dProvider
                                                                .amounts[i];

                                                        dProvider
                                                            .setDonationAmount(
                                                                dProvider
                                                                    .amounts[i]);

                                                        setState(() {
                                                          amountIndex = i;
                                                        });
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 18),
                                                        margin: const EdgeInsets
                                                            .only(right: 20),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          color: amountIndex ==
                                                                  i
                                                              ? cc.primaryColor
                                                              : cc.greySecondary,
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "${rtlP.currency}${dProvider.amounts[i]}",
                                                          style: TextStyle(
                                                              color: amountIndex !=
                                                                      i
                                                                  ? cc.greyFour
                                                                  : Colors
                                                                      .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),

                                  sizedBoxCustom(20),
                                  //Name ============>
                                  CommonHelper()
                                      .labelCommon("Or enter an amount"),

                                  CustomInput(
                                    controller: customAmountController,
                                    hintText: "Amount",
                                    textInputAction: TextInputAction.next,
                                    isNumberField: true,
                                    paddingHorizontal: 20,
                                    onChanged: (v) {
                                      print(v);
                                      amountIndex = -1;
                                      if (v.isNotEmpty) {
                                        dProvider.setDonationAmount(v);
                                      } else {
                                        OthersHelper().showToast(
                                            ln.getString(
                                                'Amount must be greater than zero'),
                                            cc.warningColor);
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),

                                  //Name ============>
                                  CommonHelper().labelCommon("Name"),

                                  CustomInput(
                                    controller: nameController,
                                    validation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return ln.getString(
                                            'Please enter your name');
                                      }
                                      return null;
                                    },
                                    hintText: ln.getString("Name"),
                                    textInputAction: TextInputAction.next,
                                    paddingHorizontal: 20,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),

                                  //Name ============>
                                  CommonHelper().labelCommon("Email"),

                                  CustomInput(
                                    controller: emailController,
                                    validation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return ln.getString(
                                            'Please enter your email');
                                      }
                                      return null;
                                    },
                                    hintText: ln.getString("Email"),
                                    textInputAction: TextInputAction.next,
                                    paddingHorizontal: 20,
                                    marginBottom: 10,
                                  ),
                                  CommonHelper().labelCommon("Phone"),

                                  CustomInput(
                                    controller: phoneController,
                                    validation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return ln.getString(
                                            'Please enter your phone');
                                      }
                                      return null;
                                    },
                                    hintText: ln.getString("Phone"),
                                    textInputAction: TextInputAction.next,
                                    paddingHorizontal: 20,
                                    marginBottom: 10,
                                  ),

                                  CheckboxListTile(
                                    checkColor: Colors.white,
                                    activeColor: ConstantColors().primaryColor,
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        ln.getString('Donate anonymously'),
                                        style: TextStyle(
                                            color: ConstantColors().greyFour,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    ),
                                    value: annonymusDonate,
                                    onChanged: (newValue) {
                                      setState(() {
                                        annonymusDonate = !annonymusDonate;
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),

                                  const DonationDetails(),

                                  //border
                                  sizedBoxCustom(30),
                                  CommonHelper()
                                      .titleCommon('Choose payment method'),

                                  //payment method card
                                  GridView.builder(
                                    gridDelegate:
                                        const FlutterzillaFixedGridView(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 15,
                                            crossAxisSpacing: 15,
                                            height: 60),
                                    padding: const EdgeInsets.only(top: 30),
                                    itemCount: pgProvider.paymentList.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    clipBehavior: Clip.none,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedMethod = index;
                                          });

                                          //set key
                                          pgProvider.setKey(
                                              pgProvider.paymentList[
                                                  selectedMethod]['name'],
                                              index);

                                          //save selected payment method name
                                          // Provider.of<BookService>(context,
                                          //         listen: false)
                                          //     .setSelectedPayment(pgProvider
                                          //             .paymentList[selectedMethod]
                                          //         ['name']);
                                        },
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 60,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color:
                                                        selectedMethod == index
                                                            ? cc.primaryColor
                                                            : cc.borderColor),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: pgProvider
                                                        .paymentList[index]
                                                    ['logo_link'],
                                                placeholder: (context, url) {
                                                  return Image.asset(
                                                      'assets/images/placeholder.png');
                                                },
                                                // fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                            selectedMethod == index
                                                ? Positioned(
                                                    right: -7,
                                                    top: -9,
                                                    child: CommonHelper()
                                                        .checkCircle())
                                                : Container()
                                          ],
                                        ),
                                      );
                                    },
                                  ),

                                  selectedMethod != -1
                                      ? pgProvider.paymentList[selectedMethod]
                                                  ['name'] ==
                                              'manual_payment'
                                          ?
                                          //pick image ==========>
                                          Consumer<BankTransferService>(
                                              builder: (context, btProvider,
                                                      child) =>
                                                  Column(
                                                    children: [
                                                      if (pgProvider.paymentList[
                                                                  selectedMethod]
                                                              ['description'] !=
                                                          null) ...[
                                                        12.toHeight,
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color:
                                                                      cc.white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  border: Border
                                                                      .all(
                                                                    color: cc
                                                                        .borderColor,
                                                                  )),
                                                          child: HtmlWidget(
                                                              pgProvider.paymentList[
                                                                          selectedMethod]
                                                                      [
                                                                      'description'] ??
                                                                  ""),
                                                        )
                                                      ],
                                                      //pick image button =====>
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 30,
                                                          ),
                                                          CommonHelper()
                                                              .buttonPrimary(
                                                                  'Choose images',
                                                                  () {
                                                            btProvider
                                                                .pickImage(
                                                                    context);
                                                          }),
                                                        ],
                                                      ),
                                                      btProvider.pickedImage !=
                                                              null
                                                          ? Column(
                                                              children: [
                                                                const SizedBox(
                                                                  height: 30,
                                                                ),
                                                                SizedBox(
                                                                  height: 80,
                                                                  child:
                                                                      ListView(
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    shrinkWrap:
                                                                        true,
                                                                    children: [
                                                                      // for (int i = 0;
                                                                      //     i <
                                                                      //         btProvider
                                                                      //             .images!.length;
                                                                      //     i++)
                                                                      InkWell(
                                                                        onTap:
                                                                            () {},
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Container(
                                                                              margin: const EdgeInsets.only(right: 10),
                                                                              child: Image.file(
                                                                                // File(provider.images[i].path),
                                                                                File(btProvider.pickedImage.path),
                                                                                height: 80,
                                                                                width: 80,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Container(),
                                                    ],
                                                  ))
                                          : Container()
                                      : Container(),

                                  //Agreement checkbox ===========>
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TacPp(
                                    valueListenable: termsAgree,
                                    tTitle: "Terms & Condition".tr(),
                                    tData: dProvider.dTC,
                                    pTitle: "Privacy policy",
                                    pData: dProvider.dPP,
                                  ),

                                  //pay button =============>
                                  const SizedBox(
                                    height: 14,
                                  ),

                                  CommonHelper().buttonPrimary('Pay & Confirm',
                                      () {
                                    if (nameController.text.trim().isEmpty) {
                                      'Enter your name'.tr().showToast();

                                      return;
                                    }
                                    if (!emailController.text.validateEmail) {
                                      'Enter a valid email'.tr().showToast();

                                      return;
                                    }
                                    if (phoneController.text.trim().length <
                                        3) {
                                      'Enter a valid phone'.tr().showToast();

                                      return;
                                    }
                                    if (selectedMethod == -1) {
                                      'Please select a payment method'
                                          .tr()
                                          .showToast();

                                      return;
                                    }

                                    if (customAmountController.text.isEmpty &&
                                        amountIndex < 0) {
                                      'Please enter or select an amount'
                                          .tr()
                                          .showToast();

                                      return;
                                    }

                                    if (dProvider.minimumDonateAmount != 0 &&
                                        (num.parse(
                                                customAmountController.text) <
                                            dProvider.minimumDonateAmount)) {
                                      ('${"Amount must be greater than".tr()} ${dProvider.minimumDonateAmount}')
                                          .showToast();

                                      return;
                                    }

                                    if (termsAgree.value == false) {
                                      'You must agree with the terms and conditions'
                                          .tr()
                                          .showToast();
                                      return;
                                    }
                                    if (dProvider.isloading == true) {
                                      return;
                                    } else {
                                      dProvider.setUserEnteredNameEmail(
                                          nameController.text,
                                          emailController.text);
                                      payAction(
                                          pgProvider.paymentList[selectedMethod]
                                              ['name'],
                                          context,
                                          //if user selected bank transfer
                                          pgProvider.paymentList[selectedMethod]
                                                      ['name'] ==
                                                  'manual_payment'
                                              ? Provider.of<
                                                          BankTransferService>(
                                                      context,
                                                      listen: false)
                                                  .pickedImage
                                              : null,
                                          campaignId: widget.campaignId,
                                          name: nameController.text.trim(),
                                          email: emailController.text.trim(),
                                          phone: phoneController.text.trim(),
                                          anonymousDonate: annonymusDonate);
                                    }
                                  },
                                      isloading: dProvider.isloading == false
                                          ? false
                                          : true),

                                  sizedBoxCustom(40)
                                ]);
                          },
                        )
                      : Container(
                          margin: const EdgeInsets.only(top: 60),
                          child: OthersHelper().showLoading(cc.primaryColor),
                        ),
                ),
              ),
            ),
          ),
        ));
  }
}
