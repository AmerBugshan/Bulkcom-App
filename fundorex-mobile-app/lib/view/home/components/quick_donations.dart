import 'package:flutter/material.dart';
import 'package:fundorex/service/quick_donation_dropdown_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/view/payment/donation_payment_choose_page.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/custom_input.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

import '../../../service/campaign_details_service.dart';

import 'package:flutter/material.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';
import 'package:fundorex/view/supports/my_tickets_page.dart';


class QuickDonations extends StatelessWidget {
  const QuickDonations({super.key, required this.amountController});

  final amountController;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonHelper().titleCommon('لديك منتج لكن غير موجود؟'),
        sizedBoxCustom(18),

        // الزر فقط بدون دروب داون
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 310,
            child: CommonHelper().buttonPrimary(
              'اقترح منتجك الان!',
                  () {
                final isLoggedIn = Provider.of<ProfileService>(context, listen: false)
                    .profileDetails !=
                    null;

                if (isLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyTicketsPage()),
                  );

                } else {

                  OthersHelper().showToast('يجب تسجيل الدخول أولاً', Colors.black);
                  Navigator.pushNamed(context, '/login');
                }
              },
              paddingVertical: 16,
              borderRadius: 5,
            ),
          ),
        )
      ],
    );
  }
}
