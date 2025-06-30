import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/reward_points_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/view/payment/const_styles.dart';
import 'package:fundorex/view/reward_points/components/redeem_popup.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:fundorex/view/utils/responsive.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class RewardPointsPage extends StatelessWidget {
  const RewardPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<RewardPointsService>(context, listen: false)
        .fetchRewardPoints(context);
    var appbarTxt = Provider.of<AppStringService>(context, listen: false)
        .getString('Reward points');
    ConstantColors cc = ConstantColors();
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: cc.greyPrimary),
        title: Text(
          appbarTxt,
          style: TextStyle(
              color: cc.greyPrimary, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
        ),
        actions: [
          Consumer<AppStringService>(
            builder: (context, ln, child) => Container(
              width: screenWidth / 4,
              padding: const EdgeInsets.symmetric(
                vertical: 9,
              ),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => const ReedemPointPopup());
                },
                child: Container(
                    // width: double.infinity,

                    alignment: Alignment.center,
                    // padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: cc.primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: AutoSizeText(
                      ln.getString('Redeem'),
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    )),
              ),
            ),
          ),
          const SizedBox(
            width: 25,
          ),
        ],
      ),
      backgroundColor: cc.bgGrey,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: screenPadding, vertical: 25),
          child: Consumer<RewardPointsService>(
              builder: (context, provider, child) => provider.hasData == true
                  ? provider.rewardPointsList.isNotEmpty
                      ? Consumer<RtlService>(
                          builder: (context, rtlP, child) => Column(children: [
                            //card
                            for (int i = 0;
                                i < provider.rewardPointsList.length;
                                i++)
                              Container(
                                margin: const EdgeInsets.only(bottom: 25),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonHelper().titleCommon(
                                          provider.rewardPointsList[i].cause
                                                  .title ??
                                              '',
                                          fontsize: 17),
                                      sizedBoxCustom(19),
                                      ConstStyles().commonRow('ID',
                                          '#${provider.rewardPointsList[i].causeId}'),
                                      ConstStyles().commonRow('Points',
                                          '${provider.rewardPointsList[i].rewardPoint}'),
                                      ConstStyles().commonRow(
                                          'Amount',
                                          rtlP.currencyDirection == 'left'
                                              ? '${rtlP.currency}${provider.rewardPointsList[i].rewardAmount}'
                                              : '${provider.rewardPointsList[i].rewardAmount}${rtlP.currency}',
                                          lastBorder: true),
                                    ]),
                              )
                          ]),
                        )
                      : Container(
                          height: screenHeight - 170,
                          alignment: Alignment.center,
                          child: OthersHelper().showLoading(cc.primaryColor),
                        )
                  : OthersHelper().showError(context, 'No data found')),
        ),
      )),
    );
  }
}
