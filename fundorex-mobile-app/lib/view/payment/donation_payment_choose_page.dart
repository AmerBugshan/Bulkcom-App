import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fundorex/helper/extension/context_extension.dart';
import 'package:fundorex/helper/extension/int_extension.dart';
import 'package:fundorex/helper/extension/string_extension.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/pay_services/bank_transfer_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/service/campaign_details_service.dart';
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
  final dynamic campaignId;

  @override
  _DonationPaymentChoosePageState createState() => _DonationPaymentChoosePageState();
}

class _DonationPaymentChoosePageState extends State<DonationPaymentChoosePage> {
  int selectedMethod = -1;
  ValueNotifier<bool> termsAgree = ValueNotifier(false);
  bool annonymusDonate = false;
  late int amountIndex;

  TextEditingController customAmountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final profile = Provider.of<ProfileService>(context, listen: false).profileDetails;
    if (profile == null) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return;
    }

    nameController.text = profile.name ?? '';
    emailController.text = profile.email ?? '';
    phoneController.text = profile.phone ?? '';
    customAmountController.text = '1';
    amountIndex = -1;

    final donateService = Provider.of<DonateService>(context, listen: false);
    donateService.calculateInitialDonationAmount();
    donateService.calculateTips();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('الدفع', context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        physics: physicsCommon,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenPadding),
          child: Consumer4<RtlService, AppStringService, PaymentChooseService, DonateService>(
            builder: (context, rtlP, ln, pgProvider, dProvider, child) {
              final campaignProvider = Provider.of<CampaignDetailsService>(context, listen: false);
              final campaign = campaignProvider.campaignDetails;

              final pricePerUnit = num.tryParse(campaign.unitPrice?.toString() ?? '0') ?? 0;
              final totalAvailable = num.tryParse(campaign.availableQuantity?.toString() ?? '0') ?? 0;
              final maxAllowed = totalAvailable < 10 ? totalAvailable : 10;

              final selectedUnits = num.tryParse(customAmountController.text) ?? 1;
              final limitedUnits = selectedUnits > maxAllowed ? maxAllowed : selectedUnits;

              final manualPayment = pgProvider.paymentList.firstWhere(
                    (e) => e['name'] == 'manual_payment',
                orElse: () => null,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonHelper().labelCommon("اسم المنتج"),
                  Text(campaign.titleAr ?? campaign.title ?? '-', style: TextStyle(fontSize: 16)),
                  10.toHeight,
                  CommonHelper().labelCommon("سعر الوحدة"),
                  Text("$pricePerUnit \$", style: TextStyle(fontSize: 16)),
                  10.toHeight,
                  CommonHelper().labelCommon("الكمية المتوفرة"),
                  Text("$totalAvailable (الحد الأقصى: $maxAllowed)", style: TextStyle(fontSize: 16)),
                  20.toHeight,

                  CommonHelper().labelCommon("الكمية المطلوبة"),
                  CustomInput(
                    controller: customAmountController,
                    hintText: "كمية المنتج",
                    isNumberField: true,
                    paddingHorizontal: 20,
                    onChanged: (v) {
                      setState(() {});
                      final dProvider = Provider.of<DonateService>(context, listen: false);
                      final selectedUnits = int.tryParse(v) ?? 1;
                      final pricePerUnit = num.tryParse(campaign.unitPrice?.toString() ?? '0') ?? 0;
                      dProvider.setDonationAmount(pricePerUnit * selectedUnits);
                    },
                  ),
                  10.toHeight,
                  if(false)...[
                  CommonHelper().labelCommon("السعر الإجمالي"),
                  Text("\$${(dProvider.donationAmount ?? 0.0).toStringAsFixed(1)}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  20.toHeight],

                  CommonHelper().labelCommon("Name"),
                  CustomInput(
                    controller: nameController,
                    hintText: ln.getString("Name"),
                    paddingHorizontal: 20,
                  ),
                  10.toHeight,

                  CommonHelper().labelCommon("Email"),
                  CustomInput(
                    controller: emailController,
                    hintText: ln.getString("Email"),
                    paddingHorizontal: 20,
                  ),
                  10.toHeight,

                  CommonHelper().labelCommon("Phone"),
                  CustomInput(
                    controller: phoneController,
                    hintText: ln.getString("Phone"),
                    paddingHorizontal: 20,
                    marginBottom: 10,
                  ),

                  const DonationDetails(),

                  if (manualPayment != null) ...[
                    CommonHelper().labelCommon("إختر طريقة الدفع"),
                    16.toHeight,
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
                  ],

                  Consumer<BankTransferService>(
                    builder: (context, btProvider, child) => Column(
                      children: [
                        if (manualPayment != null && manualPayment['description'] != null) ...[
                          12.toHeight,
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: cc.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: cc.borderColor),
                            ),
                            child: HtmlWidget(manualPayment['description']),
                          ),
                        ],
                        30.toHeight,
                        CommonHelper().buttonPrimary('أرفق صورة', () {
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
                          ),
                      ],
                    ),
                  ),

                  20.toHeight,

                  TacPp(
                    valueListenable: termsAgree,
                    tTitle: "الشروط و الأحكام".tr(),
                    tData: dProvider.dTC,
                    pTitle: "سياسة الخصوصية",
                    pData: dProvider.dPP,
                  ),

                  14.toHeight,

                  CommonHelper().buttonPrimary('إتمام الدفع', () {
                    if (nameController.text.trim().isEmpty ||
                        !emailController.text.validateEmail ||
                        phoneController.text.trim().length < 3 ||
                        limitedUnits <= 0 ||
                        !termsAgree.value) {
                      'Please fill all required fields properly'.tr().showToast();
                      return;
                    }

                    dProvider.setUserEnteredNameEmail(
                      nameController.text,
                      emailController.text,
                    );

                    final btProvider = Provider.of<BankTransferService>(context, listen: false);

                    final pricePerUnit = num.tryParse(campaign.unitPrice?.toString() ?? '0') ?? 0;
                    final totalPrice = pricePerUnit * limitedUnits;

                    // ✅ إرسال عدد الوحدات والسعر الإجمالي إلى donatePay
                    dProvider.donatePay(
                      context,
                      btProvider.pickedImage?.path,
                      isManualOrCod: true,
                      selectedPaymentName: 'manual_payment',
                      campaignId: widget.campaignId,
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      phone: phoneController.text.trim(),
                      amount: limitedUnits,
                      total: totalPrice,
                    );
                  }, isloading: dProvider.isloading),

                  40.toHeight,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
