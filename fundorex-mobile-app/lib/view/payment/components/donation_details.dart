import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/view/payment/const_styles.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class DonationDetails extends StatelessWidget {
  const DonationDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          border: Border.all(color: cc.borderColor),
          borderRadius: BorderRadius.circular(8)),
      child: Consumer<AppStringService>(
        builder: (context, ln, child) => Consumer<DonateService>(
          builder: (context, provider, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonHelper().titleCommon('Your Donation Details'),
              sizedBoxCustom(18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Donation details

                  ConstStyles().detailsPanelRowWithDollar(
                      ln.getString('Donation'),
                      0,
                      provider.donationAmount.toStringAsFixed(1)),

                  sizedBoxCustom(13),

                  if (provider.chargeDonateFrom == 'donor' &&
                      provider.chargeActiveButton == 'on')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Fundorex " + ln.getString('Tip'),
                          style: TextStyle(
                            color: cc.greyFour,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          height: 40,
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: cc.borderColor, width: 1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              //decrease quanityt
                              if (provider.allowCustomTip == 'on')
                                InkWell(
                                  onTap: () {
                                    provider.decreaseTips();
                                  },
                                  child: Container(
                                    width: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.red,
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 19,
                                    ),
                                  ),
                                ),

                              // amount
                              Consumer<RtlService>(
                                builder: (context, rtlP, child) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    rtlP.currencyDirection == 'left'
                                        ? rtlP.currency +
                                            provider.tips.toStringAsFixed(1)
                                        : provider.tips.toStringAsFixed(1) +
                                            rtlP.currency,
                                    style: TextStyle(
                                      color: cc.greyPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              //increase quantity
                              if (provider.allowCustomTip == 'on')
                                InkWell(
                                  onTap: () {
                                    provider.increaseTips();
                                  },
                                  child: Container(
                                    width: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: cc.successColor,
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 19,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  if (provider.transactionFeeType != null)
                    ConstStyles().detailsPanelRowWithDollar(
                        ln.getString('Transaction Fee') +
                            (provider.transactionFeeType == "percentage"
                                ? " (${provider.transactionFee}%)"
                                : ""),
                        0,
                        provider.transactionFeeAmount.toStringAsFixed(1)),
                  //border
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 17),
                    child: CommonHelper().dividerCommon(),
                  ),

                  ConstStyles().detailsPanelRowWithDollar('Total', 0,
                      "${((provider.donationAmountWithTips ?? 0) + provider.transactionFeeAmount).round()}",
                      priceFontSize: 18, priceFontweight: FontWeight.bold),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
