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
                  builder: (context, pgProvider, child) => Consumer<DonateService>(
                    builder: (context, dProvider, child) {
                      final manualPayment = pgProvider.paymentList.firstWhere(
                            (e) => e['name'] == 'manual_payment',
                        orElse: () => null,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonHelper().labelCommon("Or enter an amount"),
                          CustomInput(
                            controller: customAmountController,
                            hintText: "Amount",
                            isNumberField: true,
                            paddingHorizontal: 20,
                            onChanged: (v) {
                              amountIndex = -1;
                              if (v.isNotEmpty) {
                                dProvider.setDonationAmount(v);
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          CommonHelper().labelCommon("Name"),
                          CustomInput(
                            controller: nameController,
                            hintText: ln.getString("Name"),
                            paddingHorizontal: 20,
                          ),
                          const SizedBox(height: 8),
                          CommonHelper().labelCommon("Email"),
                          CustomInput(
                            controller: emailController,
                            hintText: ln.getString("Email"),
                            paddingHorizontal: 20,
                            marginBottom: 10,
                          ),
                          CommonHelper().labelCommon("Phone"),
                          CustomInput(
                            controller: phoneController,
                            hintText: ln.getString("Phone"),
                            paddingHorizontal: 20,
                            marginBottom: 10,
                          ),
                          CheckboxListTile(
                            checkColor: Colors.white,
                            activeColor: cc.primaryColor,
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              ln.getString('Donate anonymously'),
                              style: TextStyle(
                                  color: cc.greyFour,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                            value: annonymusDonate,
                            onChanged: (newValue) {
                              setState(() {
                                annonymusDonate = !annonymusDonate;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          const DonationDetails(),

                          if (manualPayment != null) ...[
                            CommonHelper().labelCommon("Choose payment method"),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedMethod = pgProvider.paymentList.indexOf(manualPayment);
                                });

                                pgProvider.setKey('manual_payment', selectedMethod);
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 60,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: selectedMethod == pgProvider.paymentList.indexOf(manualPayment)
                                            ? cc.primaryColor
                                            : cc.borderColor,
                                      ),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: manualPayment['logo_link'],
                                      errorWidget: (context, url, error) => Image.asset(
                                        'assets/images/bank_transfer.png',
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                  if (selectedMethod == pgProvider.paymentList.indexOf(manualPayment))
                                    Positioned(
                                      right: -7,
                                      top: -9,
                                      child: CommonHelper().checkCircle(),
                                    ),
                                ],
                              ),
                            ),

                            Consumer<BankTransferService>(
                              builder: (context, btProvider, child) => Column(
                                children: [
                                  if (manualPayment['description'] != null) ...[
                                    12.toHeight,
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          color: cc.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: cc.borderColor,
                                          )),
                                      child: HtmlWidget(manualPayment['description']),
                                    )
                                  ],
                                  const SizedBox(height: 30),
                                  CommonHelper().buttonPrimary('Choose images', () {
                                    btProvider.pickImage(context);
                                  }),
                                  if (btProvider.pickedImage != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Image.file(
                                        File(btProvider.pickedImage.path),
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),
                          TacPp(
                            valueListenable: termsAgree,
                            tTitle: "Terms & Condition".tr(),
                            tData: dProvider.dTC,
                            pTitle: "Privacy policy",
                            pData: dProvider.dPP,
                          ),
                          const SizedBox(height: 14),
                          CommonHelper().buttonPrimary('Pay & Confirm', () {
                            if (nameController.text.trim().isEmpty ||
                                !emailController.text.validateEmail ||
                                phoneController.text.trim().length < 3 ||
                                (customAmountController.text.isEmpty &&
                                    amountIndex < 0) ||
                                (dProvider.minimumDonateAmount != 0 &&
                                    (num.parse(customAmountController.text) <
                                        dProvider.minimumDonateAmount)) ||
                                !termsAgree.value) {
                              'Please fill all required fields properly'
                                  .tr()
                                  .showToast();
                              return;
                            }

                            dProvider.setUserEnteredNameEmail(
                                nameController.text, emailController.text);

                            final btProvider =
                            Provider.of<BankTransferService>(context,
                                listen: false);

                            payAction(
                              'manual_payment',
                              context,
                              btProvider.pickedImage,
                              campaignId: widget.campaignId,
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              phone: phoneController.text.trim(),
                              anonymousDonate: annonymusDonate,
                            );
                          }, isloading: dProvider.isloading),
                          sizedBoxCustom(40)
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
