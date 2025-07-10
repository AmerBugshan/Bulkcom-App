import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/view/payment/const_styles.dart';
import 'package:fundorex/view/utils/common_helper.dart';
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: Consumer<AppStringService>(
        builder: (context, ln, child) => Consumer<DonateService>(
          builder: (context, provider, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonHelper().titleCommon('فاتورتك'),
              SizedBox(height: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Donation amount (safe)
                  ConstStyles().detailsPanelRowWithDollar(
                    ln.getString('السعر'),
                    0,
                    (provider.donationAmount ?? 0.0).toStringAsFixed(1),
                  ),

                  SizedBox(height: 13),

                  // Transaction Fee (safe)
                  if (provider.transactionFeeType != null)
                    ConstStyles().detailsPanelRowWithDollar(
                      ln.getString('ضريبة الشحن') +
                          (provider.transactionFeeType == "percentage"
                              ? " (${provider.transactionFee}%)"
                              : ""),
                      0,
                      (provider.transactionFeeAmount ?? 0.0).toStringAsFixed(1),
                    ),

                  // Divider
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 17),
                    child: CommonHelper().dividerCommon(),
                  ),

                  // Total (Donation + Transaction Fee)
                  ConstStyles().detailsPanelRowWithDollar(
                    'Total',
                    0,
                    ((provider.donationAmount ?? 0.0) +
                        (provider.transactionFeeAmount ?? 0.0))
                        .toStringAsFixed(1),
                    priceFontSize: 18,
                    priceFontweight: FontWeight.bold,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
